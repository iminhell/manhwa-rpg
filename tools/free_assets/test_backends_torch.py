#!/usr/bin/env python3
"""Exécute les VRAIS moteurs de free_gen.py (diffusers SDXL, transformers MusicGen) sur de mini-modèles aléatoires
construits localement : aucun téléchargement, quelques secondes sur CPU. Vérifie l'encodage des prompts longs, les
appels aux pipelines et l'écriture des fichiers avec les versions installées des bibliothèques.

  pip install torch diffusers transformers accelerate pillow
  python3 tools/free_assets/test_backends_torch.py      (ignoré proprement si torch/diffusers/transformers manquent)
"""
from __future__ import annotations

import json
import os
import sys
import tempfile
import wave
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

try:
    import diffusers
    import torch
    import transformers
except ImportError as e:
    print(f"Moteurs réels : ignoré ({e.name} non installé)")
    sys.exit(0)

import free_gen as fg  # noqa: E402

failures: list[str] = []


def check(cond: bool, label: str) -> None:
    print(("  ok   " if cond else "  ÉCHEC ") + label)
    if not cond:
        failures.append(label)


def tiny_clip_tokenizer(tmp: Path):
    """Tokenizer CLIP caractère par caractère (vocabulaire et fusions BPE écrits à la main)."""
    chars = "abcdefghijklmnopqrstuvwxyz0123456789,.-'!?:;"
    vocab = {"<|startoftext|>": 0, "<|endoftext|>": 1}
    for c in chars:
        vocab[c] = len(vocab)
        vocab[c + "</w>"] = len(vocab)
    (tmp / "vocab.json").write_text(json.dumps(vocab))
    (tmp / "merges.txt").write_text("#version: 0.2\n")
    return transformers.CLIPTokenizer(vocab_file=str(tmp / "vocab.json"), merges_file=str(tmp / "merges.txt"),
                                      model_max_length=77)


def tiny_sdxl(tmp: Path):
    from diffusers import (AutoencoderKL, EulerAncestralDiscreteScheduler, StableDiffusionXLPipeline,
                           UNet2DConditionModel)
    from transformers import CLIPTextConfig, CLIPTextModel, CLIPTextModelWithProjection
    torch.manual_seed(0)
    tok = tiny_clip_tokenizer(tmp)
    cfg = CLIPTextConfig(bos_token_id=tok.bos_token_id, eos_token_id=tok.eos_token_id, pad_token_id=tok.pad_token_id,
                         hidden_size=32, intermediate_size=37, num_attention_heads=4, num_hidden_layers=3,
                         vocab_size=200, projection_dim=32, max_position_embeddings=77)
    unet = UNet2DConditionModel(block_out_channels=(32, 64), layers_per_block=1, sample_size=32, in_channels=4,
                                out_channels=4, down_block_types=("DownBlock2D", "CrossAttnDownBlock2D"),
                                up_block_types=("CrossAttnUpBlock2D", "UpBlock2D"), attention_head_dim=(2, 4),
                                use_linear_projection=True, addition_embed_type="text_time", addition_time_embed_dim=8,
                                transformer_layers_per_block=(1, 1), projection_class_embeddings_input_dim=80,
                                cross_attention_dim=64, norm_num_groups=1)
    vae = AutoencoderKL(block_out_channels=[32, 64], in_channels=3, out_channels=3,
                        down_block_types=["DownEncoderBlock2D"] * 2, up_block_types=["UpDecoderBlock2D"] * 2,
                        latent_channels=4, sample_size=64, norm_num_groups=1)
    sched = EulerAncestralDiscreteScheduler(beta_start=0.00085, beta_end=0.012, beta_schedule="scaled_linear",
                                            steps_offset=1, timestep_spacing="leading")
    return StableDiffusionXLPipeline(vae=vae, text_encoder=CLIPTextModel(cfg), text_encoder_2=CLIPTextModelWithProjection(cfg),
                                     tokenizer=tok, tokenizer_2=tok, unet=unet, scheduler=sched)


def test_sdxl(tmp: Path) -> None:
    pipe = tiny_sdxl(tmp)
    backend = fg.SdxlBackend(pipe=pipe)
    ctx = fg.art.Ctx(dry_run=True)
    item = next(a for a in fg.load_json(fg.MANIFEST)["assets"] if a["kind"] == "cg" and not a.get("nsfw"))
    prompt = fg.sdxl_prompt(ctx, item)
    negative = f"{ctx.prompts['style']['negative']}, {fg.SFW_NEGATIVE}"
    n = len(fg.token_chunks(pipe.tokenizer, prompt))
    check(n >= 3, f"prompt réel de {item['id']} : {n} tranches de 75 jetons (au-delà de la limite de 77)")
    emb = backend.embeddings(prompt, negative)
    check(emb["prompt_embeds"].shape == (1, 77 * n, 64), f"embeddings du prompt {tuple(emb['prompt_embeds'].shape)}")
    check(emb["negative_prompt_embeds"].shape == emb["prompt_embeds"].shape, "négatif complété à la même longueur")
    check(emb["pooled_prompt_embeds"].shape == (1, 32), "embedding « pooled » du second encodeur")
    img = backend.render(prompt, negative, (64, 64), fg.seed_of(item["id"]), steps=2)
    check(img.size == (64, 64), f"image produite par StableDiffusionXLPipeline ({img.size})")
    out = tmp / "cg.png"
    img.save(out, optimize=True)
    check(out.read_bytes()[:4] == b"\x89PNG", "PNG écrit")


def test_musicgen(tmp: Path) -> None:
    from transformers import (EncodecConfig, MusicgenConfig, MusicgenDecoderConfig, MusicgenForConditionalGeneration,
                              T5Config)
    torch.manual_seed(0)
    vocab, books = 32, 2
    text = T5Config(vocab_size=50, d_model=16, d_ff=32, d_kv=8, num_layers=1, num_heads=2, decoder_start_token_id=0)
    audio = EncodecConfig(hidden_size=vocab, compress=1, num_filters=2, codebook_size=vocab, codebook_dim=vocab,
                          num_lstm_layers=1, upsampling_ratios=[2, 2], target_bandwidths=[24.0], sampling_rate=800)
    dec = MusicgenDecoderConfig(vocab_size=vocab, hidden_size=16, num_hidden_layers=1, num_attention_heads=2, ffn_dim=32,
                                num_codebooks=books, pad_token_id=vocab, bos_token_id=vocab, max_position_embeddings=512)
    cfg = MusicgenConfig(text_encoder=text.to_dict(), audio_encoder=audio.to_dict(), decoder=dec.to_dict())
    model = MusicgenForConditionalGeneration(cfg)
    model.generation_config.pad_token_id = vocab
    model.generation_config.decoder_start_token_id = vocab

    class Proc:  # le vrai MusicgenProcessor (tokenizer T5) se télécharge ; ici, des identifiants arbitraires
        def __call__(self, text, padding, return_tensors):
            return {"input_ids": torch.tensor([[3, 4, 5, 1]]), "attention_mask": torch.ones(1, 4, dtype=torch.long)}

    backend = fg.MusicgenBackend(model=model, processor=Proc())
    wav = tmp / "m.wav"
    backend.render("dark synthwave", wav, seconds=1)
    with wave.open(str(wav)) as w:
        frames, rate = w.getnframes(), w.getframerate()
    check(rate == backend.rate and frames > 0, f"MusicGen.generate → WAV ({frames} échantillons à {rate} Hz)")
    if fg.shutil.which("ffmpeg"):
        ogg = tmp / "m.ogg"
        fg.to_ogg(wav, ogg, fade_out=0.2, duration=frames / rate)
        check(ogg.read_bytes()[:4] == b"OggS", "WAV → Ogg Vorbis (ffmpeg)")


def make_lora(tmp: Path) -> Path:
    """Vrai fichier LoRA (format diffusers, créé avec peft sur le mini-UNet), chargé ensuite par load_lora_weights."""
    from diffusers import StableDiffusionXLPipeline
    from diffusers.utils import convert_state_dict_to_diffusers
    from peft import LoraConfig
    from peft.utils import get_peft_model_state_dict
    pipe = tiny_sdxl(tmp)
    pipe.unet.add_adapter(LoraConfig(r=4, lora_alpha=4, init_lora_weights="gaussian",
                                     target_modules=["to_q", "to_k", "to_v", "to_out.0"]))
    layers = convert_state_dict_to_diffusers(get_peft_model_state_dict(pipe.unet))
    StableDiffusionXLPipeline.save_lora_weights(str(tmp / "lora"), unet_lora_layers=layers)
    return tmp / "lora" / "pytorch_lora_weights.safetensors"


def test_weights(tmp: Path) -> None:
    pipe = tiny_sdxl(tmp)
    plain = fg.encode_long_prompt(pipe, "sweaty skin, full body, standing", 1, torch)[0]
    weighted = fg.encode_long_prompt(pipe, "sweaty skin, (full body:1.4), standing", 1, torch)[0]
    check(plain.shape == weighted.shape and not torch.allclose(plain, weighted), "pondération (mot:1.4) appliquée aux embeddings")
    check(torch.allclose(plain.mean(), weighted.mean(), atol=1e-4), "pondération : moyenne de la tranche conservée")


def test_sprites(tmp: Path) -> None:
    from PIL import Image
    lora = make_lora(tmp)
    style = fg.load_style()
    style.update(size=[64, 96], steps=2, loras=[{"name": "test_style", "path": str(lora), "weight": 0.8, "trigger": "test"}],
                 hires={"scale": 1.5, "strength": 0.4, "steps": 2, "upscaler": {"name": "tiny", "path": str(tiny_esrgan(tmp)), "tile": 32}},
                 final_height=120, detail_resolution=64, detail_steps=2, controlnet={})  # sans ControlNet : chemin de repli
    pipe = tiny_sdxl(tmp)
    detector = {"face": FakeYolo([(30, 8, 60, 40)]), "hand": FakeYolo([(10, 70, 26, 90), (70, 72, 90, 92)])}
    try:
        from rembg import new_session, remove
        session = new_session("isnet-anime")
        remover = lambda im: remove(im, session=session)  # noqa: E731
        real_rembg = True
    except Exception as e:  # noqa: BLE001  (modèle rembg non téléchargeable : faux détourage)
        print(f"  (rembg réel indisponible : {e.__class__.__name__}, faux détourage)")
        remover = lambda im: im.convert("RGBA")  # noqa: E731
        real_rembg = False
    backend = fg.SpriteBackend(style, pipe=pipe, remover=remover, detector_models=detector)
    check(set(pipe.get_active_adapters()) == {"test_style"}, f"LoRA chargé et actif ({pipe.get_active_adapters()})")
    check(type(pipe.scheduler).__name__ == "DPMSolverMultistepScheduler" and pipe.scheduler.config.use_karras_sigmas,
          "échantillonneur DPM++ 2M Karras")
    cfgs, redraws = [], []
    real_render, real_i2i = backend.render, backend._img2img
    backend.render = lambda *a, **k: (cfgs.append(k.get("guidance")), real_render(*a, **k))[1]
    backend._img2img = lambda *a, **k: (redraws.append(1), real_i2i(*a, **k))[1]
    pose = backend.generate(fg.sprite_prompt(style, "elias"), style["negative"], 3)
    backend.render, backend._img2img = real_render, real_i2i
    check(cfgs == [style["guidance"]], f"génération de base au CFG du style ({cfgs})")
    check(not redraws, "mode « upscale » : aucune passe ne redessine le corps (agrandissement pur)")
    hd = Image.new("RGB", (80, 120), "white")
    check(backend.refine(hd, "x", "y", 1, hd=True) is hd, "affinage en mode « upscale » : le sprite existant n'est pas redessiné")
    check(pose.size == (round(96 * 120 / 144), 120), f"hires fix ×1,5 puis taille finale ({pose.size})")
    check(detector["face"].calls >= 1 and detector["hand"].calls == 0, "détailleur : visage retouché, mains laissées à la seconde passe")
    check(backend.upscaler.model is not None and backend.upscaler.model.scale == 4,
          "hires fix : agrandissement par le réseau ESRGAN (spandrel), pas par Lanczos")
    ref = os.environ.get("SPRITE_REF_IMAGE", "")  # un vrai sprite d'anime sur fond blanc (non versionné)
    if real_rembg and ref and Path(ref).exists():
        img = Image.open(ref).convert("RGB")
        a = backend.cut(img).getchannel("A")
        w, h = a.size
        corners = [a.getpixel(p) for p in ((3, 3), (w - 4, 3), (3, h - 4), (w - 4, h - 4))]
        alpha_box = a.point(lambda v: 255 if v > 128 else 0).getbbox()
        opaque = sum(1 for v in a.getdata() if v > 128) / (w * h)
        check(max(corners) < 10, f"rembg isnet-anime : fond blanc → transparent (coins {corners})")
        check(0.15 < opaque < 0.8 and alpha_box and (alpha_box[3] - alpha_box[1]) > 0.85 * h,
              f"rembg isnet-anime : personnage conservé en pied ({opaque:.0%} opaque, boîte {alpha_box})")
        a.save(tmp / "ref_alpha.png")
    elif real_rembg:
        print("  (SPRITE_REF_IMAGE non fourni : détourage réel vérifié seulement par l'étape complète)")
    # étape complète sur un personnage : sprite de combat, pose neutre, puis expressions par inpainting du visage
    real_root, real_bases = fg.ROOT, fg.SPRITE_BASES
    fg.ROOT, fg.SPRITE_BASES = tmp / "proj", tmp / "proj/art_work/sprite_bases"
    real_remover = backend.remover

    def silhouette(im):  # détourage factice prévisible : personnage au centre (le modèle minuscule ne dessine rien)
        a = Image.new("L", im.size, 0)
        w, h = im.size
        a.paste(255, (int(w * 0.3), int(h * 0.05), int(w * 0.7), int(h * 0.97)))
        out = im.convert("RGBA")
        out.putalpha(a)
        return out
    backend.remover = silhouette
    try:
        n = fg.cmd_sprites(argparse_ns(only=["seo_yeon"], limit=4), backend=backend)
        outs = [fg.ROOT / "assets/sprites/seo_yeon.png"] + [fg.ROOT / f"assets/portraits/seo_yeon/{e}.png" for e in ("neutral", "joy", "anger")]
        check(n == 4 and all(p.exists() for p in outs), "sprites : combat, neutre, joie, colère écrits aux chemins du manifeste")
        check(all(Image.open(p).mode == "RGBA" for p in outs), "sprites : PNG avec canal alpha")
        check((fg.SPRITE_BASES / "seo_yeon.png").exists(), "sprites : pose neutre mémorisée pour l'inpainting")
        sizes = {Image.open(p).size for p in outs[1:]}
        neutral = Image.open(outs[1])
        check(len(sizes) == 1 and neutral.width < 80 and Image.open(fg.SPRITE_BASES / "seo_yeon.png").size == neutral.size,
              f"sprites : recadrés sur la silhouette, même cadre pour toutes les expressions ({sizes})")
        # garde : détourage vide (personnage effacé) → nouveaux essais, puis rien d'enregistré (placeholder en jeu)
        backend.remover = lambda im: Image.new("RGBA", im.size, (0, 0, 0, 0))
        n = fg.cmd_sprites(argparse_ns(only=["portrait_elias_neutral"], force=True), backend=backend)
        check(n == 1 and not (fg.ROOT / "assets/portraits/elias/neutral.png").exists(),
              "sprites : détourage vide refusé après plusieurs graines (aucune image transparente enregistrée)")
        # plusieurs personnages (affiche, jumelle, planche) : nouvelles graines, puis le seul personnage principal
        backend.remover = silhouette
        twins = FakeYolo([(5, 5, 30, 35), (45, 5, 70, 35)])
        real_face = detector["face"]
        detector["face"] = backend.detailer.models["face"] = twins
        prompts = []
        real_inpaint = backend._inpaint
        backend._inpaint = lambda base, mask, text, *a, **k: (prompts.append(text), real_inpaint(base, mask, text, *a, **k))[1]
        try:
            n = fg.cmd_sprites(argparse_ns(only=["portrait_elias_neutral"], force=True), backend=backend)
        finally:
            backend._inpaint = real_inpaint
            detector["face"] = backend.detailer.models["face"] = real_face
        check(n == 1 and (fg.ROOT / "assets/portraits/elias/neutral.png").exists() and twins.calls >= int(style.get("retries", 3)),
              f"sprites : plusieurs visages → nouvelles graines, puis personnage principal seul ({twins.calls} détections)")
        check(prompts and not any("full body" in p for p in prompts) and any("face focus" in p for p in prompts),
              "retouche : visages et mains repeints sans prompt de corps entier")
        # inpainting du visage sur une grande base : le bas du corps doit rester identique au pixel près
        import numpy as np
        rng = np.random.default_rng(0)
        base = Image.fromarray(rng.integers(0, 255, (384, 256, 3), dtype=np.uint8))
        mask = fg.box_mask(base.size, (104, 24, 152, 72), pad=0.2)
        face = backend.repaint_face(base, mask, fg.sprite_prompt(style, "seo_yeon", "joy"), style["negative"], 1)
        a, b = np.asarray(face), np.asarray(base)
        changed_top = (a[:100] != b[:100]).any()
        same_bottom = (a[200:] == b[200:]).all()
        check(face.size == base.size and changed_top and same_bottom,
              f"inpainting : visage repeint, bas du corps identique au pixel près (visage modifié {changed_top}, corps intact {same_bottom})")
    finally:
        fg.ROOT, fg.SPRITE_BASES = real_root, real_bases
        backend.remover = real_remover


def tiny_esrgan(tmp: Path) -> Path:
    """Petit réseau ESRGAN (même architecture que RealESRGAN_x4plus_anime_6B), poids aléatoires, sauvé en .pth."""
    from spandrel.architectures.ESRGAN.__arch.RRDB import RRDBNet
    torch.manual_seed(0)
    path = tmp / "tiny_esrgan.pth"
    torch.save(RRDBNet(num_filters=8, num_blocks=1, scale=4).state_dict(), path)
    return path


def test_upscaler(tmp: Path) -> None:
    from PIL import Image
    up = fg.Upscaler({"name": "tiny", "path": str(tiny_esrgan(tmp)), "tile": 16})
    img = Image.new("RGB", (40, 24), (200, 120, 90))
    out = up.resize(img, (100, 60))
    check(up.model is not None and not up.failed and out.size == (100, 60) and out.mode == "RGB",
          f"agrandisseur : modèle ESRGAN chargé par spandrel, image à la taille demandée ({out.size})")
    lanczos = fg.Upscaler({})
    check(lanczos.failed and lanczos.resize(img, (100, 60)).size == (100, 60), "agrandisseur : repli Lanczos sans modèle")
    # tuiles : même résultat que l'image entière pour un modèle local (voisinage 3×3)
    conv = torch.nn.Conv2d(3, 3, 3, padding=1, padding_mode="replicate")

    def model(x):
        return torch.nn.functional.interpolate(conv(x), scale_factor=2, mode="nearest")
    x = torch.rand(1, 3, 37, 53)
    with torch.no_grad():
        whole, tiled = model(x), fg.upscale_tiled(model, x, 2, tile=16, pad=2)
    check(torch.allclose(whole, tiled, atol=1e-6), "agrandisseur : traitement par tuiles sans couture")


def test_controlnet(tmp: Path) -> None:
    """Seconde passe guidée par ControlNet Tile (vrai StableDiffusionXLControlNetImg2ImgPipeline / InpaintPipeline sur un
    ControlNet minuscule construit depuis le UNet de test), repli si la mémoire manque, affinage sans régénérer la pose."""
    from diffusers import ControlNetModel
    from PIL import Image
    style = fg.load_style()
    style.update(size=[64, 96], steps=2, loras=[], hires={"mode": "controlnet", "scale": 1.5, "strength": 0.4, "steps": 2}, final_height=120,
                 detail_resolution=64, detail_steps=2)
    style["controlnet"] = {**style["controlnet"], "repo": "test"}
    pipe = tiny_sdxl(tmp)
    torch.manual_seed(1)
    cn = ControlNetModel.from_unet(pipe.unet, conditioning_embedding_out_channels=(8, 16))
    detector = {"face": FakeYolo([(30, 8, 60, 40)]), "hand": FakeYolo([(10, 70, 26, 90)])}
    backend = fg.SpriteBackend(style, pipe=pipe, remover=lambda im: im.convert("RGBA"), detector_models=detector, controlnet=cn)
    calls = {"cn": 0, "cn_inpaint": 0, "plain": 0}
    real_cn, real_plain, real_inp = backend._cn_img2img, backend._img2img, backend.cn_inpaint.__call__

    def spy_cn(*a, **k):
        calls["cn"] += 1
        return real_cn(*a, **k)

    def spy_plain(*a, **k):
        calls["plain"] += 1
        return real_plain(*a, **k)
    backend._cn_img2img, backend._img2img = spy_cn, spy_plain
    inpaint = backend.cn_inpaint
    backend.cn_inpaint = lambda **k: (calls.__setitem__("cn_inpaint", calls["cn_inpaint"] + 1), inpaint(**k))[1]
    pose = backend.generate(fg.sprite_prompt(style, "hae_in"), style["negative"], 5, fg.detail_prompts(style, "hae_in"))
    check(pose.size == (80, 120) and calls == {"cn": 1, "cn_inpaint": 1, "plain": 0} and detector["hand"].calls == 0,
          f"ControlNet Tile : seconde passe et retouche du visage guidées, mains non repeintes ({calls})")
    check(backend.last_base is not None and backend.last_base.size == (64, 96), "pose de base mémorisée (basse résolution)")

    def oom(*a, **k):
        raise torch.cuda.OutOfMemoryError("test")
    backend._cn_img2img = oom
    calls["plain"] = 0
    out = backend.refine(backend.last_base, "x", style["negative"], 1)
    check(out.size == (96, 144) and calls["plain"] == 1, "mémoire GPU insuffisante : repli sur l'img2img simple")
    backend._cn_img2img = spy_cn
    # affinage : la pose mémorisée (ou le sprite existant) est repassée en HD, sans nouvelle génération
    real_root, real_bases = fg.ROOT, fg.SPRITE_BASES
    fg.ROOT, fg.SPRITE_BASES = tmp / "proj_cn", tmp / "proj_cn/art_work/sprite_bases"

    def silhouette(im):
        a = Image.new("L", im.size, 0)
        a.paste(255, (int(im.width * 0.3), int(im.height * 0.05), int(im.width * 0.7), int(im.height * 0.97)))
        o = im.convert("RGBA")
        o.putalpha(a)
        return o
    backend.remover = silhouette
    renders = []
    real_render = backend.render
    backend.render = lambda *a, **k: (renders.append(1), real_render(*a, **k))[1]
    try:
        fg.cmd_sprites(argparse_ns(only=["portrait_nadia_neutral"]), backend=backend)
        low = fg.lowres_path("portrait_nadia_neutral")
        check(low.exists() and len(renders) == 1, "génération : pose de base enregistrée pour un affinage ultérieur")
        renders.clear()
        n = fg.cmd_sprites(argparse_ns(only=["portrait_nadia_neutral"], refine=True), backend=backend)
        check(n == 1 and not renders and (fg.ROOT / "assets/portraits/nadia/neutral.png").exists(),
              "affinage depuis la pose mémorisée : aucune nouvelle génération")
        low.unlink()
        calls["cn"] = 0
        n = fg.cmd_sprites(argparse_ns(only=["portrait_nadia_neutral"], refine=True), backend=backend)
        check(n == 1 and not renders and calls["cn"] == 1, "affinage d'un sprite existant (déjà en HD) : aucune nouvelle génération")
    finally:
        fg.ROOT, fg.SPRITE_BASES = real_root, real_bases


class FakeYolo:
    """Même interface que ultralytics.YOLO.predict (résultat → boxes.xyxy.cpu().numpy().tolist())."""

    def __init__(self, boxes):
        self.box_list, self.calls = boxes, 0

    def predict(self, img, conf, verbose):
        self.calls += 1
        boxes = self.box_list

        class R:
            class boxes:  # noqa: N801
                xyxy = torch.tensor(boxes, dtype=torch.float32)
        return [R()]


def test_yolo_api(tmp: Path) -> None:
    """Le vrai ultralytics : un modèle YOLOv8 non entraîné (construit depuis sa configuration, sans téléchargement)
    passe par Detailer.boxes sans erreur, ce qui vérifie l'appel predict() et la lecture des boîtes."""
    try:
        from ultralytics import YOLO
    except ImportError:
        print("  (ultralytics non installé : API YOLO non vérifiée)")
        return
    from PIL import Image
    d = fg.Detailer({"face_model": "x", "confidence": 0.01}, models={"face": YOLO("yolov8n.yaml")})
    boxes = d.boxes(Image.new("RGB", (320, 480), "white"), "face")
    check(isinstance(boxes, list) and all(len(b) == 4 for b in boxes), f"ultralytics YOLO.predict → boîtes lues ({len(boxes)})")
    check(fg.Detailer({"face_model": "x"}, models={}).boxes(Image.new("RGB", (64, 64)), "face") == [], "détailleur sans modèle : aucune boîte")


def argparse_ns(**kw):
    import argparse
    base = {"force": False, "dry_run": False, "only": None, "limit": 0, "refine": False}
    base.update(kw)
    return argparse.Namespace(**base)


def main() -> None:
    print(f"Moteurs réels : torch {torch.__version__}, diffusers {diffusers.__version__}, transformers {transformers.__version__}")
    with tempfile.TemporaryDirectory() as tmp:
        for test in (test_sdxl, test_weights, test_upscaler, test_sprites, test_controlnet, test_yolo_api, test_musicgen):
            try:
                test(Path(tmp))
            except Exception as e:  # noqa: BLE001
                import traceback
                traceback.print_exc()
                check(False, f"{test.__name__} : {e.__class__.__name__}: {e}")
    print(f"Moteurs réels : {'OK' if not failures else str(len(failures)) + ' échec(s)'}")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
