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
    style.update(size=[64, 96], steps=2, loras=[{"name": "test_style", "path": str(lora), "weight": 0.8, "trigger": "test"}])
    pipe = tiny_sdxl(tmp)
    try:
        from rembg import new_session, remove
        session = new_session("isnet-anime")
        remover = lambda im: remove(im, session=session)  # noqa: E731
        real_rembg = True
    except Exception as e:  # noqa: BLE001  (modèle rembg non téléchargeable : faux détourage)
        print(f"  (rembg réel indisponible : {e.__class__.__name__}, faux détourage)")
        remover = lambda im: im.convert("RGBA")  # noqa: E731
        real_rembg = False
    backend = fg.SpriteBackend(style, pipe=pipe, remover=remover)
    check(set(pipe.get_active_adapters()) == {"test_style"}, f"LoRA chargé et actif ({pipe.get_active_adapters()})")
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
    try:
        n = fg.cmd_sprites(argparse_ns(only=["seo_yeon"], limit=4), backend=backend)
        outs = [fg.ROOT / "assets/sprites/seo_yeon.png"] + [fg.ROOT / f"assets/portraits/seo_yeon/{e}.png" for e in ("neutral", "joy", "anger")]
        check(n == 4 and all(p.exists() for p in outs), "sprites : combat, neutre, joie, colère écrits aux chemins du manifeste")
        check(all(Image.open(p).mode == "RGBA" for p in outs), "sprites : PNG avec canal alpha")
        check((fg.SPRITE_BASES / "seo_yeon.png").exists(), "sprites : pose neutre mémorisée pour l'inpainting")
        base = fg.sprite_base("seo_yeon")
        mask = backend.face_mask("seo_yeon", base)
        face = backend.repaint_face(base, mask, fg.sprite_prompt(style, "seo_yeon", "joy"), style["negative"], 1)
        box = mask.point(lambda v: 255 if v else 0).getbbox()
        outside = [(x, y) for x in range(0, 64, 7) for y in range(0, 96, 7)
                   if not (box and box[0] - 34 <= x <= box[2] + 34 and box[1] - 34 <= y <= box[3] + 34)]
        same = sum(face.getpixel(p) == base.getpixel(p) for p in outside)
        check(face.size == base.size and (not outside or same == len(outside)),
              f"inpainting : corps identique hors du visage ({same}/{len(outside)} pixels témoins)")
    finally:
        fg.ROOT, fg.SPRITE_BASES = real_root, real_bases


def argparse_ns(**kw):
    import argparse
    base = {"force": False, "dry_run": False, "only": None, "limit": 0}
    base.update(kw)
    return argparse.Namespace(**base)


def main() -> None:
    print(f"Moteurs réels : torch {torch.__version__}, diffusers {diffusers.__version__}, transformers {transformers.__version__}")
    with tempfile.TemporaryDirectory() as tmp:
        for test in (test_sdxl, test_weights, test_sprites, test_musicgen):
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
