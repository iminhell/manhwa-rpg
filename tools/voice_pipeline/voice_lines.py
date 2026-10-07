#!/usr/bin/env python3
"""
Pipeline des voix IA (coréen / japonais).

  export    Écrit tools/voice_pipeline/lines.csv : les répliques à doubler selon les règles du jeu
            (première réplique de chaque personnage dans chaque bloc — couvre la règle « apparition » du
            VoiceManager quel que soit le point d'entrée de la scène — + répliques "v": true).
            Colonnes text_ko / text_ja à remplir (traduction) ; une ligne existante n'est jamais écrasée.
  generate  Synthèse via l'API ElevenLabs (modèle multilingue) pour chaque ligne traduite :
            assets/voice/<ko|ja>/<personnage>/<id>.mp3   (clé : ELEVENLABS_API_KEY ; voix : data/characters/*.json → voice.ko / voice.ja)

Le jeu lit ces fichiers via VoiceManager (commutateur global On/Off, langue au choix dans les Options).
"""
from __future__ import annotations

import argparse
import csv
import json
import os
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CSV_PATH = Path(__file__).parent / "lines.csv"
MEMORY = Path(__file__).parent / "translations.json"   # mémoire de traduction : texte FR → {ko, ja}
FIELDS = ["line_id", "speaker", "emotion", "reason", "text_fr", "text_ko", "text_ja"]


def load(p: Path) -> dict:
    return json.loads(p.read_text(encoding="utf-8"))


def entry_blocks(dialogues: dict) -> set[tuple[str, str]]:
    refs = {(d, dlg.get("start", "start")) for d, dlg in dialogues.items()}
    world = load(ROOT / "data/world/sectors.json")
    for s in world["sectors"].values():
        for n in s["nodes"].values():
            for a in n.get("actions", []):
                if ":" in a.get("dialogue", ""):
                    refs.add(tuple(a["dialogue"].split(":", 1)))
    for ev in load(ROOT / "data/world/events.json")["events"]:
        refs.add(tuple(ev["dialogue"].split(":", 1)))
    return refs


def export() -> None:
    chars = {p.stem for p in (ROOT / "data/characters").glob("*.json")}
    dialogues = {p.stem: load(p) for p in (ROOT / "data/dialogues").glob("*.json")}
    entries = entry_blocks(dialogues)
    existing = {}
    if CSV_PATH.exists():
        with CSV_PATH.open(encoding="utf-8") as f:
            existing = {r["line_id"]: r for r in csv.DictReader(f)}
    memory = load(MEMORY) if MEMORY.exists() else {}
    rows = []
    for did, dlg in sorted(dialogues.items()):
        for block, steps in dlg["blocks"].items():
            seen = set()
            for i, st in enumerate(steps):
                s = st.get("s")
                if "t" not in st or s not in chars:
                    continue
                reason = ""
                if st.get("v"):
                    reason = "scène clé"
                elif s not in seen:
                    reason = "apparition"
                seen.add(s)
                if not reason:
                    continue
                lid = f"{did}:{block}:{i}"
                row = existing.get(lid, {})
                if row.get("text_fr") != st["t"]:  # l'index a bougé (étape insérée) : ne pas reprendre la traduction d'une autre réplique
                    row = {}
                mem = memory.get(st["t"], {})
                rows.append({"line_id": lid, "speaker": s, "emotion": st.get("e", "neutral"), "reason": reason,
                             "text_fr": st["t"], "text_ko": row.get("text_ko") or mem.get("ko", ""),
                             "text_ja": row.get("text_ja") or mem.get("ja", "")})
    with CSV_PATH.open("w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=FIELDS)
        w.writeheader()
        w.writerows(rows)
    missing = sum(1 for r in rows if not r["text_ko"] or not r["text_ja"])
    print(f"{len(rows)} répliques à doubler → {CSV_PATH.relative_to(ROOT)} ({missing} sans traduction complète)")


def generate(lang: str, dry_run: bool) -> None:
    key = os.environ.get("ELEVENLABS_API_KEY", "")
    if not key and not dry_run:
        sys.exit("ELEVENLABS_API_KEY manquant (ou --dry-run)")
    chars = {p.stem: load(p) for p in (ROOT / "data/characters").glob("*.json")}
    with CSV_PATH.open(encoding="utf-8") as f:
        rows = list(csv.DictReader(f))
    done = 0
    for r in rows:
        text = r.get(f"text_{lang}", "").strip()
        if not text:
            continue
        voice = chars[r["speaker"]]["voice"].get(lang, "")
        dest = ROOT / "assets/voice" / lang / r["speaker"] / (r["line_id"].replace(":", "__") + ".mp3")
        if dest.exists():
            continue
        if dry_run:
            print(f"  [dry-run] {voice} ← {text[:50]}")
            continue
        req = urllib.request.Request(
            f"https://api.elevenlabs.io/v1/text-to-speech/{voice}?output_format=mp3_44100_128",
            data=json.dumps({"text": text, "model_id": "eleven_multilingual_v2"}).encode(),
            headers={"xi-api-key": key, "Content-Type": "application/json"}, method="POST")
        with urllib.request.urlopen(req, timeout=120) as resp:
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(resp.read())
        done += 1
    print(f"{done} fichier(s) générés ({lang}).")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("cmd", choices=["export", "generate"])
    p.add_argument("--lang", choices=["ko", "ja"], default="ko")
    p.add_argument("--dry-run", action="store_true")
    a = p.parse_args()
    export() if a.cmd == "export" else generate(a.lang, a.dry_run)
