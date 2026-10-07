#!/usr/bin/env python3
"""
Génération GRATUITE des assets du jeu sur GPU (Google Colab T4 gratuit, ou PC local avec carte NVIDIA).

  python tools/free_assets/free_gen.py plan                 ce qui reste à produire (aucun téléchargement)
  python tools/free_assets/free_gen.py images [--limit N]   portraits, sprites, décors, CG  → assets/…/*.png
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
    """Entrées du manifeste à produire ici (tout sauf « nsfw », réservé à RunPod)."""
    jobs = []
    for item in load_json(MANIFEST)["assets"]:
        if item.get("nsfw") or (only and item["id"] not in only):
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


def token_chunks(tokenizer, text: str) -> list[list[int]]:
    """Jetons du texte (sans BOS/EOS) découpés en tranches de 75 : la fenêtre de 77 de CLIP, moins BOS et EOS."""
    ids = tokenizer(text, add_special_tokens=False, truncation=False)["input_ids"]
    size = tokenizer.model_max_length - 2
    return [ids[i:i + size] for i in range(0, len(ids), size)] or [[]]


def encode_long_prompt(pipe, text: str, n_chunks: int, torch):
    """Encodage SDXL sans limite de 77 jetons (remplace compel, dont l'API a changé) : chaque tranche passe dans les deux
    encodeurs comme dans StableDiffusionXLPipeline.encode_prompt (avant-dernière couche cachée, embedding « pooled » de
    la première tranche du second encodeur), puis les tranches sont mises bout à bout. n_chunks complète avec des tranches
    vides, pour que le prompt et le négatif aient la même longueur."""
    per_encoder, pooled = [], None
    for tok, enc in ((pipe.tokenizer, pipe.text_encoder), (pipe.tokenizer_2, pipe.text_encoder_2)):
        chunks = token_chunks(tok, text)
        chunks += [[]] * (n_chunks - len(chunks))
        pad = tok.pad_token_id if tok.pad_token_id is not None else tok.eos_token_id
        dev = next(enc.parameters()).device
        states = []
        for k, chunk in enumerate(chunks[:n_chunks]):
            seq = [tok.bos_token_id] + chunk + [tok.eos_token_id]
            seq += [pad] * (tok.model_max_length - len(seq))
            out = enc(torch.tensor([seq], device=dev), output_hidden_states=True)
            states.append(out.hidden_states[-2])
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
    imgs, music, voices = image_jobs(a.force, a.only), music_jobs(a.force, a.only), voice_jobs(a.force, a.only)
    print(f"Reste à produire : {len(imgs)} images (gratuit), {len(music)} pistes de musique, {len(voices)} voix "
          f"(ko + ja), {len(nsfw_left)} CG nsfw (RunPod, payant).")
    print(f"Modèles : {IMAGE_MODEL} · {MUSIC_MODEL} · XTTS-v2 — appareil : {device()}")
    missing_prompt = [t for t, p, _ in music if p == load_json(MUSIC)["tracks"][t]["desc"]]
    if missing_prompt:
        print(f"  ! pistes sans « prompt » anglais (la description française sera utilisée) : {missing_prompt}")
    return len(imgs) + len(music) + len(voices)


def main(argv: list[str] | None = None) -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("stage", choices=["plan", "images", "music", "voices", "all"])
    p.add_argument("--force", action="store_true")
    p.add_argument("--dry-run", action="store_true")
    p.add_argument("--only", nargs="*")
    p.add_argument("--limit", type=int, default=0)
    a = p.parse_args(argv)
    if a.stage != "plan" and not a.dry_run and not shutil.which("ffmpeg") and a.stage != "images":
        sys.exit("ffmpeg introuvable (Colab l'a déjà ; Windows : winget install ffmpeg)")
    if a.stage == "plan":
        cmd_plan(a)
    for stage, fn in (("images", cmd_images), ("music", cmd_music), ("voices", cmd_voices)):
        if a.stage in (stage, "all"):
            fn(a)


if __name__ == "__main__":
    main()
