#!/usr/bin/env python3
"""Tests du générateur gratuit, sans GPU ni modèle : faux moteurs, sorties dans un dossier temporaire.

Lancer : python3 tools/free_assets/test_free_gen.py   (appelé par tools/check_all.sh)
"""
from __future__ import annotations

import argparse
import json
import shutil
import sys
import tempfile
import wave
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent))
import free_gen as fg  # noqa: E402
import generate_assets as ga  # noqa: E402

failures: list[str] = []


def check(cond: bool, label: str) -> None:
    if not cond:
        failures.append(label)


def args(**kw) -> argparse.Namespace:
    base = {"force": False, "dry_run": False, "only": None, "limit": 0}
    base.update(kw)
    return argparse.Namespace(**base)


class FakeImage:
    def save(self, dest, optimize=True):
        Path(dest).write_bytes(b"\x89PNG\r\n\x1a\nfake")


class FakeImages:
    def __init__(self):
        self.calls = []

    def render(self, prompt, negative, size, seed, steps=28):
        self.calls.append((prompt, negative, size))
        return FakeImage()


def write_wav(path: Path, seconds: float = 0.5) -> None:
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(16000)
        w.writeframes(b"\x00\x00" * int(16000 * seconds))


class FakeMusic:
    def render(self, prompt, wav, seconds):
        write_wav(wav, 2.0)


class FakeVoices:
    def __init__(self):
        self.calls = []

    def render(self, text, lang, cid, wav):
        self.calls.append((lang, cid))
        write_wav(wav)


def main() -> None:
    # Décodage du VAE par tranches selon la version de diffusers
    class Vae:
        sliced = False

        def enable_slicing(self):
            self.sliced = True

    class NewPipe:  # diffusers récent : plus de pipe.enable_vae_slicing
        def __init__(self):
            self.vae = Vae()

    class OldPipe:  # diffusers ancien : méthode du pipeline seulement
        sliced = False
        vae = object()

        def enable_vae_slicing(self):
            self.sliced = True

    new, old = NewPipe(), OldPipe()
    check(fg.enable_vae_slicing(new) == "vae.enable_slicing" and new.vae.sliced, "VAE : diffusers récent (vae.enable_slicing)")
    check(fg.enable_vae_slicing(old) == "pipe.enable_vae_slicing" and old.sliced, "VAE : diffusers ancien (enable_vae_slicing)")
    check(fg.enable_vae_slicing(object()) == "", "VAE : aucune méthode, pas d'erreur")

    # Voix : découpage sous les limites de XTTS-v2, assemblage du WAV, voix de repli
    import csv  # noqa: PLC0415
    with fg.LINES.open(encoding="utf-8") as f:
        rows = list(csv.DictReader(f))
    for lang in fg.LANGS:
        limit = fg.XTTS_LIMITS[lang]
        for r in rows:
            text = r[f"text_{lang}"]
            pieces = fg.split_for_tts(text, lang)
            if any(len(p) > limit for p in pieces) or not pieces:
                failures.append(f"voix {lang} : {r['line_id']} dépasse la limite XTTS ({[len(p) for p in pieces]})")
                break
            if "".join(pieces).replace(" ", "") != text.replace(" ", ""):
                failures.append(f"voix {lang} : {r['line_id']} perd du texte au découpage")
                break
    longest = max(rows, key=lambda r: len(r["text_ja"]))["text_ja"]
    check(len(fg.split_for_tts(longest, "ja")) > 1, "voix : la plus longue réplique japonaise est découpée")

    class FakeSynth:
        output_sample_rate = 24000

    class FakeTts:
        speakers = ["Daisy Studious", "Claribel Dervla", "Damien Black"]
        synthesizer = FakeSynth()

        def __init__(self):
            self.calls = []

        def tts(self, text, language, split_sentences, speaker=None, speaker_wav=None):
            self.calls.append((text, language, split_sentences, speaker))
            return [0.1] * 2400  # 0,1 s

    fake_tts = FakeTts()
    xb = fg.XttsBackend(tts=fake_tts)
    check(xb.speaker_for("seo_yeon") == {"speaker": "Daisy Studious"}, "voix : voix XTTS choisie pour Seo-Yeon")
    check(xb.speaker_for("nadia")["speaker"] in FakeTts.speakers, "voix : repli sur une voix disponible")
    with tempfile.TemporaryDirectory() as tmp:
        wav = Path(tmp) / "v.wav"
        xb.render(longest, "ja", "seo_yeon", wav)
        n = len(fg.split_for_tts(longest, "ja"))
        with wave.open(str(wav)) as w:
            frames, rate = w.getnframes(), w.getframerate()
        check(rate == 24000 and frames == 2400 * n + 3600 * (n - 1), f"voix : {n} morceaux assemblés avec silences ({frames})")
        check(all(c[2] is False for c in fake_tts.calls), "voix : découpage interne de coqui désactivé")

    # Pondération A1111
    pw = fg.parse_weights
    check(pw("a, (b:1.4), c") == [("a, ", 1.0), ("b", 1.4), (", c", 1.0)], f"pondération explicite {pw('a, (b:1.4), c')}")
    check([round(w, 3) for _, w in pw("(a) [b] ((c))")] == [1.1, 0.909, 1.21], f"pondération implicite {pw('(a) [b] ((c))')}")
    check([round(w, 2) for _, w in pw("((a:1.2) b)")] == [1.32, 1.1], "pondération imbriquée")
    check(pw(r"\(literal\)") == [("(literal)", 1.0)], "parenthèses échappées")
    # Style des sprites : chaque personnage et chaque expression du manifeste sont couverts
    style = fg.load_style()
    manifest = fg.load_json(fg.MANIFEST)["assets"]
    sprite_items = [a for a in manifest if a["kind"] in fg.SPRITE_KINDS]
    chars = {a["char"] for a in sprite_items}
    check(chars == set(fg.load_json(fg.PROMPTS)["characters"][i]["id"] for i in range(11)), f"sprites : les 11 personnages ({sorted(chars)})")
    check(chars <= set(style["characters"]), f"style : personnages sans tags {sorted(chars - set(style['characters']))}")
    exprs = {a.get("expression") for a in sprite_items if a["kind"] == "portrait"}
    check(exprs <= set(style["expressions"]), f"style : expressions sans tags {sorted(exprs - set(style['expressions']))}")
    for cid in chars:
        p = fg.sprite_prompt(style, cid, "joy")
        check(("1boy" in p) == bool(style["characters"][cid].get("male")) and "(full body:1.4)" in p and "white background" in p,
              f"prompt de sprite {cid}")
    check("child" in style["negative"] and "loli" in style["negative"], "négatif des sprites : garde-fous d'âge")
    # Charadesign d'Elias (manteau long noir tactique, peau caramel, imberbe, cheveux mi-longs, visage calme) et netteté
    pe = fg.sprite_prompt(style, "elias")
    check(all(t in pe for t in ("long black coat", "tactical military greatcoat", "caramel skin", "sheathed sword at hip",
                                "medium-length hair", "clean-shaven", "calm expression"))
          and "sweaty skin" not in pe and "seductive smile" not in pe and "stubble" not in pe and "cold gaze" not in pe,
          "prompt d'Elias : manteau, peau caramel, imberbe, cheveux mi-longs, visage calme")
    ne = fg.sprite_negative(style, "elias")
    check("beard" in ne and "stubble" in ne and ne.startswith(style["negative"]), "négatif d'Elias : barbe et air renfrogné exclus")
    check(fg.sprite_negative(style, "aoi") == style["negative"], "négatif commun pour les autres personnages")
    check("seductive smile" in fg.sprite_prompt(style, "seo_yeon"), "expressions communes inchangées pour les héroïnes")
    ps = fg.sprite_prompt(style, "simone")
    check("thigh holster" in ps and "plunging neckline" in ps and "visible abs" in ps and "standing straight" in ps,
          "Simone : tenue de commandante, pose propre au personnage")
    check(style["hires"]["scale"] == 1.5 and style["detailer"]["face_model"] and style["detailer"]["hand_model"]
          and "sharp lineart" in style["quality"] and "soft shadows" not in style["background"] and "drop shadow" in style["negative"],
          "netteté : seconde passe ×1,5, retouche visages et mains, sans ombre portée")
    from PIL import Image as _Im, ImageDraw as _Dr  # noqa: PLC0415
    _im = _Im.new("RGB", (64, 64), "white")
    _Dr.Draw(_im).rectangle((20, 20, 44, 44), fill=(120, 120, 120))
    _sh = fg.sharpen(_im, style["sharpen"])
    check(_sh.size == _im.size and _sh.getpixel((21, 32))[0] < 120 and fg.sharpen(_im, None) is _im, "accentuation finale du trait")
    from PIL import Image, ImageDraw  # noqa: PLC0415
    alpha = Image.new("L", (200, 400), 0)
    ImageDraw.Draw(alpha).rectangle((60, 40, 140, 390), fill=255)
    box = fg.head_mask(alpha).point(lambda v: 255 if v > 128 else 0).getbbox()
    check(box and box[1] <= 40 and 100 < box[3] < 160 and box[0] < 60 and box[2] > 140, f"masque du visage : haut de la silhouette {box}")

    # Nettoyage du détourage : ombre, îlot et voile supprimés, contour (lineart) et couleurs conservés
    import numpy as np  # noqa: PLC0415
    rgba = np.zeros((300, 200, 4), np.uint8)
    rgba[..., :3] = 255
    rgba[40:260, 70:130] = (230, 180, 150, 255)          # silhouette (peau)
    rgba[40:260, 68:70] = rgba[40:260, 130:132] = (15, 15, 20, 200)   # trait de contour, semi-transparent au bord
    rgba[262:285, 40:160] = (190, 190, 190, 120)         # ombre portée grise sous les pieds
    rgba[10:13, 10:13] = (90, 60, 40, 255)               # îlot isolé (poussière)
    rgba[30:40, 60:140] = (245, 245, 245, 70)            # voile blanc au-dessus de la tête
    out = np.asarray(fg.clean_alpha(Image.fromarray(rgba, "RGBA")))
    check(out[270, 100, 3] == 0, f"détourage : ombre sous les pieds supprimée (alpha {out[270, 100, 3]})")
    try:
        import scipy  # noqa: F401, PLC0415  (installé avec rembg ; absent du Python système de certains conteneurs)
        check(out[11, 11, 3] == 0, "détourage : îlot isolé supprimé")
    except ImportError:
        print("  (scipy absent : suppression des îlots non vérifiée ici)")
    check(out[35, 100, 3] == 0, "détourage : voile blanc supprimé")
    check(out[150, 100, 3] == 255 and tuple(out[150, 100, :3]) == (230, 180, 150), "détourage : silhouette et couleurs intactes")
    check(out[150, 68, 3] > 200 and out[150, 68, :3].max() < 40, f"détourage : trait de contour conservé ({out[150, 68]})")
    near = out[150, 60]
    check(near[3] == 0 and near[:3].max() > 0, f"détourage : pixels transparents colorés par le bord voisin, pas noirs ({near})")

    ctx = fg.art.Ctx(dry_run=True)
    tokens = [c["token"] for c in ctx.chars.values()]
    real_root = fg.ROOT
    with tempfile.TemporaryDirectory() as tmp:
        fg.ROOT = Path(tmp)  # toutes les sorties vont dans le dossier temporaire
        jobs = fg.image_jobs(False, None)
        check(len(jobs) == sum(1 for a in manifest if not a.get("nsfw") and a["kind"] not in fg.SPRITE_KINDS),
              "images : entrées non nsfw hors sprites de personnages")
        sprites = fg.sprite_jobs(False, None)
        check(len(sprites) == sum(1 for a in manifest if a["kind"] in fg.SPRITE_KINDS), "sprites : portraits et sprites de combat")
        order = [s.get("expression", "") for s in sprites if s.get("char") == "seo_yeon" and s["kind"] == "portrait"]
        check(order and order[0] == "neutral", "sprites : pose neutre d'abord (base de l'inpainting)")
        check(all(not j.get("nsfw") for j in jobs), "images : aucune CG nsfw générée gratuitement")
        for j in jobs:
            p = fg.sdxl_prompt(ctx, j)
            check(not any(t in p for t in tokens), f"prompt {j['id']} : jeton LoRA non remplacé")
            check("(" not in p and ")" not in p, f"prompt {j['id']} : parenthèses (pondération Compel)")
        fake = FakeImages()
        n = fg.cmd_images(args(limit=5), backend=fake)
        check(n == 5 and len(fake.calls) == 5, "images : lot limité à 5")
        check(all((fg.ROOT / j["out"]).exists() for j in jobs[:5]), "images : fichiers écrits au chemin du manifeste")
        check(all(c[2] in fg.SIZES.values() for c in fake.calls), "images : tailles SDXL")
        check("nsfw" in fake.calls[0][1], "images : négatif SFW appliqué")
        check(len(fg.image_jobs(False, None)) == len(jobs) - 5, "images : reprise (fichiers existants ignorés)")
        if shutil.which("ffmpeg"):
            check(fg.cmd_music(args(limit=2), backend=FakeMusic()) == 2, "musique : 2 pistes")
            music = [p for p in (fg.ROOT / "assets/audio/music").glob("*.ogg")]
            check(len(music) == 2 and all(p.read_bytes()[:4] == b"OggS" for p in music), "musique : Ogg Vorbis valides")
            fv = FakeVoices()
            check(fg.cmd_voices(args(limit=4), backend=fv) == 4, "voix : 4 fichiers")
            check({lang for lang, _ in fv.calls} == {"ko", "ja"}, "voix : coréen et japonais")
            first = fg.voice_jobs(True, None)[0]
            check(first["dest"].suffix == ".ogg" and "__" in first["dest"].name, "voix : chemin lu par VoiceManager")
        tracks = fg.load_json(fg.MUSIC)["tracks"]
        check(all(t.get("prompt") for t in tracks.values()), "musique : chaque piste a un prompt anglais")
        voices = fg.xtts_voices()
        check(set(voices) == set(ctx.chars) and all(voices.values()), "voix : chaque personnage a une voix XTTS")
        # Installation d'un zip : seuls les fichiers sous assets/ sont extraits
        z = Path(tmp) / "assets_generated.zip"
        with zipfile.ZipFile(z, "w") as zz:
            zz.writestr("assets/cg/x.png", b"png")
            zz.writestr("../evil.txt", b"no")
            zz.writestr("tools/evil.py", b"no")
        ga.ROOT = Path(tmp) / "proj"
        check(ga.install_zip(z) == 1 and (ga.ROOT / "assets/cg/x.png").exists(), "zip : seuls les fichiers d'assets/ sont installés")
        check(not (Path(tmp) / "evil.txt").exists() and not (ga.ROOT / "tools").exists(), "zip : chemins hors assets/ refusés")
    fg.ROOT = real_root
    nb = json.loads((HERE / "generate_assets.ipynb").read_text(encoding="utf-8"))
    for i, cell in enumerate(nb["cells"]):
        if cell["cell_type"] == "code":
            try:
                compile("".join(cell["source"]), f"cellule {i}", "exec")
            except SyntaxError as e:
                failures.append(f"notebook : cellule {i} invalide ({e})")
    for f in failures:
        print("  ÉCHEC :", f)
    print(f"Générateur gratuit : {'OK' if not failures else str(len(failures)) + ' échec(s)'}")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
