#!/usr/bin/env python3
"""
Assets du jeu en un clic (double-cliquer GENERER_ASSETS.bat sous Windows, ou ./generer_assets.sh).

Sans option, dans l'ordre :
  1. récupère les assets déjà poussés par le notebook Colab (git pull) ;
  2. installe tout assets_generated*.zip trouvé dans Téléchargements ou à la racine du projet ;
  3. si une carte NVIDIA est disponible : génère gratuitement ce qui manque (tools/free_assets/free_gen.py) ;
     sinon : ouvre le notebook Colab gratuit dans le navigateur ;
  4. affiche ce qui reste à produire.

  --install FICHIER.zip    installe une archive précise
  --paid [--budget 15]     génération payante : fal.ai (FAL_KEY) pour les images, RunPod (RUNPOD_API_KEY,
                           RUNPOD_ENDPOINT_ID) pour les CG nsfw ; estimation et confirmation avant tout appel
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import webbrowser
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLAB = "https://colab.research.google.com/github/iminhell/manhwa-rpg/blob/main/tools/free_assets/generate_assets.ipynb"
FREE_GEN = ROOT / "tools/free_assets/free_gen.py"
# Prix indicatifs (à vérifier sur les grilles tarifaires) : fal.ai flux/dev ≈ 0,025 $ par image d'environ 1 mégapixel,
# RunPod serverless (GPU 24 Go) ≈ 0,0004 $/s × ~30 s par CG Flux, hors volume réseau (~0,07 $/Go/mois).
COST_FAL, COST_RUNPOD = float(os.environ.get("COST_FAL", 0.025)), float(os.environ.get("COST_RUNPOD", 0.015))


def run(cmd: list[str], check: bool = False) -> int:
    print("$", " ".join(cmd))
    return subprocess.run(cmd, cwd=ROOT, check=check).returncode


def install_zip(path: Path) -> int:
    """Extrait uniquement les fichiers sous assets/ (aucun chemin absolu ni « .. »)."""
    n = 0
    with zipfile.ZipFile(path) as z:
        for m in z.infolist():
            rel = Path(m.filename)
            if m.is_dir() or rel.is_absolute() or ".." in rel.parts or rel.parts[0] != "assets":
                continue
            dest = ROOT / rel
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(z.read(m))
            n += 1
    print(f"[install] {path.name} : {n} fichier(s) installés dans assets/")
    return n


def find_zips() -> list[Path]:
    dirs = [ROOT, Path.home() / "Downloads", Path.home() / "Téléchargements"]
    found = [p for d in dirs if d.is_dir() for p in d.glob("assets_generated*.zip")]
    return sorted(found, key=lambda p: p.stat().st_mtime)


def has_cuda() -> bool:
    try:
        import torch  # noqa: PLC0415
        return torch.cuda.is_available()
    except ImportError:
        return False


def paid(budget: float) -> None:
    manifest = json.loads((ROOT / "data/art/manifest.json").read_text(encoding="utf-8"))["assets"]
    todo = [a for a in manifest if not (ROOT / a["out"]).exists()]
    fal = [a for a in todo if a.get("backend") != "runpod"]
    rp = [a for a in todo if a.get("backend") == "runpod"]
    cost = len(fal) * COST_FAL + len(rp) * COST_RUNPOD
    print(f"[payant] {len(fal)} images fal.ai (~{len(fal) * COST_FAL:.2f} $) + {len(rp)} CG RunPod (~{len(rp) * COST_RUNPOD:.2f} $)"
          f" = ~{cost:.2f} $ pour un budget de {budget:.2f} $ (sans LoRA ; voix et musique : notebook gratuit)")
    missing = [k for k, need in (("FAL_KEY", fal), ("RUNPOD_API_KEY", rp), ("RUNPOD_ENDPOINT_ID", rp)) if need and not os.environ.get(k)]
    if missing:
        sys.exit(f"Variables manquantes : {', '.join(missing)}")
    if cost > budget:
        sys.exit("Estimation au-dessus du budget : réduire avec  python tools/art_pipeline/generate.py assets --kind …")
    if input("Lancer ? [o/N] ").strip().lower() not in ("o", "oui", "y", "yes"):
        return
    run([sys.executable, "tools/art_pipeline/generate.py", "assets"], check=True)


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--install", type=Path)
    p.add_argument("--paid", action="store_true")
    p.add_argument("--budget", type=float, default=15.0)
    p.add_argument("--no-browser", action="store_true")
    a = p.parse_args()
    if a.install:
        install_zip(a.install)
    elif a.paid:
        paid(a.budget)
    else:
        if (ROOT / ".git").exists():
            run(["git", "pull", "--ff-only"])
        for z in find_zips():
            install_zip(z)
        if has_cuda():
            os.environ.setdefault("COQUI_TOS_AGREED", "0")
            run([sys.executable, str(FREE_GEN), "images"])
            run([sys.executable, str(FREE_GEN), "music"])
            if os.environ["COQUI_TOS_AGREED"] == "1":
                run([sys.executable, str(FREE_GEN), "voices"])
            else:
                print("Voix : définir COQUI_TOS_AGREED=1 pour accepter la licence XTTS (usage non commercial).")
        elif not a.no_browser:
            print(f"Pas de GPU NVIDIA ici : ouverture du notebook Colab gratuit\n  {COLAB}")
            webbrowser.open(COLAB)
    run([sys.executable, str(FREE_GEN), "plan"])


if __name__ == "__main__":
    main()
