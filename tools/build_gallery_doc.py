#!/usr/bin/env python3
"""Génère docs/GALERIE.md (inventaire des scènes de la galerie) depuis data/world/gallery.json (source unique).

  python3 tools/build_gallery_doc.py           écrit le document
  python3 tools/build_gallery_doc.py --check   échoue si le document n'est pas à jour (lancé par check_all.sh)
"""
import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "data/world/gallery.json"
OUT = ROOT / "docs/GALERIE.md"
STATUS = {"ecrite": "écrite", "amorce": "amorce", "prevue": "**prévue**"}


def names(members: list, chars: dict) -> str:
    return ", ".join(chars.get(m, m) for m in members) or "—"


def build() -> str:
    g = json.loads(SRC.read_text(encoding="utf-8"))
    chars = {}
    for p in sorted((ROOT / "data/characters").glob("*.json")):
        c = json.loads(p.read_text(encoding="utf-8"))
        chars[c.get("id", p.stem)] = c.get("name", p.stem)
    entries = g["entries"]
    out = []
    w = out.append
    w("# GALERIE — inventaire des scènes\n")
    w("> Fichier **généré** par `tools/build_gallery_doc.py` depuis `data/world/gallery.json`.")
    w("> Pour ajouter ou modifier une scène, éditer le JSON puis relancer le script (le validateur vérifie le catalogue).\n")
    w(g["note"] + "\n")
    w("## Bilan\n")
    w("| Onglet | Catégorie | Écrites | Amorces | Prévues |")
    w("|---|---|---|---|---|")
    for tab in g["tabs"]:
        for cat in g["categories"]:
            sub = [e for e in entries if e["tab"] == tab and e["cat"] == cat]
            if sub:
                n = Counter(e["status"] for e in sub)
                w(f"| {g['tabs'][tab]} | {g['categories'][cat]} | {n['ecrite']} | {n['amorce']} | {n['prevue']} |")
    n = Counter(e["status"] for e in entries)
    w(f"| **Total** | | **{n['ecrite']}** | **{n['amorce']}** | **{n['prevue']}** |\n")
    w("Par voie : " + " · ".join(f"{label} {sum(e['route'] == r for e in entries)}" for r, label in g["routes"].items()) + "\n")
    for tab in g["tabs"]:
        w(f"## {g['tabs'][tab]}\n")
        for cat in g["categories"]:
            sub = [e for e in entries if e["tab"] == tab and e["cat"] == cat]
            if not sub:
                continue
            w(f"### {g['categories'][cat]} ({len(sub)})\n")
            w("| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |")
            w("|---|---|---|---|---|")
            for e in sub:
                where = f"`{e['scene']}`" if e.get("scene") else "—"
                w(f"| {e['title']}<br>{where} | {g['routes'][e['route']]} | {names(e['members'], chars)} | {STATUS[e['status']]} | {e['hint']} |")
            w("")
    todo = [e for e in entries if e["status"] == "prevue"]
    w(f"## À mettre en place ({len(todo)} emplacements prévus)\n")
    if not todo:
        w("Aucun : chaque emplacement de la galerie se déclenche en jeu (le validateur refuse le statut « prevue »).\n")
    for e in todo:
        w(f"- **{e['title']}** (`{e['id']}`) — {e['setup']}")
    amorces = [e for e in entries if e["status"] == "amorce"]
    w(f"\n## Amorces à compléter ({len(amorces)})\n")
    w("Le début se joue et débloque l'emplacement ; le texte s'arrête avant la suite (palier P3 vide, CG à créer pour les scènes de groupe).\n")
    for e in amorces:
        w(f"- {e['title']} — `{e['scene']}`")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    text = build()
    if "--check" in sys.argv:
        if not OUT.exists() or OUT.read_text(encoding="utf-8") != text:
            print("docs/GALERIE.md n'est pas à jour : python3 tools/build_gallery_doc.py")
            sys.exit(1)
        sys.exit(0)
    OUT.write_text(text, encoding="utf-8")
    print(f"{OUT.relative_to(ROOT)} : {len(text.splitlines())} lignes")
