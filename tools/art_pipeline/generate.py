#!/usr/bin/env python3
"""
Pipeline d'images automatisé (cloud, sans GPU local).

Étapes (toutes pilotées par data/art/prompts.json et data/art/manifest.json) :
  refs     Génère N planches de référence candidates par personnage (Flux, texte → image)
  review   Construit art_work/review.html : planche-contact pour choisir d'un coup d'œil
  approve  Valide une planche : art_work/approved/<id>/ref.png
  dataset  Fabrique un jeu de données cohérent à partir de la planche validée
           (modèle d'édition à référence d'identité : poses, expressions, tenues variées)
  train    Entraîne un LoRA par personnage sur ce jeu de données (entraînement cloud)
  assets   Génère les assets finaux du manifeste avec les LoRA (portraits, expressions,
           sprites, décors, CG) directement dans assets/ du projet Godot
  auto     approve + dataset + train + assets pour un personnage, en une commande

Backend : fal.ai via le client officiel `fal_client` (pip install fal-client), clé dans FAL_KEY.
`--dry-run` affiche les prompts et le plan sans aucun appel réseau.
"""
from __future__ import annotations

import argparse
import html
import json
import os
import shutil
import sys
import time
import urllib.request
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PROMPTS = ROOT / "data/art/prompts.json"
MANIFEST = ROOT / "data/art/manifest.json"
WORK = ROOT / "art_work"
LORAS = WORK / "loras.json"

# Modèles fal.ai (modifiables sans toucher au code via variables d'environnement)
MODEL_T2I = os.environ.get("ART_MODEL_T2I", "fal-ai/flux/dev")
MODEL_EDIT = os.environ.get("ART_MODEL_EDIT", "fal-ai/flux-pro/kontext")
MODEL_TRAIN = os.environ.get("ART_MODEL_TRAIN", "fal-ai/flux-lora-fast-training")
MODEL_LORA = os.environ.get("ART_MODEL_LORA", "fal-ai/flux-lora")

DATASET_VARIATIONS = [
    "same character, front view, neutral expression, plain grey background",
    "same character, three-quarter view, soft smile, plain grey background",
    "same character, side profile, serious expression",
    "same character, full body standing, base outfit",
    "same character, close-up face, looking at viewer",
    "same character, angry expression, dramatic rim light",
    "same character, laughing, warm light",
    "same character, sitting on a chair, relaxed",
    "same character, walking in a ruined neon street at night",
    "same character, combat stance with weapon",
    "same character, wearing casual outfit, indoor",
    "same character, sad expression, rain",
    "same character, looking over the shoulder, back view",
    "same character, upper body, arms crossed",
    "same character, low angle heroic shot",
    "same character, high angle, looking up",
    "same character, embarrassed blush, looking away",
    "same character, surprised, wide eyes",
    "same character, night lighting with cyan and magenta neon",
    "same character, golden hour light, calm",
]


def load_json(p: Path) -> dict:
    return json.loads(p.read_text(encoding="utf-8"))


def save_json(p: Path, data: dict) -> None:
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


class Ctx:
    def __init__(self, dry_run: bool):
        self.dry_run = dry_run
        self.prompts = load_json(PROMPTS)
        self.chars = {c["id"]: c for c in self.prompts["characters"]}
        self._fal = None

    @property
    def fal(self):
        if self._fal is None:
            if not os.environ.get("FAL_KEY"):
                sys.exit("FAL_KEY manquant : export FAL_KEY=... (ou --dry-run)")
            try:
                import fal_client  # type: ignore
            except ImportError:
                sys.exit("pip install fal-client")
            self._fal = fal_client
        return self._fal

    def run(self, model: str, args: dict) -> dict:
        if self.dry_run:
            print(f"  [dry-run] {model}: {json.dumps(args, ensure_ascii=False)[:400]}")
            return {}
        return self.fal.subscribe(model, arguments=args, with_logs=False)

    def style(self, prompt: str) -> str:
        return f"{prompt}, {self.prompts['style']['positive']}"


def download(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    with urllib.request.urlopen(url) as r, open(dest, "wb") as f:
        shutil.copyfileobj(r, f)


def images_of(result: dict) -> list[str]:
    imgs = result.get("images") or ([result["image"]] if result.get("image") else [])
    return [i["url"] if isinstance(i, dict) else i for i in imgs]


def select(ctx: Ctx, ids: list[str] | None) -> list[dict]:
    if not ids:
        return list(ctx.chars.values())
    missing = [i for i in ids if i not in ctx.chars]
    if missing:
        sys.exit(f"Personnages inconnus : {missing}")
    return [ctx.chars[i] for i in ids]


# --- étapes -----------------------------------------------------------------

def cmd_refs(ctx: Ctx, a) -> None:
    tpl = ctx.prompts["templates"]["ref_sheet"]
    params = ctx.prompts["style"]["params"]["flux"]
    for c in select(ctx, a.char):
        prompt = ctx.style(tpl.format(core=c["core"], outfit=c["outfits"]["base"]))
        print(f"[refs] {c['id']} × {a.n}")
        res = ctx.run(MODEL_T2I, {"prompt": prompt, "num_images": a.n, "image_size": "landscape_16_9",
                                  "num_inference_steps": params["num_inference_steps"],
                                  "guidance_scale": params["guidance_scale"], "enable_safety_checker": False})
        for i, url in enumerate(images_of(res), 1):
            download(url, WORK / "candidates/refs" / c["id"] / f"{i:02d}.png")
    cmd_review(ctx, a)


def cmd_review(ctx: Ctx, a) -> None:
    base = WORK / "candidates"
    rows = []
    for d in sorted(base.glob("*/*")) if base.exists() else []:
        imgs = "".join(
            f'<figure><img src="{html.escape(str(p.relative_to(WORK)))}"><figcaption>{p.name}</figcaption></figure>'
            for p in sorted(d.glob("*.png")))
        rows.append(f"<h2>{d.parent.name} / {d.name}</h2><div class=g>{imgs}</div>")
    page = ("<!doctype html><meta charset=utf-8><title>Revue des visuels</title><style>"
            "body{background:#111;color:#eee;font-family:sans-serif;margin:16px}"
            ".g{display:flex;flex-wrap:wrap;gap:12px}figure{margin:0}img{max-width:420px;border-radius:6px}"
            "</style><h1>Revue des visuels</h1><p>Valider : <code>python tools/art_pipeline/generate.py "
            "approve &lt;id&gt; &lt;fichier&gt;</code></p>" + "".join(rows))
    WORK.mkdir(exist_ok=True)
    (WORK / "review.html").write_text(page, encoding="utf-8")
    print(f"[review] {WORK / 'review.html'}")


def cmd_approve(ctx: Ctx, a) -> None:
    src = WORK / "candidates/refs" / a.id / a.file
    if not src.exists() and not ctx.dry_run:
        sys.exit(f"Introuvable : {src}")
    dest = WORK / "approved" / a.id / "ref.png"
    if not ctx.dry_run:
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(src, dest)
    print(f"[approve] {a.id} ← {src.name}")


def cmd_dataset(ctx: Ctx, a) -> None:
    c = ctx.chars[a.id]
    ref = WORK / "approved" / a.id / "ref.png"
    ref_url = "<ref_url>" if ctx.dry_run else ctx.fal.upload_file(str(ref))
    out = WORK / "datasets" / a.id
    for i, var in enumerate(DATASET_VARIATIONS[: a.n], 1):
        prompt = ctx.style(f"{c['token']}, {var}. Keep exactly the same face, hair, body and distinctive marks")
        res = ctx.run(MODEL_EDIT, {"prompt": prompt, "image_url": ref_url, "enable_safety_checker": False})
        for url in images_of(res)[:1]:
            download(url, out / f"{i:02d}.png")
            (out / f"{i:02d}.txt").write_text(f"{c['token']}, {var}", encoding="utf-8")
    print(f"[dataset] {a.id} : {a.n} images → {out}")


def cmd_train(ctx: Ctx, a) -> None:
    c = ctx.chars[a.id]
    ds = WORK / "datasets" / a.id
    archive = WORK / f"{a.id}_dataset.zip"
    if not ctx.dry_run:
        with zipfile.ZipFile(archive, "w") as z:
            for p in ds.iterdir():
                z.write(p, p.name)
    url = "<zip_url>" if ctx.dry_run else ctx.fal.upload_file(str(archive))
    res = ctx.run(MODEL_TRAIN, {"images_data_url": url, "trigger_word": c["token"], "steps": a.steps})
    lora = (res.get("diffusers_lora_file") or {}).get("url")
    if lora:
        loras = load_json(LORAS) if LORAS.exists() else {}
        loras[a.id] = {"url": lora, "trigger": c["token"], "trained_at": int(time.time())}
        save_json(LORAS, loras)
    print(f"[train] {a.id} → {lora or '(dry-run)'}")


def compose(ctx: Ctx, item: dict) -> str:
    tpl, expr = ctx.prompts["templates"], ctx.prompts["expressions"]
    if item.get("prompt"):
        return ctx.style(item["prompt"])
    c = ctx.chars[item["char"]]
    outfit = c["outfits"].get(item.get("outfit", "base"), c["outfits"]["base"])
    e = item.get("expression", "neutral")
    e_txt = expr.get(e) or c.get("signature_expressions", {}).get(e, e)
    kind = item["kind"]
    if kind == "combat_sprite":
        return ctx.style(tpl["combat_sprite"].format(core=c["token"], outfit=outfit, weapon=c["weapon"]))
    if kind == "full_body":
        return ctx.style(tpl["full_body"].format(core=c["token"], outfit=outfit))
    return ctx.style(tpl["portrait"].format(core=c["token"], outfit=outfit, expression=e_txt))


def cmd_assets(ctx: Ctx, a) -> None:
    manifest = load_json(MANIFEST)
    loras = load_json(LORAS) if LORAS.exists() else {}
    for item in manifest["assets"]:
        if a.char and item.get("char") not in a.char:
            continue
        if a.kind and item["kind"] not in a.kind:
            continue
        dest = ROOT / item["out"]
        if dest.exists() and not a.force:
            continue
        chars = [item["char"]] if item.get("char") else item.get("chars", [])
        lora_list = [{"path": loras[c]["url"], "scale": 1.0} for c in chars if c in loras]
        if chars and not lora_list and not ctx.dry_run:
            print(f"  ! {item['id']} : LoRA absent pour {chars}, génération sans LoRA")
        prompt = compose(ctx, item)
        print(f"[assets] {item['id']} → {item['out']}")
        args = {"prompt": prompt, "num_images": 1, "image_size": item.get("size", "portrait_4_3"),
                "enable_safety_checker": False}
        if lora_list:
            args["loras"] = lora_list
        res = ctx.run(MODEL_LORA if lora_list else MODEL_T2I, args)
        for url in images_of(res)[:1]:
            download(url, dest)


def cmd_auto(ctx: Ctx, a) -> None:
    cmd_approve(ctx, a)
    cmd_dataset(ctx, argparse.Namespace(id=a.id, n=a.n))
    cmd_train(ctx, argparse.Namespace(id=a.id, steps=a.steps))
    cmd_assets(ctx, argparse.Namespace(char=[a.id], kind=None, force=False))


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--dry-run", action="store_true")
    sub = p.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("refs"); s.add_argument("--char", nargs="*"); s.add_argument("--n", type=int, default=4)
    sub.add_parser("review")
    s = sub.add_parser("approve"); s.add_argument("id"); s.add_argument("file")
    s = sub.add_parser("dataset"); s.add_argument("id"); s.add_argument("--n", type=int, default=20)
    s = sub.add_parser("train"); s.add_argument("id"); s.add_argument("--steps", type=int, default=1000)
    s = sub.add_parser("assets"); s.add_argument("--char", nargs="*"); s.add_argument("--kind", nargs="*")
    s.add_argument("--force", action="store_true")
    s = sub.add_parser("auto"); s.add_argument("id"); s.add_argument("file")
    s.add_argument("--n", type=int, default=20); s.add_argument("--steps", type=int, default=1000)
    a = p.parse_args()
    ctx = Ctx(a.dry_run)
    {"refs": cmd_refs, "review": cmd_review, "approve": cmd_approve, "dataset": cmd_dataset,
     "train": cmd_train, "assets": cmd_assets, "auto": cmd_auto}[a.cmd](ctx, a)


if __name__ == "__main__":
    main()
