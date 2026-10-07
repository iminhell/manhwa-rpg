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

    ctx = fg.art.Ctx(dry_run=True)
    manifest = fg.load_json(fg.MANIFEST)["assets"]
    tokens = [c["token"] for c in ctx.chars.values()]
    real_root = fg.ROOT
    with tempfile.TemporaryDirectory() as tmp:
        fg.ROOT = Path(tmp)  # toutes les sorties vont dans le dossier temporaire
        jobs = fg.image_jobs(False, None)
        check(len(jobs) == sum(1 for a in manifest if not a.get("nsfw")), "images : toutes les entrées non nsfw, aucune nsfw")
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
