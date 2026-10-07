#!/usr/bin/env python3
"""Exécute les VRAIS moteurs de free_gen.py (diffusers SDXL, transformers MusicGen) sur de mini-modèles aléatoires
construits localement : aucun téléchargement, quelques secondes sur CPU. Vérifie l'encodage des prompts longs, les
appels aux pipelines et l'écriture des fichiers avec les versions installées des bibliothèques.

  pip install torch diffusers transformers accelerate pillow
  python3 tools/free_assets/test_backends_torch.py      (ignoré proprement si torch/diffusers/transformers manquent)
"""
from __future__ import annotations

import json
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


def main() -> None:
    print(f"Moteurs réels : torch {torch.__version__}, diffusers {diffusers.__version__}, transformers {transformers.__version__}")
    with tempfile.TemporaryDirectory() as tmp:
        for test in (test_sdxl, test_musicgen):
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
