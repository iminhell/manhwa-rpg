#!/usr/bin/env python3
"""
Validateur de cohérence des données du jeu (lore, variables, scripts, combat, monde, art).

Lancer : python3 tools/validate_data.py      (code de sortie 1 s'il y a des erreurs)

Erreurs : références cassées (bloc, rencontre, nœud, dialogue, souvenir, Fin, personnage, compétence),
conditions invalides, effets inconnus, drapeaux ou variables LUS mais jamais ÉCRITS (orphelins),
défaites de combat non gérées, personnages romançables mineurs, etc.
CG (art) : toute CG appelée doit être au manifeste, toute CG du manifeste doit être appelée par sa scène (« scene »),
chaque nuit (drapeau <id>_nuit, trio_nuit, nuit_maison…) affiche une CG, et une CG « nsfw » passe par RunPod.
Avertissements : drapeaux écrits mais jamais lus, blocs inatteignables, décors absents du manifeste.
"""
from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"

errors: list[str] = []
warnings: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)


def warn(msg: str) -> None:
    warnings.append(msg)


def load(p: Path) -> dict:
    try:
        return json.loads(p.read_text(encoding="utf-8"))
    except Exception as e:  # noqa: BLE001
        err(f"{p.relative_to(ROOT)} : JSON invalide ({e})")
        return {}


def load_dir(d: Path) -> dict:
    out = {}
    for p in sorted(d.glob("*.json")):
        j = load(p)
        out[j.get("id", p.stem)] = j
    return out


characters = load_dir(DATA / "characters")
skills = load(DATA / "combat/skills.json").get("skills", {})
enemies = load(DATA / "combat/enemies.json").get("enemies", {})
encounters = load(DATA / "combat/encounters.json").get("encounters", {})
dialogues = load_dir(DATA / "dialogues")
world = load(DATA / "world/sectors.json")
sectors = world.get("sectors", {})
events = load(DATA / "world/events.json").get("events", [])
souvenirs = load(DATA / "world/souvenirs.json").get("souvenirs", {})
echoes = load(DATA / "world/echoes.json").get("echoes", {})
gifts = load(DATA / "world/gifts.json").get("gifts", {})
difficulty = load(DATA / "world/difficulty.json")
resilience = load(DATA / "world/resilience.json")
fins = load(DATA / "world/fins.json").get("fins", {})
gallery = load(DATA / "world/gallery.json")
items_cat = load(DATA / "world/items.json")
guide = load(DATA / "world/guide.json")
prompts = load(DATA / "art/prompts.json")
manifest = load(DATA / "art/manifest.json").get("assets", [])
music_path = DATA / "audio/music.json"
music = load(music_path) if music_path.exists() else {}

all_nodes = {nid: n for s in sectors.values() for nid, n in s.get("nodes", {}).items()}
art_chars = {c["id"]: c for c in prompts.get("characters", [])}
COMMON_EXPR = set(prompts.get("expressions", {}).keys())
SPECIAL_SPEAKERS = {"narrator", "system", "registre"}
KNOWN_EVENTS = {"combat", "regress", "end_act", "world", "move"}
EFFECT_TYPES = {"damage", "heal", "status", "fear", "delay", "haste", "revive", "cleanse", "crit_next", "swap", "advance", "awaken", "pull"}
TARGETS = {"melee", "ranged", "pierce", "row", "all_enemies", "ally", "all_allies", "all_allies_any", "ally_other", "self", "ally_ko"}
FUNCS = {"v", "flag", "souvenir", "aff", "loop", "day", "phase", "at", "in_sector", "party", "item", "money",
         "trust", "fear", "done", "knows_fin", "pressure", "ticks", "in_refuge_sector", "mode", "ir", "party_size", "bonds", "in_tower", "voie"}
VOIES = {"heros", "tyran", "loup", "mercenaire", ""}
KEYWORDS = {"and", "or", "not", "true", "false", "null"}
FX_OPS = {"set": 2, "add": 2, "flag": 1, "unflag": 1, "souvenir": 1, "item": 2, "money": 1, "fin": 1, "join": 1, "leave": 1, "pressure": 1}

# Écritures implicites faites par le code (GDScript)
IMPLICIT_VARS = {"combat.last", "pos.node", "pos.sector", "pos.refuge", "time.ticks", "fatigue", "loop", "argent", "tower.p_mod",
                 "refuge.node", "refuge.sector", "refuge.rations", "refuge.defense", "refuge.faim", "refuge.last_day",
                 "difficulte", "repit.debut", "repit.compte"}
SYSTEM_PREFIXES = ("align.", "aff.", "trust.", "fear.", "ambivalence.")  # consommées par les systèmes

flags_read: dict[str, set] = defaultdict(set)
flags_written: dict[str, set] = defaultdict(set)
vars_read: dict[str, set] = defaultdict(set)
vars_written: dict[str, set] = defaultdict(set)
items_read: dict[str, set] = defaultdict(set)
items_written: dict[str, set] = defaultdict(set)
souv_read: dict[str, set] = defaultdict(set)
souv_written: dict[str, set] = defaultdict(set)
done_read: dict[str, set] = defaultdict(set)
dialogue_refs: set[tuple[str, str]] = set()


def check_condition(cond: str, where: str) -> None:
    if not cond:
        return
    if cond.count("(") != cond.count(")"):
        err(f"{where} : parenthèses déséquilibrées dans « {cond} »")
    for fn, arg in re.findall(r"(\w+)\(\s*'([^']*)'\s*(?:,[^)]*)?\)", cond):
        if fn == "flag":
            flags_read[arg].add(where)
            if arg.startswith("echo."):
                if arg[5:] not in echoes:
                    err(f"{where} : écho inconnu « {arg} » (data/world/echoes.json)")
                if "loop()" not in cond:
                    err(f"{where} : chronologie — l'écho « {arg} » ne peut se lire qu'en boucle 2+ (ajouter une garde loop())")
        elif fn == "v":
            vars_read[arg].add(where)
        elif fn == "souvenir":
            souv_read[arg].add(where)
            if arg not in souvenirs:
                err(f"{where} : souvenir inconnu « {arg} »")
        elif fn == "item":
            items_read[arg].add(where)
        elif fn in ("aff", "trust", "fear", "party"):
            if arg not in characters:
                err(f"{where} : personnage inconnu « {arg} » dans {fn}()")
        elif fn == "knows_fin":
            if arg not in fins:
                err(f"{where} : Fin inconnue « {arg} »")
        elif fn == "at":
            if arg not in all_nodes:
                err(f"{where} : nœud inconnu « {arg} » dans at()")
        elif fn == "in_sector":
            if arg not in sectors:
                err(f"{where} : secteur inconnu « {arg} »")
        elif fn == "done":
            done_read[arg].add(where)
    for val in re.findall(r"voie\(\)\s*[!=]=\s*'([^']*)'", cond):
        if val not in VOIES:
            err(f"{where} : voie inconnue « {val} » (heros, tyran, loup, mercenaire)")
    stripped = re.sub(r"'[^']*'", "''", cond)
    for ident in re.findall(r"[A-Za-z_]\w*", stripped):
        if ident not in FUNCS and ident not in KEYWORDS:
            err(f"{where} : identifiant inconnu « {ident} » dans « {cond} »")


def check_effects(fx: list, where: str) -> None:
    for e in fx:
        parts = str(e).split()
        if not parts or parts[0] not in FX_OPS:
            err(f"{where} : effet inconnu « {e} »")
            continue
        op = parts[0]
        if len(parts) - 1 < FX_OPS[op] and op not in ("item", "add", "set"):
            err(f"{where} : effet incomplet « {e} »")
        if op in ("flag", "unflag"):
            flags_written[parts[1]].add(where)
        elif op in ("set", "add"):
            vars_written[parts[1]].add(where)
        elif op == "item":
            items_written[parts[1]].add(where)
        elif op == "souvenir":
            souv_written[parts[1]].add(where)
            if parts[1] not in souvenirs:
                err(f"{where} : souvenir inconnu « {parts[1]} »")
        elif op == "fin":
            if parts[1] not in fins:
                err(f"{where} : Fin inconnue « {parts[1]} »")
        elif op in ("join", "leave"):
            if parts[1] not in characters:
                err(f"{where} : personnage inconnu « {parts[1]} »")
            flags_written["party." + parts[1]].add(where)
        elif op == "money":
            vars_written["argent"].add(where)


def ref_dialogue(ref: str, where: str) -> None:
    if ":" not in ref:
        err(f"{where} : référence de dialogue sans bloc « {ref} » (format fichier:bloc)")
        return
    did, block = ref.split(":", 1)
    if did not in dialogues:
        err(f"{where} : dialogue inconnu « {did} »")
    elif block not in dialogues[did].get("blocks", {}):
        err(f"{where} : bloc inconnu « {ref} »")
    dialogue_refs.add((did, block))


# --- Personnages & art -------------------------------------------------------------
for cid, c in characters.items():
    w = f"characters/{cid}"
    if int(c.get("age", 0)) < 18:
        err(f"{w} : âge {c.get('age')} < 18 (interdit)")
    if len(c.get("palette", [])) < 3:
        err(f"{w} : palette incomplète")
    if cid not in art_chars:
        err(f"{w} : absent de data/art/prompts.json")
    elif art_chars[cid]["token"] != c.get("art_token"):
        err(f"{w} : art_token ≠ token des prompts")
    for sid in c.get("combat", {}).get("skills", []):
        if sid not in skills:
            err(f"{w} : compétence inconnue « {sid} »")
for cid, a in art_chars.items():
    if cid not in characters:
        err(f"art/prompts : personnage sans fiche « {cid} »")
    if int(a.get("age", 0)) < 18:
        err(f"art/prompts/{cid} : âge < 18")
outs = set()
manifest_bg, manifest_cg = set(), set()
for item in manifest:
    w = f"art/manifest/{item.get('id')}"
    if item.get("out") in outs:
        err(f"{w} : chemin de sortie en double")
    outs.add(item.get("out"))
    for ch in ([item["char"]] if item.get("char") else item.get("chars", [])):
        if ch not in art_chars:
            err(f"{w} : personnage inconnu « {ch} »")
    if item.get("kind") == "background":
        manifest_bg.add(Path(item["out"]).stem)
    if item.get("kind") == "cg":
        manifest_cg.add(Path(item["out"]).stem)
        if Path(item["out"]).stem != item.get("id"):
            err(f"{w} : l'identifiant d'une CG doit être le nom de son fichier")
        if item.get("nsfw") and item.get("backend") != "runpod":
            err(f"{w} : CG « nsfw » sans « backend »: « runpod » (fal.ai la refuserait)")
        if ":" not in str(item.get("scene", "")):
            err(f"{w} : CG sans scène (« scene »: « dialogue:bloc » qui l'affiche)")

# --- Combat ----------------------------------------------------------------------------
for sid, s in skills.items():
    if s.get("target") not in TARGETS:
        err(f"skills/{sid} : cible inconnue « {s.get('target')} »")
    for e in s.get("effects", []) + s.get("self_effects", []):
        if e.get("type") not in EFFECT_TYPES:
            err(f"skills/{sid} : effet inconnu « {e.get('type')} »")
for eid, e in enemies.items():
    for sid in e.get("skills", []):
        if sid not in skills:
            err(f"enemies/{eid} : compétence inconnue « {sid} »")
for enc_id, enc in encounters.items():
    cells = set()
    for e in enc.get("enemies", []):
        if e["id"] not in enemies:
            err(f"encounters/{enc_id} : ennemi inconnu « {e['id']} »")
        cell = (e.get("row", 0), e.get("lane", 1))
        if not (0 <= cell[0] <= 2 and 0 <= cell[1] <= 2):
            err(f"encounters/{enc_id} : case hors grille {cell}")
        if cell in cells:
            err(f"encounters/{enc_id} : deux ennemis sur la case {cell}")
        cells.add(cell)
    for cid, pos in enc.get("party_positions", {}).items():
        if cid not in characters:
            err(f"encounters/{enc_id} : position pour personnage inconnu « {cid} »")
    # 11 héroïnes pour 9 cases : les doublons sont résolus en jeu (case libre la plus proche, escouade de 6).
    for cid, pos in enc.get("party_positions", {}).items():
        if not (0 <= int(pos[0]) <= 2 and 0 <= int(pos[1]) <= 2):
            err(f"encounters/{enc_id} : case hors grille pour {cid}")
    for cid in enc.get("party", []):
        if cid not in characters:
            err(f"encounters/{enc_id} : groupe imposé, personnage inconnu « {cid} »")

# --- Audio ---------------------------------------------------------------------------------
for ctx, track in music.get("contexts", {}).items():
    if track not in music.get("tracks", {}):
        err(f"audio/music : le contexte « {ctx} » pointe vers une piste inconnue « {track} »")
for cid, c in characters.items():
    for lang in ("ko", "ja"):
        if not c.get("voice", {}).get(lang):
            err(f"characters/{cid} : identifiant de voix {lang} manquant")

# --- Monde -------------------------------------------------------------------------------
for sid, s in sectors.items():
    w = f"sectors/{sid}"
    check_condition(s.get("available", ""), w + ".available")
    if s.get("entry") not in s.get("nodes", {}):
        err(f"{w} : nœud d'entrée inconnu « {s.get('entry')} »")
    for a in s.get("adjacent", []):
        if a not in sectors:
            err(f"{w} : secteur adjacent inconnu « {a} »")
        elif sid not in sectors[a].get("adjacent", []):
            err(f"{w} : adjacence non symétrique avec « {a} »")
    if music and f"sector.{sid}" not in music.get("contexts", {}) and s.get("music") not in music.get("contexts", {}):
        err(f"{w} : contexte musical absent de music.json")
    for nid, n in s.get("nodes", {}).items():
        wn = f"nodes/{nid}"
        if not nid.startswith(sid + "."):
            err(f"{wn} : préfixe ≠ secteur")
        for k in ("hidden", "open", "refuge"):
            check_condition(n.get(k, ""), f"{wn}.{k}")
        if n.get("open") and not n.get("locked_hint"):
            warn(f"{wn} : condition d'ouverture sans indice (locked_hint)")
        for link in n.get("links", []):
            if link not in all_nodes:
                err(f"{wn} : lien vers nœud inconnu « {link} »")
            elif nid not in all_nodes[link].get("links", []):
                err(f"{wn} : lien non symétrique avec « {link} »")
        ids = set()
        for a in n.get("actions", []):
            wa = f"{wn}/{a.get('id')}"
            if a.get("id") in ids:
                err(f"{wa} : id d'action en double")
            ids.add(a.get("id"))
            check_condition(a.get("if", ""), wa)
            check_effects(a.get("fx", []), wa)
            check_effects(a.get("win_fx", []), wa + ".win_fx")
            if a.get("dialogue"):
                ref_dialogue(a["dialogue"], wa)
            if a.get("encounter") and a["encounter"] not in encounters:
                err(f"{wa} : rencontre inconnue « {a['encounter']} »")
            if a.get("travel") and a["travel"] not in all_nodes:
                err(f"{wa} : destination inconnue « {a['travel']} »")
            if not a.get("label"):
                err(f"{wa} : libellé manquant")
ev_ids = set()
for ev in events:
    w = f"events/{ev.get('id')}"
    if ev.get("id") in ev_ids:
        err(f"{w} : id en double")
    ev_ids.add(ev.get("id"))
    check_condition(ev.get("when", ""), w)
    ref_dialogue(ev.get("dialogue", ""), w)
    where = ev.get("where", "*")
    if where.startswith("sector:"):
        if where[7:] not in sectors:
            err(f"{w} : secteur inconnu « {where} »")
    elif where != "*" and where not in all_nodes:
        err(f"{w} : nœud inconnu « {where} »")
# Itinéraire de l'autotest : conditions et nœuds valides
for i, leg in enumerate(load(ROOT / "tests/autopilot.json").get("route", [])):
    w = f"autopilot/route/{i}"
    check_condition(leg.get("until", ""), w)
    if leg.get("go") not in all_nodes:
        err(f"{w} : nœud inconnu « {leg.get('go')} »")
# Ancres « présent / absent » : la version présente ne doit jamais se jouer après la version absente
ev_by_id = {e.get("id"): e for e in events}
for eid in ev_by_id:
    if str(eid).endswith("_absent"):
        base = eid[: -len("_absent")]
        present = base if base in ev_by_id else (base + "_present" if base + "_present" in ev_by_id else None)
        if present and f"done('{eid}')" not in ev_by_id[present].get("when", ""):
            err(f"events/{present} : doit exclure « {eid} » (ajouter « and not done('{eid}') »)")
for d, places in done_read.items():
    if d not in ev_ids:
        err(f"done('{d}') : événement inconnu ({', '.join(sorted(places))})")

# --- Repos au Refuge : toute héroïne qui peut rejoindre le groupe a sa scène refuge:<id> ---------
def _all_fx(dlg: dict):
    for steps in dlg.get("blocks", {}).values():
        for st in steps:
            yield from st.get("fx", [])
            for opt in st.get("choice", []):
                yield from opt.get("fx", [])
joinable = set()
for dlg in dialogues.values():
    for e in _all_fx(dlg):
        parts = str(e).split()
        if len(parts) > 1 and parts[0] == "join":
            joinable.add(parts[1])
        elif len(parts) > 1 and parts[0] == "flag" and parts[1].startswith("party."):
            joinable.add(parts[1][6:])
for cid in sorted(joinable):
    ref_dialogue(f"refuge:{cid}", f"refuge/repos/{cid}")

# Scènes de groupe du Refuge (actions intégrées)
for gs in load(DATA / "world/group_scenes.json").get("scenes", []):
    w = f"group_scenes/{gs.get('id')}"
    for m in gs.get("members", []):
        if m not in characters:
            err(f"{w} : personnage inconnu « {m} »")
    check_condition(gs.get("if", ""), w)
    ref_dialogue(gs.get("dialogue", ""), w)

# --- Dialogues ------------------------------------------------------------------------------
cg_calls: dict[str, set] = defaultdict(set)
for did, dlg in dialogues.items():
    blocks = dlg.get("blocks", {})
    speakers = set(dlg.get("speakers", {}).keys())
    if dlg.get("start", "start") not in blocks:
        err(f"dialogues/{did} : bloc de départ absent")
    targets = defaultdict(set)
    for b, steps in blocks.items():
        for i, st in enumerate(steps):
            w = f"{did}:{b}:{i}"
            for k in ("goto", "then", "else"):
                if k in st:
                    targets[st[k]].add(w)
                    if st[k] not in blocks:
                        err(f"{w} : bloc inconnu « {st[k]} »")
            if "if" in st:
                check_condition(st["if"], w)
            if "when" in st:
                check_condition(st["when"], w)
            if "fx" in st:
                check_effects(st["fx"], w)
            if "choice" in st:
                if not st["choice"]:
                    err(f"{w} : choix vide")
                for j, opt in enumerate(st["choice"]):
                    wo = f"{w}/choix{j}"
                    check_condition(opt.get("if", ""), wo)
                    check_effects(opt.get("fx", []), wo)
                    if "goto" in opt:
                        targets[opt["goto"]].add(wo)
                        if opt["goto"] not in blocks:
                            err(f"{wo} : bloc inconnu « {opt['goto']} »")
                    else:
                        warn(f"{wo} : choix sans goto (continue le bloc)")
            if "t" in st:
                s = st.get("s", "narrator")
                if s not in characters and s not in speakers and s not in SPECIAL_SPEAKERS:
                    err(f"{w} : locuteur inconnu « {s} »")
                e = st.get("e")
                if e and s in characters:
                    allowed = COMMON_EXPR | set(art_chars.get(s, {}).get("signature_expressions", {}).keys())
                    if e not in allowed:
                        err(f"{w} : expression « {e} » inconnue pour {s}")
            if "event" in st:
                ev = st["event"]
                if ev not in KNOWN_EVENTS:
                    err(f"{w} : événement inconnu « {ev} »")
                args = st.get("args", {})
                if ev == "combat":
                    if args.get("encounter") not in encounters:
                        err(f"{w} : rencontre inconnue « {args.get('encounter')} »")
                    nxt = steps[i + 1] if i + 1 < len(steps) else {}
                    if "combat.last" not in str(nxt.get("if", "")):
                        err(f"{w} : défaite de combat non gérée (l'étape suivante doit tester v('combat.last'))")
                if ev in ("move", "world") and args.get("node") not in all_nodes:
                    err(f"{w} : nœud inconnu « {args.get('node')} »")
            if "time" in st:
                try:
                    dd, pp = (int(x) for x in str(st["time"]).split(":"))
                    if not (1 <= dd <= 300 and 0 <= pp <= 3):
                        raise ValueError
                except ValueError:
                    err(f"{w} : temps invalide « {st['time']} »")
            if "bg" in st and st["bg"] not in manifest_bg:
                warn(f"{w} : décor « {st['bg']} » absent du manifeste d'art")
            if st.get("cg"):
                cg_calls[st["cg"]].add(f"{did}:{b}")
                if st["cg"] not in manifest_cg:
                    err(f"{w} : CG « {st['cg']} » absente du manifeste d'art")
            if "text_p3_slot" in st:
                slot = st["text_p3_slot"]
                if not isinstance(slot, list):
                    err(f"{w} : text_p3_slot doit être une liste de répliques")
                    slot = []
                if len(st) != 1:
                    err(f"{w} : text_p3_slot doit être seul dans son étape")
                for k, line in enumerate(slot):
                    if not isinstance(line, dict) or "t" not in line or set(line) - {"s", "t", "e"}:
                        err(f"{w}/p3:{k} : réplique invalide (clés autorisées : s, t, e)")
                        continue
                    sp = line.get("s", "narrator")
                    if sp not in characters and sp not in speakers and sp not in SPECIAL_SPEAKERS:
                        err(f"{w}/p3:{k} : locuteur inconnu « {sp} »")
                    ex = line.get("e")
                    if ex and sp in characters and ex not in COMMON_EXPR | set(art_chars.get(sp, {}).get("signature_expressions", {}).keys()):
                        err(f"{w}/p3:{k} : expression « {ex} » inconnue pour {sp}")
            if "music" in st and music and st["music"] not in music.get("contexts", {}):
                err(f"{w} : contexte musical inconnu « {st['music']} »")
    # blocs inatteignables
    reachable, stack = set(), [dlg.get("start", "start")] + [b for (d2, b) in dialogue_refs if d2 == did]
    while stack:
        b = stack.pop()
        if b in reachable or b not in blocks:
            continue
        reachable.add(b)
        for st in blocks[b]:
            for k in ("goto", "then", "else"):
                if k in st:
                    stack.append(st[k])
            for opt in st.get("choice", []):
                if "goto" in opt:
                    stack.append(opt["goto"])
    for b in blocks:
        if b not in reachable:
            warn(f"dialogues/{did} : bloc inatteignable « {b} »")

# --- CG : manifeste ↔ scènes ----------------------------------------------------------------------
NIGHT_FLAG = re.compile(r"^(\w+_nuit|nuit_maison)$")  # les nuits de Pacte (<id>_nuit_pacte) n'ont pas de CG intime
for item in manifest:
    if item.get("kind") != "cg":
        continue
    cid = Path(item["out"]).stem
    if cid not in cg_calls:
        err(f"art/manifest/{cid} : CG jamais appelée par un dialogue (« cg »: « {cid} »)")
    elif item.get("scene") and item["scene"] not in cg_calls[cid]:
        err(f"art/manifest/{cid} : la scène « {item['scene']} » n'affiche pas cette CG (appelée dans {sorted(cg_calls[cid])})")
for did, dlg in dialogues.items():
    blocks = dlg.get("blocks", {})
    preds = defaultdict(set)
    for b, steps in blocks.items():
        for st in steps:
            for t in [st.get(k) for k in ("goto", "then", "else")] + [o.get("goto") for o in st.get("choice", [])]:
                if t:
                    preds[t].add(b)
    shows_cg = {b for b, steps in blocks.items() if any(st.get("cg") for st in steps)}
    for b, steps in blocks.items():
        nights = [p.split()[1] for st in steps for p in st.get("fx", []) if str(p).startswith("flag ") and NIGHT_FLAG.match(str(p).split()[1])]
        if nights and b not in shows_cg and not (preds[b] & shows_cg):
            err(f"dialogues/{did}:{b} : nuit « {nights[0]} » sans CG (dans le bloc ou dans un bloc qui y mène)")

# --- Galerie : catalogue des CG clés et des scènes intimes (data/world/gallery.json) ----------------
# Chaque CG du manifeste a son entrée ; chaque bloc intime (palier P3 ou drapeau de nuit) est atteint depuis les blocs
# qui débloquent une entrée ; une entrée « prevue » n'a ni scène ni déblocage, mais dit ce qui manque (« setup »).
G_STATUS = {"ecrite", "amorce", "prevue"}
cg_nsfw = {Path(i["out"]).stem: bool(i.get("nsfw")) for i in manifest if i.get("kind") == "cg"}


def _block_ok(ref: str, where: str) -> bool:
    did, _, b = str(ref).partition(":")
    if b in dialogues.get(did, {}).get("blocks", {}):
        return True
    err(f"{where} : bloc inconnu « {ref} »")
    return False


def _closure(ref: str) -> set:
    did, _, b0 = ref.partition(":")
    blocks = dialogues[did]["blocks"]
    seen, stack = set(), [b0]
    while stack:
        b = stack.pop()
        if b in seen or b not in blocks:
            continue
        seen.add(b)
        for st in blocks[b]:
            stack += [st[k] for k in ("goto", "then", "else") if isinstance(st.get(k), str)]
            stack += [o["goto"] for o in st.get("choice", []) if o.get("goto")]
    return {(did, b) for b in seen}


g_ids, g_cgs, g_covered = set(), {}, set()
for e in gallery.get("entries", []):
    w = f"gallery/{e.get('id')}"
    if e.get("id") in g_ids:
        err(f"{w} : identifiant en double")
    g_ids.add(e.get("id"))
    for key, table in (("tab", "tabs"), ("cat", "categories"), ("route", "routes")):
        if e.get(key) not in gallery.get(table, {}):
            err(f"{w} : {key} inconnu « {e.get(key)} »")
    for m in e.get("members", []):
        if m not in characters:
            err(f"{w} : personnage inconnu « {m} »")
    if not e.get("title") or not e.get("hint"):
        err(f"{w} : titre ou indice manquant")
    status = e.get("status")
    if status not in G_STATUS:
        err(f"{w} : statut inconnu « {status} » ({', '.join(sorted(G_STATUS))})")
    elif status == "prevue":  # tout le catalogue doit être jouable : écrire au moins l'amorce et son déclencheur
        err(f"{w} : emplacement « prevue » sans scène jouable ({e.get('setup', '?')})")
    else:
        if not e.get("unlock"):
            err(f"{w} : aucun bloc de déblocage (« unlock »)")
        _block_ok(e.get("scene", ""), w + ".scene")
        for ref in e.get("unlock", []):
            if _block_ok(ref, w + ".unlock"):
                g_covered |= _closure(ref)
    cg = e.get("cg")
    if cg:
        if cg not in cg_nsfw:
            err(f"{w} : CG inconnue « {cg} »")
        elif cg in g_cgs:
            err(f"{w} : CG « {cg} » déjà cataloguée par « {g_cgs[cg]} »")
        g_cgs[cg] = e.get("id")
        if e.get("route") == "pacte" and cg_nsfw.get(cg):
            err(f"{w} : une nuit de Pacte n'a pas de CG intime")
for cg in cg_nsfw:
    if cg not in g_cgs:
        err(f"gallery : la CG « {cg} » n'a pas d'entrée")
for did, dlg in dialogues.items():
    for b, steps in dlg.get("blocks", {}).items():
        intimate = any("text_p3_slot" in st for st in steps) or any(
            str(p).startswith("flag ") and NIGHT_FLAG.match(str(p).split()[1]) for st in steps for p in st.get("fx", []))
        if intimate and (did, b) not in g_covered:
            err(f"dialogues/{did}:{b} : scène intime absente de la galerie (aucune entrée ne la débloque)")

# Résumés de fin d'acte (lus par le code)
for act, lines in load(DATA / "world/act_summary.json").items():
    for i, line in enumerate(lines):
        check_condition(line.get("if", ""), f"act_summary/{act}/{i}")

# --- Systèmes v0.9 : échos, cadeaux, difficulté, résilience -----------------------------------
for eid, e in echoes.items():
    check_condition(e.get("if", ""), f"echoes/{eid}")
    if not e.get("text"):
        err(f"echoes/{eid} : texte manquant")
for gid, g in gifts.items():
    if g.get("node") not in all_nodes:
        err(f"gifts/{gid} : nœud inconnu « {g.get('node')} »")
    for cid in g.get("loves", []) + g.get("likes", []) + list(g.get("reactions", {}).keys()):
        if cid not in characters:
            err(f"gifts/{gid} : personnage inconnu « {cid} »")
for mid in ("histoire", "normal", "survie"):
    m = difficulty.get("modes", {}).get(mid)
    if not m:
        err(f"difficulty : mode manquant « {mid} »")
        continue
    for k in ("enemy_atk", "enemy_hp", "ration_need", "famine", "repit"):
        if k not in m:
            err(f"difficulty/{mid} : clé manquante « {k} »")
for i, r in enumerate(resilience.get("rules", [])):
    check_condition(r.get("if", ""), f"resilience/{i}")

# Le prologue est lancé directement par le code
dialogue_refs.add(("prologue_j1", "start"))

# --- Orphelins ---------------------------------------------------------------------------------
IMPLICIT_FLAG_PREFIXES = ("party.", "fin.", "visite.", "act.", "event.", "refuge.", "repit.", "echo.")
for f, places in sorted(flags_read.items()):
    if f not in flags_written and not f.startswith(IMPLICIT_FLAG_PREFIXES):
        err(f"drapeau lu mais jamais posé « {f} » ({', '.join(sorted(places)[:3])})")
for f, places in sorted(flags_written.items()):
    if f not in flags_read and not f.startswith(IMPLICIT_FLAG_PREFIXES):
        warn(f"drapeau posé mais jamais lu « {f} » (réservé aux actes suivants ?)")
for k, places in sorted(vars_read.items()):
    if k not in vars_written and k not in IMPLICIT_VARS and not k.startswith(SYSTEM_PREFIXES):
        err(f"variable lue mais jamais écrite « {k} » ({', '.join(sorted(places)[:3])})")
for k, places in sorted(items_read.items()):
    if k not in items_written:
        err(f"objet lu mais jamais obtenu « {k} » ({', '.join(sorted(places)[:3])})")
# Inventaire : tout objet obtenu a sa fiche (nom, catégorie, description) ; les cadeaux viennent de gifts.json
for k, places in sorted(items_written.items()):
    known = k in items_cat.get("items", {}) or (k.startswith("cadeau_") and k[7:] in gifts)
    if not known:
        err(f"objet sans fiche dans data/world/items.json « {k} » ({', '.join(sorted(places)[:3])})")
for k, it in items_cat.get("items", {}).items():
    if it.get("cat") not in items_cat.get("categories", {}) or not it.get("name") or not it.get("desc"):
        err(f"items/{k} : nom, catégorie ou description manquant")
for i, pg in enumerate(guide.get("pages", [])):
    if not pg.get("id") or not pg.get("title") or not pg.get("text"):
        err(f"guide/{i} : page incomplète")
for s, places in sorted(souv_read.items()):
    if s not in souv_written:
        err(f"souvenir lu mais jamais accordé « {s} » ({', '.join(sorted(places)[:3])})")
for s in souvenirs:
    if s not in souv_written:
        warn(f"souvenir défini mais jamais accordé « {s} »")

# --- Chronologie (v0.9) ------------------------------------------------------------------------
# Chaque bloc de dialogue reçoit une fenêtre de jours [min, max] déduite des Ancres (events.when), des actions de carte
# (if + disponibilité du secteur) et des sauts conditionnels. Un drapeau lu dans une fenêtre qui s'achève avant le
# premier jour où il peut être posé ne peut jamais être vrai dans la même boucle : erreur. Un souvenir (persistant
# d'une boucle à l'autre) lu avant d'être accordé doit être gardé par loop().
DAY_MAX = 30
_DAY = re.compile(r"day\(\)\s*(==|>=|<=|>|<)\s*(\d+)")


def _split_top(cond: str, sep: str) -> list[str]:
    parts, depth, cur, i, quote = [], 0, "", 0, False
    while i < len(cond):
        c = cond[i]
        if c == "'":
            quote = not quote
        if not quote:
            depth += c == "("
            depth -= c == ")"
            if depth == 0 and cond.startswith(sep, i):
                parts.append(cur)
                cur, i = "", i + len(sep)
                continue
        cur += c
        i += 1
    parts.append(cur)
    return [x.strip() for x in parts]


def _wrapped(p: str) -> bool:
    if not (p.startswith("(") and p.endswith(")")):
        return False
    depth = 0
    for i, c in enumerate(p):
        depth += c == "("
        depth -= c == ")"
        if depth == 0 and i < len(p) - 1:
            return False
    return True


def _term_window(t: str) -> tuple[int, int]:
    t = t.strip()
    if t.startswith("not "):
        return (1, DAY_MAX)
    if _wrapped(t):
        return day_window(t[1:-1])
    m = _DAY.fullmatch(t)
    if not m:
        return (1, DAY_MAX)
    op, n = m.group(1), int(m.group(2))
    return {"==": (n, n), ">=": (n, DAY_MAX), ">": (n + 1, DAY_MAX), "<=": (1, n), "<": (1, n - 1)}[op]


def day_window(cond: str) -> tuple[int, int]:
    """Fenêtre de jours d'une condition : union sur les « or », intersection sur les « and »."""
    if not cond or "day()" not in cond:
        return (1, DAY_MAX)
    lo_all, hi_all = DAY_MAX + 1, 0
    for disj in _split_top(cond.strip(), " or "):
        lo, hi = 1, DAY_MAX
        for term in _split_top(disj, " and "):
            tl, th = _term_window(term)
            lo, hi = max(lo, tl), min(hi, th)
        if lo <= hi:
            lo_all, hi_all = min(lo_all, lo), max(hi_all, hi)
    return (lo_all, hi_all) if lo_all <= hi_all else (1, DAY_MAX)


def _inter(a, b):
    lo, hi = max(a[0], b[0]), min(a[1], b[1])
    return (lo, hi) if lo <= hi else a


win: dict[tuple[str, str], tuple[int, int]] = {}
entries: list[tuple[str, str, tuple[int, int]]] = [("prologue_j1", "start", (1, 2))]
for ev in events:
    if ":" in ev.get("dialogue", ""):
        d, b = ev["dialogue"].split(":", 1)
        entries.append((d, b, day_window(ev.get("when", ""))))
action_windows = []
for sid, sec in sectors.items():
    swin = day_window(sec.get("available", ""))
    for nid, n in sec.get("nodes", {}).items():
        for a in n.get("actions", []):
            aw = _inter(swin, day_window(a.get("if", "")))
            action_windows.append((f"nodes/{nid}/{a.get('id')}", a, aw))
            if ":" in a.get("dialogue", ""):
                d, b = a["dialogue"].split(":", 1)
                entries.append((d, b, aw))
for (d, b) in list(dialogue_refs):
    if d in ("refuge", "refuge_groupe"):
        entries.append((d, b, (1, DAY_MAX)))
stack = list(entries)
while stack:
    d, b, w = stack.pop()
    if d not in dialogues or b not in dialogues[d].get("blocks", {}):
        continue
    old = win.get((d, b))
    new = w if old is None else (min(old[0], w[0]), max(old[1], w[1]))
    if new == old:
        continue
    win[(d, b)] = new
    for st in dialogues[d]["blocks"][b]:
        if "goto" in st:
            stack.append((d, st["goto"], new))
        if "then" in st:
            stack.append((d, st["then"], _inter(new, day_window(st.get("if", "")))))
        if "else" in st:
            stack.append((d, st["else"], new))
        for opt in st.get("choice", []):
            if "goto" in opt:
                stack.append((d, opt["goto"], new))

first_flag: dict[str, int] = {}
first_souv: dict[str, int] = {}


def _note_writes(fx: list, lo: int) -> None:
    for e in fx:
        parts = str(e).split()
        if len(parts) < 2:
            continue
        if parts[0] == "flag":
            first_flag[parts[1]] = min(first_flag.get(parts[1], 99), lo)
        elif parts[0] in ("join", "leave"):
            first_flag["party." + parts[1]] = min(first_flag.get("party." + parts[1], 99), lo)
        elif parts[0] == "souvenir":
            first_souv[parts[1]] = min(first_souv.get(parts[1], 99), lo)


reads: list[tuple[str, str, tuple[int, int]]] = []
for (d, b), w in win.items():
    for i, st in enumerate(dialogues[d]["blocks"][b]):
        _note_writes(st.get("fx", []), w[0])
        for opt in st.get("choice", []):
            _note_writes(opt.get("fx", []), w[0])
            if opt.get("if"):
                reads.append((opt["if"], f"{d}:{b}:{i}", _inter(w, day_window(opt["if"]))))
        if st.get("if"):
            reads.append((st["if"], f"{d}:{b}:{i}", w))
        if st.get("when"):
            reads.append((st["when"], f"{d}:{b}:{i}", w))
for where, a, aw in action_windows:
    _note_writes(a.get("fx", []) + a.get("win_fx", []), aw[0])
    if a.get("if"):
        reads.append((a["if"], where, aw))
for ev in events:
    reads.append((ev.get("when", ""), f"events/{ev.get('id')}", day_window(ev.get("when", ""))))
for cond, where, w in reads:
    for fn, arg in re.findall(r"(\w+)\(\s*'([^']*)'\s*(?:,[^)]*)?\)", cond):
        if fn == "flag" and arg in first_flag and not arg.startswith(IMPLICIT_FLAG_PREFIXES):
            if w[1] < first_flag[arg] and "not flag('%s')" % arg not in cond:
                err(f"{where} : chronologie — « {arg} » lu au plus tard le J{w[1]}, mais posé au plus tôt le J{first_flag[arg]}")
        elif fn == "souvenir" and arg in first_souv and w[1] < first_souv[arg] and "loop()" not in cond \
                and "not souvenir('%s')" % arg not in cond:
            err(f"{where} : chronologie — souvenir « {arg} » lu au plus tard le J{w[1]}, accordé au plus tôt le J{first_souv[arg]} "
                f"(ajouter une garde loop() : il ne peut venir que d'une boucle précédente)")

# --- Rapport -------------------------------------------------------------------------------------
n_steps = sum(len(b) for d in dialogues.values() for b in d.get("blocks", {}).values())
print(f"Données : {len(characters)} personnages, {len(skills)} compétences, {len(encounters)} rencontres, "
      f"{len(sectors)} secteurs / {len(all_nodes)} nœuds, {len(events)} événements, {len(dialogues)} dialogues ({n_steps} étapes)")
for w in warnings:
    print("  avert. :", w)
for e in errors:
    print("  ERREUR :", e)
print(f"{len(errors)} erreur(s), {len(warnings)} avertissement(s)")
sys.exit(1 if errors else 0)
