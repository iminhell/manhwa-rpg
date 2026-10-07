#!/usr/bin/env python3
"""
Enregistre les assets générés (assets/) : commit local, puis
  --push   pousse sur GitHub avec le jeton GITHUB_TOKEN (dépôt DEPOT, branche BRANCHE ; variables d'environnement) ;
  --zip    écrit assets_generated.zip avec tout ce qui a changé dans assets/ depuis origin/BRANCHE
           (à installer sur le PC avec : python tools/generate_assets.py).
"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
import time
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def git(*args: str, check: bool = True) -> str:
    return subprocess.run(["git", *args], cwd=ROOT, check=check, capture_output=True, text=True).stdout.strip()


def commit(message: str) -> bool:
    git("add", "assets")
    if not git("diff", "--cached", "--name-only"):
        print("[publish] rien de nouveau dans assets/")
        return False
    git("commit", "-q", "-m", message)
    print(f"[publish] commit : {message}")
    return True


def push(repo: str, branch: str, token: str) -> None:
    url = f"https://x-access-token:{token}@github.com/{repo}.git"
    for attempt in range(4):
        subprocess.run(["git", "pull", "-q", "--rebase", url, branch], cwd=ROOT, check=False)
        r = subprocess.run(["git", "push", "-q", url, f"HEAD:{branch}"], cwd=ROOT, capture_output=True, text=True)
        if r.returncode == 0:
            print(f"[publish] poussé sur {repo}@{branch}")
            return
        print(f"[publish] échec du push ({r.stderr.strip().replace(token, '***')[:200]}), nouvel essai…")
        time.sleep(2 ** (attempt + 1))
    sys.exit("[publish] push impossible : vérifier le jeton GITHUB_TOKEN (droit Contents: write sur le dépôt)")


def make_zip(branch: str) -> Path:
    base = f"origin/{branch}"
    changed = git("diff", "--name-only", base, "HEAD", "--", "assets", check=False).splitlines() if git(
        "rev-parse", "--verify", "-q", base, check=False) else []
    changed += git("ls-files", "--others", "--exclude-standard", "assets").splitlines()
    out = ROOT / "assets_generated.zip"
    with zipfile.ZipFile(out, "w", zipfile.ZIP_STORED) as z:
        for rel in sorted(set(changed)):
            if (ROOT / rel).is_file():
                z.write(ROOT / rel, rel)
    print(f"[publish] {out.name} : {len(set(changed))} fichier(s)")
    return out


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("message")
    p.add_argument("--push", action="store_true")
    p.add_argument("--zip", action="store_true")
    a = p.parse_args()
    repo, branch, token = os.environ.get("DEPOT", "iminhell/manhwa-rpg"), os.environ.get("BRANCHE", "main"), os.environ.get(
        "GITHUB_TOKEN", "")
    commit(a.message)
    if a.push:
        if token:
            push(repo, branch, token)
        else:
            print("[publish] pas de GITHUB_TOKEN : les fichiers restent ici (téléchargement du zip à la fin)")
    if a.zip:
        make_zip(branch)


if __name__ == "__main__":
    main()
