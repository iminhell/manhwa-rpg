#!/usr/bin/env python3
"""Génère docs/CHARADESIGN_PROMPTS.md à partir de data/art/prompts.json (source unique)."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "data/art/prompts.json"
OUT = ROOT / "docs/CHARADESIGN_PROMPTS.md"


def fill(template: str, **kw) -> str:
    return template.format(**kw)


def main() -> None:
    data = json.loads(SRC.read_text(encoding="utf-8"))
    style, tpl, expr = data["style"], data["templates"], data["expressions"]
    out = []
    w = out.append
    w("# CHARADESIGN & PROMPTS — La Tour du Dernier Jour\n")
    w("> Fichier **généré** par `tools/art_pipeline/build_prompt_doc.py` depuis `data/art/prompts.json`.")
    w("> Pour modifier un prompt, éditer le JSON puis relancer le script : le pipeline d'images lit la même source.\n")
    w("## 1. Direction artistique\n")
    w(style["summary_fr"] + "\n")
    w("**Bloc de style (à ajouter à chaque prompt)** :\n```\n" + style["positive"] + "\n```")
    w("**Négatif (SDXL ; Flux n'en utilise pas)** :\n```\n" + style["negative"] + "\n```")
    p = style["params"]
    w("**Paramètres** :")
    w(f"- Flux (pipeline cloud) : `{json.dumps(p['flux'])}`")
    w(f"- SDXL (option) : `{json.dumps(p['sdxl'])}`")
    w(f"- Midjourney (exploration manuelle) : `{p['midjourney']}` + `--cref <url de la planche validée>`\n")
    w("## 2. Ajustements capillaires retenus\n")
    for line in data["hair_adjustments_fr"]:
        w(f"- {line}")
    w("")
    w("## 3. Lisibilité du casting (silhouette et couleur dominante)\n")
    w("| Personnage | Token | Taille / poids | Palette |")
    w("|---|---|---|---|")
    for c in data["characters"]:
        sw = " ".join(f"`{h}`" for h in c["palette"])
        w(f"| {c['name']} | `{c['token']}` | {c['height_cm']} cm / {c['weight_kg']} kg | {sw} |")
    w("")
    w("## 4. Gabarits de prompts\n")
    for k, v in tpl.items():
        w(f"- **{k}** : `{v}`")
    w("\n**Angles de caméra** : " + " · ".join(data.get("camera_angles", [])))
    w("\n**Expressions suggestives** : " + " · ".join(f"`{k}` ({v})" for k, v in data.get("suggestive_expressions", {}).items()))
    w("\n**Expressions communes** (remplacent `{expression}`) :\n")
    w("| Clé | Suffixe |")
    w("|---|---|")
    for k, v in expr.items():
        w(f"| `{k}` | {v} |")
    w("")
    w("## 5. Fiches de prompts par personnage\n")
    for i, c in enumerate(data["characters"], 1):
        w(f"### 5.{i} {c['name']} — `{c['token']}`\n")
        w(f"**Noyau d'identité (invariant, réutilisé partout)** :\n```\n{c['core']}\n```")
        w("**Tenues** :\n")
        for k, v in c["outfits"].items():
            w(f"- `{k}` : {v}")
        base = c["outfits"].get("base")
        w(f"\n**Morphologie (à respecter strictement)** : {c['body']}\n")
        w("**Planche de référence** (étape 1 du pipeline) :\n```\n" + fill(tpl["ref_sheet"], core=c["core"], body=c["body"], outfit=base) + ", " + style["positive"] + "\n```")
        w("**Portrait de dialogue** (neutre) :\n```\n" + fill(tpl["portrait"], core=c["token"], body=c["body"], outfit=base, expression=expr["neutral"]) + ", " + style["positive"] + "\n```")
        w("**Sprite de combat** :\n```\n" + fill(tpl["combat_sprite"], core=c["token"], outfit=c["outfits"].get("combat", base), weapon=c["weapon"]) + ", " + style["positive"] + "\n```")
        w(f"**Signature visuelle** : {c['signature']}\n")
        w("**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :")
        cams = data.get("camera_angles", ["low angle shot looking up"])
        sugg = list(data.get("suggestive_expressions", {}).values()) or [expr["neutral"]]
        for j, pose in enumerate(c.get("pinup_poses", [])):
            w("```\n" + fill(tpl["fanservice"], core=c["token"], body=c["body"], outfit=c["outfits"].get("night", base),
                              pose=pose, camera=cams[j % len(cams)], expression=sugg[j % len(sugg)]) + ", " + style["positive"] + "\n```")
        if c.get("signature_expressions"):
            w("**Expressions propres** : " + " · ".join(f"`{k}` ({v})" for k, v in c["signature_expressions"].items()) + "\n")
        if c.get("states"):
            w("**États évolutifs** : " + " · ".join(f"`{k}` → {v}" for k, v in c["states"].items()) + "\n")
        w("**Checklist de cohérence** : " + " · ".join(c["checklist_fr"]) + "\n")
    w("## 6. Production automatisée\n")
    w("Ces prompts alimentent directement le pipeline cloud `tools/art_pipeline/generate.py` (voir `tools/art_pipeline/README.md`) :")
    w("1. `refs` : 4 planches de référence par personnage ;")
    w("2. choix dans `art_work/review.html` ;")
    w("3. `auto <id> <planche>` : jeu de données à identité fixe, LoRA, puis tous les assets du manifeste.")
    w("4. Visuels 18+ : les entrées du manifeste marquées `\"backend\": \"runpod\"` passent par le backend ComfyUI serverless (`runpod_backend.py`).\n")
    OUT.write_text("\n".join(out) + "\n", encoding="utf-8")
    print(f"Écrit : {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
