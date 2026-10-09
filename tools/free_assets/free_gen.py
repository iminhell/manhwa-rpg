#!/usr/bin/env python3
"""
Génération GRATUITE des assets du jeu sur GPU (Google Colab T4 gratuit, ou PC local avec carte NVIDIA).

  python tools/free_assets/free_gen.py plan                 ce qui reste à produire (aucun téléchargement)
  python tools/free_assets/free_gen.py sprites [--limit N]  sprites des personnages en pied (style de tools/free_assets/
                                                            sprite_style.json, checkpoint + LoRA, fond transparent rembg)
                                                            → assets/portraits/<perso>/<expression>.png, assets/sprites/
  python tools/free_assets/free_gen.py images [--limit N]   décors, sprites d'ennemis, CG non nsfw  → assets/…/*.png
  python tools/free_assets/free_gen.py music                pistes de data/audio/music.json  → assets/audio/music/*.ogg
  python tools/free_assets/free_gen.py voices               répliques de tools/voice_pipeline/lines.csv (ko + ja)
                                                            → assets/voice/<langue>/<personnage>/<id>.ogg
Options : --force (refaire les fichiers existants), --only <id…> (restreindre), --dry-run (plan détaillé, sans modèle).

Sources de vérité : data/art/manifest.json + data/art/prompts.json (images), data/audio/music.json (« prompt » en anglais),
data/characters/*.json → voice.xtts (voix XTTS de chaque personnage).

Modèles (téléchargés depuis Hugging Face au premier lancement, surchargeables par variables d'environnement) :
  images  FREE_IMAGE_MODEL   cagliostrolab/animagine-xl-3.1 (SDXL, licence Fair AI Public License, usage personnel)
  musique FREE_MUSIC_MODEL   facebook/musicgen-medium (CC-BY-NC 4.0, usage non commercial)
  voix    XTTS-v2 (Coqui Public Model License, usage non commercial) — exige COQUI_TOS_AGREED=1 (accepté par l'utilisateur)

Les CG marquées « nsfw » ne sont PAS générées ici : elles passent par le backend RunPod (tools/art_pipeline).
Un fichier déjà présent n'est jamais regénéré sans --force : on peut relancer après une coupure, la génération reprend.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/art_pipeline"))
import generate as art  # noqa: E402  (compose() : mêmes prompts que le pipeline payant)

MANIFEST = ROOT / "data/art/manifest.json"
PROMPTS = ROOT / "data/art/prompts.json"
MUSIC = ROOT / "data/audio/music.json"
LINES = ROOT / "tools/voice_pipeline/lines.csv"
CHARS = ROOT / "data/characters"

IMAGE_MODEL = os.environ.get("FREE_IMAGE_MODEL", "cagliostrolab/animagine-xl-3.1")
MUSIC_MODEL = os.environ.get("FREE_MUSIC_MODEL", "facebook/musicgen-medium")
XTTS_MODEL = "tts_models/multilingual/multi-dataset/xtts_v2"
SIZES = {"portrait_4_3": (896, 1152), "landscape_16_9": (1344, 768), "square": (1024, 1024)}
QUALITY = "masterpiece, best quality, very aesthetic, absurdres, adult"
SFW_NEGATIVE = "nsfw, nude, naked, nipples, explicit, sex"
MUSIC_SECONDS = 30
LANGS = ("ko", "ja")
SPRITE_STYLE = ROOT / "tools/free_assets/sprite_style.json"
SPRITE_KINDS = ("portrait", "combat_sprite")
MODELS_DIR = Path(os.environ.get("FREE_MODELS_DIR", ROOT / "art_work/models"))  # art_work/ est ignoré par git
SPRITE_BASES = ROOT / "art_work/sprite_bases"  # pose neutre sur fond blanc, base de l'inpainting des expressions


def load_json(p: Path):
    return json.loads(p.read_text(encoding="utf-8"))


def seed_of(key: str) -> int:
    return int(hashlib.sha256(key.encode()).hexdigest()[:8], 16)


def to_ogg(src: Path, dest: Path, fade_out: float = 0.0, duration: float = 0.0) -> None:
    """Convertit en Ogg Vorbis (format lu par Godot). Fondu de sortie facultatif pour les boucles musicales."""
    dest.parent.mkdir(parents=True, exist_ok=True)
    af = []
    if fade_out and duration > fade_out:
        af = ["-af", f"afade=t=in:d=0.3,afade=t=out:st={duration - fade_out:.2f}:d={fade_out}"]
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(src), *af, "-c:a", "libvorbis", "-q:a", "5", str(dest)],
                   check=True)


def device() -> str:
    try:
        import torch  # noqa: PLC0415
        return "cuda" if torch.cuda.is_available() else "cpu"
    except ImportError:
        return "cpu"


# --- Images ---------------------------------------------------------------------------------------------------------

def image_jobs(force: bool, only: list[str] | None) -> list[dict]:
    """Entrées du manifeste à produire ici : tout sauf « nsfw » (RunPod) et sauf les sprites de personnages
    (portraits et sprites de combat : étape « sprites », style dédié et fond transparent)."""
    jobs = []
    for item in load_json(MANIFEST)["assets"]:
        if item.get("nsfw") or item["kind"] in SPRITE_KINDS or (only and item["id"] not in only):
            continue
        if (ROOT / item["out"]).exists() and not force:
            continue
        jobs.append(item)
    return jobs


def sdxl_prompt(ctx, item: dict) -> str:
    """Prompt du pipeline payant, adapté au SDXL sans LoRA : chaque jeton de personnage devient sa description."""
    prompt = art.compose(ctx, item)
    chars = [item["char"]] if item.get("char") else item.get("chars", [])
    for cid in chars:
        c = ctx.chars.get(cid)
        if not c:
            continue
        parts = [p.strip() for p in c["core"].split(",")][1:]
        ident = ", ".join(parts if len(chars) == 1 else parts[:6])  # scène à plusieurs : identité courte
        prompt = prompt.replace(c["token"], ident, 1).replace(c["token"], ident.split(",")[0])
    prompt = re.sub(r"[()]", ",", prompt)  # pas de pondération Compel accidentelle
    return f"{QUALITY}, {prompt}"


def enable_vae_slicing(pipe) -> str:
    """Décodage du VAE par tranches (moins de VRAM). L'API a changé selon les versions de diffusers :
    récentes → pipe.vae.enable_slicing() (la méthode du pipeline a été retirée), anciennes → pipe.enable_vae_slicing()."""
    vae = getattr(pipe, "vae", None)
    if callable(getattr(vae, "enable_slicing", None)):
        vae.enable_slicing()
        return "vae.enable_slicing"
    if callable(getattr(pipe, "enable_vae_slicing", None)):
        pipe.enable_vae_slicing()
        return "pipe.enable_vae_slicing"
    return ""  # optionnel : sans tranches, l'image se décode quand même (un peu plus de VRAM)


def parse_weights(text: str) -> list[tuple[str, float]]:
    """Syntaxe de pondération A1111 : « (mot) » ×1,1, « [mot] » ÷1,1, « (mot:1.4) » poids explicite, imbrications,
    « \\( » pour une parenthèse littérale. Renvoie des fragments (texte, poids)."""
    out: list[list] = []
    stack: list[list] = []  # [multiplicateur, indice du premier fragment dans out]
    buf = ""

    def flush():
        nonlocal buf
        if buf:
            w = 1.0
            for m, _ in stack:
                w *= m
            out.append([buf, w])
            buf = ""

    i = 0
    while i < len(text):
        ch = text[i]
        if ch == "\\" and i + 1 < len(text):
            buf += text[i + 1]
            i += 2
            continue
        if ch in "([":
            flush()
            stack.append([1.1 if ch == "(" else 1 / 1.1, len(out)])
        elif ch == ")" and stack and stack[-1][0] != 1 / 1.1:
            m = re.search(r":\s*(-?[0-9]*\.?[0-9]+)\s*$", buf)
            if m:
                buf = buf[: m.start()]
            flush()
            mult, start = stack.pop()
            if m:  # poids explicite : remplace le ×1,1 implicite de cette parenthèse
                for frag in out[start:]:
                    frag[1] = frag[1] / mult * float(m.group(1))
        elif ch == "]" and stack:
            flush()
            stack.pop()
        else:
            buf += ch
        i += 1
    flush()
    return [(t, w) for t, w in out if t.strip()] or [("", 1.0)]


def token_chunks(tokenizer, text: str) -> list[list[tuple[int, float]]]:
    """Jetons pondérés du texte (sans BOS/EOS), découpés en tranches de 75 : la fenêtre de 77 de CLIP, moins BOS et EOS."""
    ids: list[tuple[int, float]] = []
    for frag, w in parse_weights(text):
        ids += [(t, w) for t in tokenizer(frag, add_special_tokens=False, truncation=False)["input_ids"]]
    size = tokenizer.model_max_length - 2
    return [ids[i:i + size] for i in range(0, len(ids), size)] or [[]]


def encode_long_prompt(pipe, text: str, n_chunks: int, torch):
    """Encodage SDXL sans limite de 77 jetons (remplace compel, dont l'API a changé) : chaque tranche passe dans les deux
    encodeurs comme dans StableDiffusionXLPipeline.encode_prompt (avant-dernière couche cachée, embedding « pooled » de
    la première tranche du second encodeur), puis les tranches sont mises bout à bout. n_chunks complète avec des tranches
    vides, pour que le prompt et le négatif aient la même longueur. Les poids « (mot:1.4) » multiplient les états des
    jetons concernés, puis la moyenne de la tranche est restaurée (comme le fait A1111)."""
    per_encoder, pooled = [], None
    for tok, enc in ((pipe.tokenizer, pipe.text_encoder), (pipe.tokenizer_2, pipe.text_encoder_2)):
        chunks = token_chunks(tok, text)
        chunks += [[]] * (n_chunks - len(chunks))
        pad = tok.pad_token_id if tok.pad_token_id is not None else tok.eos_token_id
        dev = next(enc.parameters()).device
        states = []
        for k, chunk in enumerate(chunks[:n_chunks]):
            seq = [tok.bos_token_id] + [t for t, _ in chunk] + [tok.eos_token_id]
            weights = [1.0] + [w for _, w in chunk] + [1.0]
            seq += [pad] * (tok.model_max_length - len(seq))
            weights += [1.0] * (tok.model_max_length - len(weights))
            out = enc(torch.tensor([seq], device=dev), output_hidden_states=True)
            z = out.hidden_states[-2]
            if any(w != 1.0 for w in weights):
                mean = z.mean()
                z = z * torch.tensor(weights, device=z.device, dtype=z.dtype)[None, :, None]
                z = z * (mean / z.mean())
            states.append(z)
            if enc is pipe.text_encoder_2 and k == 0 and out[0].ndim == 2:
                pooled = out[0]
        per_encoder.append(torch.cat(states, dim=1))
    return torch.cat(per_encoder, dim=-1), pooled


class SdxlBackend:
    def __init__(self, pipe=None) -> None:
        import torch  # noqa: PLC0415
        self.torch = torch
        self.dev = device()
        if pipe is None:
            from diffusers import EulerAncestralDiscreteScheduler, StableDiffusionXLPipeline  # noqa: PLC0415
            dtype = torch.float16 if self.dev == "cuda" else torch.float32
            pipe = StableDiffusionXLPipeline.from_pretrained(IMAGE_MODEL, torch_dtype=dtype, use_safetensors=True)
            pipe.scheduler = EulerAncestralDiscreteScheduler.from_config(pipe.scheduler.config)
        self.pipe = pipe.to(self.dev)
        enable_vae_slicing(self.pipe)

    def embeddings(self, prompt: str, negative: str) -> dict:
        n = max(len(token_chunks(t, s)) for t in (self.pipe.tokenizer, self.pipe.tokenizer_2) for s in (prompt, negative))
        with self.torch.no_grad():
            cond, pooled = encode_long_prompt(self.pipe, prompt, n, self.torch)
            ncond, npooled = encode_long_prompt(self.pipe, negative, n, self.torch)
        return {"prompt_embeds": cond, "pooled_prompt_embeds": pooled,
                "negative_prompt_embeds": ncond, "negative_pooled_prompt_embeds": npooled}

    def render(self, prompt: str, negative: str, size: tuple[int, int], seed: int, steps: int = 28):
        gen = self.torch.Generator(self.dev).manual_seed(seed)
        return self.pipe(width=size[0], height=size[1], num_inference_steps=steps, guidance_scale=6.5, generator=gen,
                         **self.embeddings(prompt, negative)).images[0]


def cmd_images(a, backend=None) -> int:
    ctx = art.Ctx(dry_run=True)
    negative = f"{ctx.prompts['style']['negative']}, {SFW_NEGATIVE}"
    jobs = image_jobs(a.force, a.only)[: a.limit or None]
    print(f"[images] {len(jobs)} image(s) à produire avec {IMAGE_MODEL}")
    if a.dry_run or not jobs:
        for it in jobs:
            print(f"  {it['id']} → {it['out']} :: {sdxl_prompt(ctx, it)[:160]}…")
        return len(jobs)
    backend = backend or SdxlBackend()
    for i, it in enumerate(jobs, 1):
        dest = ROOT / it["out"]
        img = backend.render(sdxl_prompt(ctx, it), negative, SIZES.get(it.get("size", "portrait_4_3"), SIZES["portrait_4_3"]),
                             seed_of(it["id"]))
        dest.parent.mkdir(parents=True, exist_ok=True)
        img.save(dest, optimize=True)
        print(f"  [{i}/{len(jobs)}] {it['out']}", flush=True)
    return len(jobs)


# --- Sprites de personnages (portraits en pied et sprites de combat, fond transparent) -------------------------------

def fetch(url: str, dest: Path) -> Path:
    """Télécharge un modèle une seule fois. Civitai : jeton facultatif CIVITAI_TOKEN (certains modèles l'exigent)."""
    if dest.exists() and dest.stat().st_size > 0:
        return dest
    import urllib.error  # noqa: PLC0415
    import urllib.request  # noqa: PLC0415
    token = os.environ.get("CIVITAI_TOKEN", "")
    full = url + (("&" if "?" in url else "?") + f"token={token}" if token and "civitai.com" in url else "")
    dest.parent.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_suffix(dest.suffix + ".part")
    print(f"  téléchargement : {url} → {dest.name}", flush=True)
    req = urllib.request.Request(full, headers={"User-Agent": "manhwa-rpg-assets/1.0"})
    try:
        with urllib.request.urlopen(req, timeout=600) as r, tmp.open("wb") as f:
            shutil.copyfileobj(r, f, length=1 << 22)
    except urllib.error.HTTPError as e:
        tmp.unlink(missing_ok=True)
        hint = " (ajouter le secret Colab CIVITAI_TOKEN : civitai.com ▸ Account Settings ▸ API Keys)" if "civitai" in url else ""
        sys.exit(f"Téléchargement refusé ({e.code}) : {url}{hint}")
    tmp.rename(dest)
    return dest


def load_style() -> dict:
    return load_json(SPRITE_STYLE)


def sprite_prompt(style: dict, cid: str, expression: str = "neutral", combat: bool = False) -> str:
    """Prompt de sprite : qualité commune, déclencheurs des LoRA, gabarit et identité du personnage, pose, expression."""
    c = style["characters"][cid]
    pose = style["pose_combat"] if combat else (c.get("pose") or style["pose_male" if c.get("male") else "pose_female"])
    allure = "" if c.get("male") else style.get("allure_female", "")  # traits ecchi des héroïnes (sans nudité)
    parts = [style["quality"], *(lo["trigger"] for lo in style["loras"] if lo.get("trigger")), c["body"], allure, c["look"],
             c["outfit"], pose]
    if combat:
        weapons = {x["id"]: x.get("weapon", "") for x in load_json(PROMPTS)["characters"]}
        parts.append(weapons.get(cid, ""))
    else:  # expression propre au personnage d'abord (Elias : charisme froid plutôt que sourire séducteur)
        parts.append(c.get("expressions", {}).get(expression) or style["expressions"].get(expression, expression))
    parts.append(style["background"])
    drop = set(c.get("drop_tags", []))  # étiquettes communes qui ne conviennent pas à ce personnage
    tags = [t.strip() for p in parts if p for t in p.split(",")]
    return ", ".join(t for t in tags if t and t not in drop)


def sprite_jobs(force: bool, only: list[str] | None) -> list[dict]:
    """Sprites à produire, la pose neutre de chaque personnage en premier (base des autres expressions)."""
    jobs = []
    for item in load_json(MANIFEST)["assets"]:
        if item["kind"] not in SPRITE_KINDS or item.get("nsfw"):
            continue
        if only and item["id"] not in only and item.get("char") not in only:
            continue
        if (ROOT / item["out"]).exists() and not force:
            continue
        jobs.append(item)
    return sorted(jobs, key=lambda i: (i["kind"], i.get("char", ""), i.get("expression", "neutral") != "neutral"))


def sprite_negative(style: dict, cid: str) -> str:
    """Négatif commun + négatif propre au personnage (ex. Elias : pas de barbe, pas d'air renfrogné)."""
    extra = style["characters"].get(cid, {}).get("negative", "")
    return f"{style['negative']}, {extra}" if extra else style["negative"]


def sharpen(img, cfg: dict | None):
    """Accentuation finale (UnsharpMask) : trait net sans halo, avant le détourage."""
    if not cfg:
        return img
    from PIL import ImageFilter  # noqa: PLC0415
    return img.filter(ImageFilter.UnsharpMask(radius=float(cfg.get("radius", 1.3)), percent=int(cfg.get("percent", 75)),
                                              threshold=int(cfg.get("threshold", 3))))


def coverage(rgba) -> float:
    """Part de l'image couverte par la silhouette (alpha > 128)."""
    a = rgba.getchannel("A")
    hist = a.histogram()
    return sum(hist[129:]) / max(1, a.width * a.height)


def sprite_problem(img, cut) -> str:
    """Défaut bloquant d'un sprite, ou "" : image uniforme (VAE en NaN → image noire), détourage vide ou presque
    (personnage effacé avec le fond), ou silhouette tronquée (le sprite est en pied)."""
    from PIL import ImageStat  # noqa: PLC0415
    if ImageStat.Stat(img.convert("L")).stddev[0] < 3:
        return "image uniforme (rendu raté)"
    cov = coverage(cut)
    if cov < 0.03:
        return f"détourage presque vide ({cov:.1%} de l'image)"
    if cov > 0.9:
        return f"fond non détouré ({cov:.0%} de l'image)"
    box = cut.getchannel("A").point(lambda v: 255 if v > 128 else 0).getbbox()
    if not box or (box[3] - box[1]) < 0.5 * cut.height:
        return "silhouette tronquée (moins de la moitié de la hauteur)"
    return ""


def trim_box(alpha, margin: float = 0.03) -> tuple[int, int, int, int]:
    """Cadre serré autour de la silhouette (+ marge) : l'image finale ne garde pas les grandes marges vides
    (moins de mémoire vidéo en jeu, la mise en scène se cale sur la silhouette)."""
    w, h = alpha.size
    l, t, r, b = alpha.point(lambda v: 255 if v > 16 else 0).getbbox() or (0, 0, w, h)
    m = int(h * margin)
    return max(0, l - m), max(0, t - m), min(w, r + m), min(h, b + m)


def upscale_tiled(model, x, scale: int, tile: int = 512, pad: int = 16):
    """Applique un modèle d'agrandissement (tenseur 1×C×H×W → ×scale) par tuiles chevauchantes : mémoire bornée sur T4,
    seul le centre de chaque tuile est gardé (pas de couture)."""
    _, c, h, w = x.shape
    out = x.new_zeros((1, c, h * scale, w * scale))
    for y0 in range(0, h, tile):
        for x0 in range(0, w, tile):
            y1, x1 = min(y0 + tile, h), min(x0 + tile, w)
            py0, px0, py1, px1 = max(y0 - pad, 0), max(x0 - pad, 0), min(y1 + pad, h), min(x1 + pad, w)
            res = model(x[:, :, py0:py1, px0:px1])
            oy, ox = (y0 - py0) * scale, (x0 - px0) * scale
            out[:, :, y0 * scale:y1 * scale, x0 * scale:x1 * scale] = \
                res[:, :, oy:oy + (y1 - y0) * scale, ox:ox + (x1 - x0) * scale]
    return out


class Upscaler:
    """Agrandissement du hires fix par un réseau entraîné sur l'anime (Real-ESRGAN x4plus anime 6B, chargé par spandrel) :
    trait net et aplats propres, là où un agrandissement Lanczos donne une image floue que l'img2img ne rattrape qu'à
    moitié (rendu « 120p »). Facultatif : si le modèle ne se charge pas, repli sur Lanczos (avertissement)."""

    def __init__(self, cfg: dict | None, model=None) -> None:
        self.cfg = cfg or {}
        self.model = model
        self.failed = model is None and not (self.cfg.get("url") or self.cfg.get("path"))

    def _load(self) -> None:
        if self.model is not None or self.failed:
            return
        try:
            from spandrel import ModelLoader  # noqa: PLC0415
            path = Path(self.cfg["path"]) if self.cfg.get("path") else \
                fetch(self.cfg["url"], MODELS_DIR / "upscalers" / f"{self.cfg.get('name', 'upscaler')}.pth")
            desc = ModelLoader().load_from_file(str(path))
            desc.to(device()).eval()
            if device() == "cuda" and desc.supports_half:
                desc.half()
            self.model = desc
        except (Exception, SystemExit) as e:  # noqa: BLE001
            print(f"  ! agrandisseur {self.cfg.get('name', '')} indisponible ({e.__class__.__name__}: {e}) : Lanczos")
            self.failed = True

    def resize(self, img, size: tuple[int, int]):
        from PIL import Image  # noqa: PLC0415
        self._load()
        if self.model is None:
            return img.resize(size, Image.LANCZOS)
        import numpy as np  # noqa: PLC0415
        import torch  # noqa: PLC0415
        dtype, dev = getattr(self.model, "dtype", torch.float32), getattr(self.model, "device", "cpu")
        x = torch.from_numpy(np.asarray(img.convert("RGB"), np.float32) / 255.0).permute(2, 0, 1)[None]
        with torch.no_grad():
            y = upscale_tiled(self.model, x.to(dev, dtype), int(getattr(self.model, "scale", 4)), int(self.cfg.get("tile", 512)))
        arr = (y[0].float().clamp(0, 1).permute(1, 2, 0).cpu().numpy() * 255.0).round().astype(np.uint8)
        return Image.fromarray(arr, "RGB").resize(size, Image.LANCZOS)


def head_mask(alpha, margin: float = 0.18):
    """Masque d'inpainting du visage : bande haute de la silhouette (alpha du sprite neutre), élargie et adoucie."""
    from PIL import Image, ImageDraw, ImageFilter  # noqa: PLC0415
    w, h = alpha.size
    solid = alpha.point(lambda v: 255 if v > 32 else 0)
    l, t, r, b = solid.getbbox() or (0, 0, w, h)
    band_bottom = t + int((b - t) * 0.2)
    hl, _, hr, _ = solid.crop((0, t, w, band_bottom)).getbbox() or (l, 0, r, 0)
    pad = int((hr - hl) * margin) + 8
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rectangle((max(0, hl - pad), max(0, t - pad), min(w, hr + pad), min(h, band_bottom + pad)), fill=255)
    return mask.filter(ImageFilter.GaussianBlur(6))


ALPHA_DEFAULTS = {"min_alpha": 24, "shadow_band": 0.1, "min_island": 0.002, "white": 210, "white_alpha": 0.6,
                  "choke": [0.12, 0.85]}


def clean_alpha(rgba, opts: dict | None = None):
    """Nettoie un détourage rembg fait sur fond blanc (sprites d'anime), sans toucher aux couleurs visibles : le trait de
    contour (lineart), souvent semi-transparent au bord, doit rester intact.
    1. fond résiduel : alpha faible, et pixels presque blancs à l'alpha incertain (voile autour des cheveux, fond coincé
       entre deux éléments) → transparents ;
    2. ombre portée sous les pieds : dans la bande basse de la silhouette, gris neutre semi-transparent (sa couleur,
       une fois le blanc du fond retiré, est sombre et sans saturation) → transparent ;
    3. îlots détachés plus petits qu'une fraction de la silhouette → transparents ;
    4. « resserrement » de l'alpha (niveaux bas/haut) : le voile qui bave autour du contour disparaît, le trait reste ;
    5. « alpha bleeding » : les pixels transparents prennent la couleur du bord visible voisin, pour que le filtrage
       bilinéaire de Godot ne fasse pas apparaître de halo blanc ou noir autour du sprite."""
    import numpy as np  # noqa: PLC0415
    from PIL import Image, ImageFilter  # noqa: PLC0415
    o = {**ALPHA_DEFAULTS, **(opts or {})}
    arr = np.asarray(rgba.convert("RGBA"), dtype=np.float32)
    rgb, a = arr[..., :3].copy(), arr[..., 3] / 255.0
    lum, sat = rgb.mean(axis=2), rgb.max(axis=2) - rgb.min(axis=2)
    a[a < o["min_alpha"] / 255.0] = 0.0
    a[(a < o["white_alpha"]) & (sat < 20) & (lum > o["white"])] = 0.0
    solid = a > 0.5
    if solid.any():
        rows = np.where(solid.any(axis=1))[0]
        top, bottom = rows[0], rows[-1]
        band = np.zeros_like(solid)
        band[int(bottom - (bottom - top) * o["shadow_band"]):, :] = True
        true = np.clip((rgb - (1.0 - a[..., None]) * 255.0) / np.maximum(a[..., None], 0.05), 0, 255)
        true_sat = true.max(axis=2) - true.min(axis=2)
        a[band & (a < 0.85) & (true_sat < 30) & (true.mean(axis=2) < 150)] = 0.0
        try:
            from scipy import ndimage  # noqa: PLC0415
            labels, n = ndimage.label(a > 0.1)
            if n > 1:
                sizes = ndimage.sum(np.ones_like(a), labels, index=np.arange(1, n + 1))
                a[np.isin(labels, np.where(sizes < o["min_island"] * sizes.max())[0] + 1)] = 0.0
        except ImportError:
            pass
    lo, hi = o["choke"]
    a = np.clip((a - lo) / max(hi - lo, 1e-3), 0.0, 1.0)
    clear = a <= 0.0
    if clear.any() and (~clear).any():
        blur = ImageFilter.GaussianBlur(4)
        num = [np.asarray(Image.fromarray(np.clip(rgb[..., c] * a, 0, 255).astype(np.uint8)).filter(blur), np.float32)
               for c in range(3)]
        den = np.asarray(Image.fromarray((a * 255).astype(np.uint8)).filter(blur), np.float32) / 255.0
        spread = np.dstack(num) / np.maximum(den[..., None], 1e-3)
        rgb[clear] = np.where(den[clear, None] > 0.002, spread[clear], 0.0)
    out = np.dstack([np.clip(rgb, 0, 255), a * 255.0]).round().astype(np.uint8)
    return Image.fromarray(out, "RGBA")


def enable_vae_tiling(pipe) -> None:
    """Décodage du VAE par tuiles (grandes images du hires fix) ; même compatibilité que enable_vae_slicing."""
    vae = getattr(pipe, "vae", None)
    if callable(getattr(vae, "enable_tiling", None)):
        vae.enable_tiling()
    elif callable(getattr(pipe, "enable_vae_tiling", None)):
        pipe.enable_vae_tiling()


def box_mask(size: tuple[int, int], box, pad: float = 0.25):
    """Masque d'inpainting rectangulaire autour d'une détection (élargi de « pad », bords adoucis)."""
    from PIL import Image, ImageDraw, ImageFilter  # noqa: PLC0415
    w, h = size
    x0, y0, x1, y1 = box
    dx, dy = (x1 - x0) * pad + 6, (y1 - y0) * pad + 6
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rectangle((max(0, x0 - dx), max(0, y0 - dy), min(w, x1 + dx), min(h, y1 + dy)), fill=255)
    return mask.filter(ImageFilter.GaussianBlur(4))


class Detailer:
    """Repère les visages et les mains (modèles YOLO d'ADetailer, Bingsu/adetailer) pour les repeindre en haute
    résolution. Facultatif : si le modèle ne se charge pas, la génération continue sans retouche (avertissement)."""

    def __init__(self, cfg: dict, models: dict | None = None) -> None:
        self.cfg = cfg or {}
        self.models = models
        self.failed = False

    def _load(self) -> None:
        if self.models is not None or self.failed:
            return
        try:
            from huggingface_hub import hf_hub_download  # noqa: PLC0415
            from ultralytics import YOLO  # noqa: PLC0415
            repo = self.cfg.get("repo", "Bingsu/adetailer")
            self.models = {k: YOLO(hf_hub_download(repo, self.cfg[f"{k}_model"])) for k in ("face", "hand")
                           if self.cfg.get(f"{k}_model")}
        except Exception as e:  # noqa: BLE001
            print(f"  ! détailleur indisponible ({e.__class__.__name__}: {e}) : visages et mains non retouchés")
            self.failed, self.models = True, {}

    def boxes(self, img, kind: str) -> list[tuple[float, float, float, float]]:
        """Boîtes (x0, y0, x1, y1) détectées, la plus grande d'abord."""
        self._load()
        model = (self.models or {}).get(kind)
        if model is None:
            return []
        try:
            res = model.predict(img, conf=float(self.cfg.get("confidence", 0.35)), verbose=False)[0]
            found = [tuple(float(v) for v in b) for b in res.boxes.xyxy.cpu().numpy().tolist()]
        except Exception as e:  # noqa: BLE001
            print(f"  ! détection {kind} impossible ({e.__class__.__name__}) : ignorée")
            return []
        return sorted(found, key=lambda b: -(b[2] - b[0]) * (b[3] - b[1]))[: int(self.cfg.get("max_per_kind", 4))]


class SpriteBackend(SdxlBackend):
    """Checkpoint SDXL (fichier unique) + LoRA, génération sur fond blanc puis :
    hires fix (agrandissement + img2img léger : détails et trait nets), retouche des visages et des mains détectés
    (inpainting en 1024 px), expressions par inpainting du visage (corps identique au pixel près, clignement compris),
    détourage rembg (isnet-anime) et nettoyage du masque."""

    def __init__(self, style: dict, pipe=None, remover=None, detector_models: dict | None = None, upscaler=None) -> None:
        import torch  # noqa: PLC0415
        if pipe is None:
            from diffusers import StableDiffusionXLPipeline  # noqa: PLC0415
            ck = style["checkpoint"]
            path = fetch(ck["url"], MODELS_DIR / f"{ck['name']}.safetensors")
            dtype = torch.float16 if device() == "cuda" else torch.float32
            extra = {}
            if style.get("vae"):  # VAE corrigé pour le fp16 : sans lui, les grandes images peuvent sortir noires (NaN)
                try:
                    from diffusers import AutoencoderKL  # noqa: PLC0415
                    extra["vae"] = AutoencoderKL.from_pretrained(style["vae"], torch_dtype=dtype)
                except Exception as e:  # noqa: BLE001
                    print(f"  ! VAE {style['vae']} indisponible ({e.__class__.__name__}) : VAE du checkpoint")
            pipe = StableDiffusionXLPipeline.from_single_file(str(path), torch_dtype=dtype, **extra)
        pipe.scheduler = make_scheduler(style.get("sampler", "euler_a"), pipe.scheduler.config)
        # LoRA : fichier local (« path ») ou téléchargé une fois (« url »)
        loras = [(lo["name"], Path(lo["path"]) if lo.get("path") else fetch(lo["url"], MODELS_DIR / "loras" / f"{lo['name']}.safetensors"),
                  lo["weight"]) for lo in style.get("loras", [])]
        for name, path, _ in loras:
            pipe.load_lora_weights(str(path.parent), weight_name=path.name, adapter_name=name)
        if loras:
            pipe.set_adapters([n for n, _, _ in loras], adapter_weights=[w for _, _, w in loras])
        super().__init__(pipe=pipe)
        enable_vae_tiling(self.pipe)
        from diffusers import StableDiffusionXLImg2ImgPipeline, StableDiffusionXLInpaintPipeline  # noqa: PLC0415
        self.inpaint_pipe = StableDiffusionXLInpaintPipeline(**self.pipe.components)
        self.img2img_pipe = StableDiffusionXLImg2ImgPipeline(**self.pipe.components)
        self.style = style
        self.remover = remover
        self.detailer = Detailer(style.get("detailer", {}), detector_models)
        self.upscaler = Upscaler(style.get("hires", {}).get("upscaler"), upscaler)
        self.masks: dict[str, object] = {}

    def face_mask(self, cid: str, base):
        """Masque du visage : boîte détectée par le détailleur, sinon le haut de la silhouette."""
        if cid not in self.masks:
            faces = self.detailer.boxes(base, "face")
            self.masks[cid] = box_mask(base.size, faces[0], pad=0.35) if faces else head_mask(self.cut(base).getchannel("A"))
        return self.masks[cid]

    def cut(self, img):
        """Fond blanc → transparent : détourage rembg, puis nettoyage du masque (clean_alpha)."""
        if self.remover is None:
            from rembg import new_session, remove  # noqa: PLC0415
            session = new_session(os.environ.get("REMBG_MODEL", "isnet-anime"))
            self.remover = lambda im: remove(im, session=session)
        raw = self.remover(img).convert("RGBA")
        cleaned = clean_alpha(raw, self.style.get("alpha_cleanup"))
        if coverage(cleaned) < 0.6 * coverage(raw):  # le nettoyage a mangé le personnage (vêtements sombres…)
            print("  ! nettoyage du détourage trop agressif : détourage rembg brut conservé")
            return raw
        return cleaned

    def generate(self, prompt: str, negative: str, seed: int):
        """Génération complète d'une pose : base, hires fix (agrandissement anime ESRGAN + img2img), retouche
        visage/mains, taille finale."""
        w, h = self.style["size"]
        img = self.render(prompt, negative, (w, h), seed, steps=self.style["steps"])
        hires = self.style.get("hires", {})
        if hires.get("scale", 1.0) > 1.0:
            size = (int(w * hires["scale"]) // 8 * 8, int(h * hires["scale"]) // 8 * 8)
            img = self._img2img(self.upscaler.resize(img, size), prompt, negative, seed, hires.get("strength", 0.4),
                                hires.get("steps", 30))
        img = self.detail(img, prompt, negative, seed)
        return self.final_size(img)

    def final_size(self, img):
        from PIL import Image  # noqa: PLC0415
        fh = int(self.style.get("final_height", 0))
        if fh and img.height > fh:
            img = img.resize((round(img.width * fh / img.height), fh), Image.LANCZOS)
        return img

    def detail(self, img, prompt: str, negative: str, seed: int):
        """Repeint chaque visage et chaque main détectés (comme ADetailer)."""
        cfg = self.style.get("detailer", {})
        for kind, extra in (("face", cfg.get("face_prompt", "")), ("hand", cfg.get("hand_prompt", ""))):
            for k, box in enumerate(self.detailer.boxes(img, kind)):
                img = self._inpaint(img, box_mask(img.size, box), f"{prompt}, {extra}" if extra else prompt, negative,
                                    seed + 17 * (k + 1), float(cfg.get("strength", 0.35)))
        return img

    def _img2img(self, img, prompt: str, negative: str, seed: int, strength: float, steps: int):
        gen = self.torch.Generator(self.dev).manual_seed(seed)
        return self.img2img_pipe(image=img, strength=strength, num_inference_steps=effective_steps(steps, strength), guidance_scale=self.style["guidance"],
                                 generator=gen, **self.embeddings(prompt, negative)).images[0]

    def _inpaint(self, base, mask, prompt: str, negative: str, seed: int, strength: float):
        """Inpainting d'une zone, recadrée et générée en haute résolution (padding_mask_crop) puis recollée."""
        crop = int(self.style.get("detail_resolution", 1024))
        gen = self.torch.Generator(self.dev).manual_seed(seed)
        out = self.inpaint_pipe(image=base, mask_image=mask, width=crop, height=crop, strength=strength,
                                num_inference_steps=effective_steps(self.style["steps"], strength), guidance_scale=self.style["guidance"],
                                padding_mask_crop=32, generator=gen, **self.embeddings(prompt, negative)).images[0]
        return out.resize(base.size) if out.size != base.size else out

    def repaint_face(self, base, mask, prompt: str, negative: str, seed: int):
        return self._inpaint(base, mask, prompt, negative, seed, self.style["expression_strength"])


def effective_steps(steps: int, strength: float) -> int:
    """img2img et inpainting n'exécutent que steps × strength étapes : on en garantit au moins 2 (sinon diffusers
    reçoit zéro étape et échoue sur un tenseur vide)."""
    import math  # noqa: PLC0415
    return max(int(steps), math.ceil(2 / max(strength, 0.05)))


def make_scheduler(name: str, config):
    """Échantillonneur : « dpmpp_2m_karras » (net, peu d'étapes) ou « euler_a »."""
    from diffusers import DPMSolverMultistepScheduler, EulerAncestralDiscreteScheduler  # noqa: PLC0415
    if name == "dpmpp_2m_karras":
        return DPMSolverMultistepScheduler.from_config(config, use_karras_sigmas=True, algorithm_type="dpmsolver++")
    return EulerAncestralDiscreteScheduler.from_config(config)


def sprite_base(cid: str):
    """Pose neutre opaque d'un personnage : celle mémorisée, sinon le sprite neutre recomposé sur fond blanc."""
    from PIL import Image  # noqa: PLC0415
    saved = SPRITE_BASES / f"{cid}.png"
    if saved.exists():
        return Image.open(saved).convert("RGB")
    neutral = ROOT / "assets/portraits" / cid / "neutral.png"
    if not neutral.exists():
        return None
    rgba = Image.open(neutral).convert("RGBA")
    white = Image.new("RGBA", rgba.size, (255, 255, 255, 255))
    return Image.alpha_composite(white, rgba).convert("RGB")


def cmd_sprites(a, backend=None) -> int:
    style = load_style()
    jobs = sprite_jobs(a.force, a.only)[: a.limit or None]
    print(f"[sprites] {len(jobs)} sprite(s) à produire ({style['checkpoint']['name']} + "
          f"{', '.join(lo['name'] for lo in style['loras']) or 'sans LoRA'}, fond transparent)")
    if a.dry_run or not jobs:
        for it in jobs:
            print(f"  {it['id']} → {it['out']} :: {sprite_prompt(style, it['char'], it.get('expression', 'neutral'), it['kind'] == 'combat_sprite')[:200]}…")
        return len(jobs)
    backend = backend or SpriteBackend(style)
    tries = max(1, int(style.get("retries", 3)))
    failed: list[str] = []
    for i, it in enumerate(jobs, 1):
        cid, expr = it["char"], it.get("expression", "neutral")
        negative = sprite_negative(style, cid)
        dest = ROOT / it["out"]
        dest.parent.mkdir(parents=True, exist_ok=True)
        combat = it["kind"] == "combat_sprite"
        fresh = combat or expr == "neutral" or sprite_base(cid) is None
        if fresh and not combat and expr != "neutral":
            print(f"  ! {cid} : pas de pose neutre, {expr} générée seule (corps différent)")
        problem = ""
        for k in range(tries):  # nouvel essai (autre graine) si l'image est uniforme ou le détourage vide
            if fresh:
                prompt = sprite_prompt(style, cid, combat=True) if combat else sprite_prompt(style, cid, expr)
                img = backend.generate(prompt, negative, seed_of(it["id"] if combat else cid) + 7919 * k)
            else:
                base = sprite_base(cid)
                img = backend.repaint_face(base, backend.face_mask(cid, base), sprite_prompt(style, cid, expr), negative,
                                           seed_of(it["id"]) + 7919 * k)
            cut = backend.cut(sharpen(img, style.get("sharpen")))
            problem = sprite_problem(img, cut)
            if not problem:
                break
            print(f"  ! {it['id']} : {problem} — essai {k + 1}/{tries}", flush=True)
        if problem:
            failed.append(it["id"])
            continue
        if fresh:  # cadre serré ; les expressions repeignent la base déjà recadrée (même cadre pour tout le personnage)
            box = trim_box(cut.getchannel("A"), float(style.get("trim_margin", 0.03)))
            img, cut = img.crop(box), cut.crop(box)
            if expr == "neutral" and not combat:
                SPRITE_BASES.mkdir(parents=True, exist_ok=True)
                img.save(SPRITE_BASES / f"{cid}.png")
                if hasattr(backend, "masks"):
                    backend.masks.pop(cid, None)  # masque du visage recalculé sur la nouvelle base
        cut.save(dest, optimize=True)
        print(f"  [{i}/{len(jobs)}] {it['out']} ({cut.width}×{cut.height})", flush=True)
    if failed:
        print(f"  ! ÉCHEC ({len(failed)}) : {', '.join(failed)} — non enregistrés (le jeu garde le placeholder) : augmenter « retries » ou ajuster sprite_style.json")
    return len(jobs)


# --- Musique --------------------------------------------------------------------------------------------------------

def music_jobs(force: bool, only: list[str] | None) -> list[tuple[str, str, Path]]:
    jobs = []
    for tid, t in load_json(MUSIC)["tracks"].items():
        if only and tid not in only:
            continue
        dest = ROOT / t["file"].replace("res://", "")
        if (dest.exists() or dest.with_suffix(".mp3").exists()) and not force:
            continue
        jobs.append((tid, t.get("prompt") or t["desc"], dest))
    return jobs


def write_wav(path: Path, samples, rate: int) -> None:
    """WAV 16 bits mono, sans dépendance (le flottant 32 bits n'est pas lu par toutes les versions de ffmpeg/scipy)."""
    import wave  # noqa: PLC0415

    import numpy as np  # noqa: PLC0415
    data = np.clip(np.asarray(samples, dtype=np.float32).reshape(-1), -1.0, 1.0)
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(int(rate))
        w.writeframes((data * 32767).astype("<i2").tobytes())


class MusicgenBackend:
    def __init__(self, model=None, processor=None) -> None:
        import torch  # noqa: PLC0415
        self.torch = torch
        if model is None:
            # Classes explicites : AutoProcessor ne résout pas MusicGen dans toutes les versions de transformers (5.x)
            from transformers import MusicgenForConditionalGeneration, MusicgenProcessor  # noqa: PLC0415
            processor = MusicgenProcessor.from_pretrained(MUSIC_MODEL)
            model = MusicgenForConditionalGeneration.from_pretrained(MUSIC_MODEL)  # float32 : 6 Go, tient sur un T4
        self.proc, self.model = processor, model.to(device())
        self.rate = self.model.config.audio_encoder.sampling_rate
        self.tokens_per_second = self.model.config.audio_encoder.frame_rate

    def render(self, prompt: str, wav: Path, seconds: int) -> None:
        inputs = self.proc(text=[prompt], padding=True, return_tensors="pt")
        inputs = {k: v.to(self.model.device) for k, v in inputs.items()}
        with self.torch.no_grad():
            audio = self.model.generate(**inputs, do_sample=True, guidance_scale=3.0,
                                        max_new_tokens=int(seconds * self.tokens_per_second))
        write_wav(wav, audio[0, 0].float().cpu().numpy(), self.rate)


def cmd_music(a, backend=None) -> int:
    jobs = music_jobs(a.force, a.only)[: a.limit or None]
    print(f"[musique] {len(jobs)} piste(s) à produire avec {MUSIC_MODEL}")
    if a.dry_run or not jobs:
        for tid, prompt, dest in jobs:
            print(f"  {tid} → {dest.relative_to(ROOT)} :: {prompt}")
        return len(jobs)
    backend = backend or MusicgenBackend()
    with tempfile.TemporaryDirectory() as tmp:
        for i, (tid, prompt, dest) in enumerate(jobs, 1):
            wav = Path(tmp) / f"{tid}.wav"
            backend.render(prompt, wav, MUSIC_SECONDS)
            to_ogg(wav, dest, fade_out=1.5, duration=MUSIC_SECONDS)
            print(f"  [{i}/{len(jobs)}] {dest.relative_to(ROOT)}", flush=True)
    return len(jobs)


# --- Voix -----------------------------------------------------------------------------------------------------------

def voice_jobs(force: bool, only: list[str] | None) -> list[dict]:
    jobs = []
    with LINES.open(encoding="utf-8") as f:
        for r in csv.DictReader(f):
            if only and r["speaker"] not in only and r["line_id"] not in only:
                continue
            for lang in LANGS:
                text = r.get(f"text_{lang}", "").strip()
                base = ROOT / "assets/voice" / lang / r["speaker"] / r["line_id"].replace(":", "__")
                if not text or ((base.with_suffix(".ogg").exists() or base.with_suffix(".mp3").exists()) and not force):
                    continue
                jobs.append({"speaker": r["speaker"], "lang": lang, "text": text, "dest": base.with_suffix(".ogg")})
    return jobs


def xtts_voices() -> dict[str, str]:
    return {p.stem: load_json(p).get("voice", {}).get("xtts", "") for p in CHARS.glob("*.json")}


# Limites de caractères de XTTS-v2 par appel (tokenizer : ja 71, ko 95), avec une marge
XTTS_LIMITS = {"ja": 65, "ko": 85}
SENTENCE_END = re.compile(r"(?<=[。！？!?…\.])\s*")


def split_for_tts(text: str, lang: str) -> list[str]:
    """Découpe une réplique en morceaux sous la limite XTTS : d'abord aux fins de phrase, puis aux virgules,
    puis en dur. (Le découpage interne de coqui-tts suppose des phrases anglaises.)"""
    limit = XTTS_LIMITS.get(lang, 200)
    pieces: list[str] = []
    for sentence in (s.strip() for s in SENTENCE_END.split(text)):
        if not sentence:
            continue
        sub = [sentence] if len(sentence) <= limit else [p for p in re.split(r"(?<=[、，,])\s*", sentence) if p]
        for p in sub:
            pieces += [p[i:i + limit] for i in range(0, len(p), limit)]
    # regroupe les morceaux courts (moins d'appels, intonation plus naturelle)
    sep = " " if lang == "ko" else ""
    out: list[str] = []
    for p in pieces:
        if out and len(out[-1]) + len(sep) + len(p) <= limit:
            out[-1] += sep + p
        else:
            out.append(p)
    return out or [text]


class XttsBackend:
    def __init__(self, tts=None) -> None:
        if tts is None:
            if os.environ.get("COQUI_TOS_AGREED") != "1":
                sys.exit("Voix : accepter la licence Coqui (usage non commercial) → COQUI_TOS_AGREED=1")
            try:
                import torchaudio  # noqa: F401, PLC0415  (importé par XTTS sans être déclaré par coqui-tts)
            except ImportError:
                sys.exit("Voix : torchaudio manquant → pip install torchaudio (même version que torch)")
            from TTS.api import TTS  # noqa: PLC0415  (pip install "coqui-tts[ja,ko]")
            tts = TTS(XTTS_MODEL).to(device())
        self.tts = tts
        self.rate = int(tts.synthesizer.output_sample_rate)
        self.available = list(getattr(tts, "speakers", None) or [])
        self.wanted = xtts_voices()
        self.ref_failed: set[str] = set()
        chosen = {cid: self.speaker_for(cid).get("speaker", "échantillon") for cid in sorted(self.wanted)}
        print(f"  voix XTTS : {chosen}")

    def speaker_for(self, cid: str) -> dict:
        ref = ROOT / "assets/voice/refs" / f"{cid}.wav"  # échantillon personnel : clonage de voix
        if ref.exists() and cid not in self.ref_failed:
            return {"speaker_wav": str(ref)}
        name = self.wanted.get(cid, "")
        if name not in self.available and self.available:
            name = self.available[seed_of(cid) % len(self.available)]
        return {"speaker": name}

    def _say(self, text: str, lang: str, cid: str):
        try:
            return self.tts.tts(text=text, language=lang, split_sentences=False, **self.speaker_for(cid))
        except Exception as e:  # noqa: BLE001  — échantillon illisible (torchcodec absent…) : voix prédéfinie
            if "speaker_wav" not in self.speaker_for(cid):
                raise
            print(f"  ! échantillon de {cid} inutilisable ({e.__class__.__name__}) : voix XTTS prédéfinie")
            self.ref_failed.add(cid)
            return self.tts.tts(text=text, language=lang, split_sentences=False, **self.speaker_for(cid))

    def render(self, text: str, lang: str, cid: str, wav: Path) -> None:
        import numpy as np  # noqa: PLC0415
        gap = np.zeros(int(self.rate * 0.15), dtype=np.float32)
        parts = []
        for piece in split_for_tts(text, lang):
            parts += [np.asarray(self._say(piece, lang, cid), dtype=np.float32), gap]
        write_wav(wav, np.concatenate(parts[:-1]), self.rate)


def cmd_voices(a, backend=None) -> int:
    jobs = voice_jobs(a.force, a.only)[: a.limit or None]
    print(f"[voix] {len(jobs)} fichier(s) à produire (XTTS-v2, coréen + japonais)")
    if a.dry_run or not jobs:
        voices = xtts_voices()
        for j in jobs[:20]:
            print(f"  {j['dest'].relative_to(ROOT)} [{voices.get(j['speaker'])}] :: {j['text'][:60]}")
        return len(jobs)
    backend = backend or XttsBackend()
    with tempfile.TemporaryDirectory() as tmp:
        for i, j in enumerate(jobs, 1):
            wav = Path(tmp) / "line.wav"
            backend.render(j["text"], j["lang"], j["speaker"], wav)
            to_ogg(wav, j["dest"])
            if i % 25 == 0 or i == len(jobs):
                print(f"  [{i}/{len(jobs)}] {j['dest'].relative_to(ROOT)}", flush=True)
    return len(jobs)


# --- Plan -----------------------------------------------------------------------------------------------------------

def cmd_plan(a) -> int:
    manifest = load_json(MANIFEST)["assets"]
    nsfw_left = [i for i in manifest if i.get("nsfw") and not (ROOT / i["out"]).exists()]
    sprites, imgs = sprite_jobs(a.force, a.only), image_jobs(a.force, a.only)
    music, voices = music_jobs(a.force, a.only), voice_jobs(a.force, a.only)
    print(f"Reste à produire : {len(sprites)} sprites de personnages, {len(imgs)} images (gratuit), "
          f"{len(music)} pistes de musique, {len(voices)} voix "
          f"(ko + ja), {len(nsfw_left)} CG nsfw (RunPod, payant).")
    print(f"Modèles : sprites {load_style()['checkpoint']['name']} + LoRA · images {IMAGE_MODEL} · {MUSIC_MODEL} · "
          f"XTTS-v2 — appareil : {device()}")
    missing_prompt = [t for t, p, _ in music if p == load_json(MUSIC)["tracks"][t]["desc"]]
    if missing_prompt:
        print(f"  ! pistes sans « prompt » anglais (la description française sera utilisée) : {missing_prompt}")
    return len(sprites) + len(imgs) + len(music) + len(voices)


def main(argv: list[str] | None = None) -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("stage", choices=["plan", "sprites", "images", "music", "voices", "all"])
    p.add_argument("--force", action="store_true")
    p.add_argument("--dry-run", action="store_true")
    p.add_argument("--only", nargs="*")
    p.add_argument("--limit", type=int, default=0)
    a = p.parse_args(argv)
    if a.stage != "plan" and not a.dry_run and not shutil.which("ffmpeg") and a.stage not in ("images", "sprites"):
        sys.exit("ffmpeg introuvable (Colab l'a déjà ; Windows : winget install ffmpeg)")
    if a.stage == "plan":
        cmd_plan(a)
    for stage, fn in (("sprites", cmd_sprites), ("images", cmd_images), ("music", cmd_music), ("voices", cmd_voices)):
        if a.stage in (stage, "all"):
            fn(a)


if __name__ == "__main__":
    main()
