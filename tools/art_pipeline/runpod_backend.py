#!/usr/bin/env python3
"""
Backend de repli pour les visuels 18+ : ComfyUI serverless sur RunPod.

Pourquoi : les services hébergés (fal.ai, Midjourney) peuvent refuser le contenu explicite. Un endpoint
serverless RunPod exécute TES modèles et TES LoRA dans ComfyUI, sans filtre, facturé à la seconde.

Mise en place (une seule fois) :
  1. RunPod → Serverless → New Endpoint → modèle « worker-comfyui » (image officielle runpod/worker-comfyui).
  2. Attacher un Network Volume contenant :
       ComfyUI/models/
         unet/  ou checkpoints/   le modèle de base (Flux dev ou dérivé, ou SDXL type Illustrious/Pony)
         clip/                    t5xxl + clip_l (Flux uniquement)
         vae/                     ae.safetensors (Flux) ; SDXL utilise le VAE du checkpoint
         loras/                   <token>.safetensors pour chaque personnage
     Les LoRA Flux entraînés sur fal.ai se récupèrent avec : generate.py runpod-loras
  3. Variables d'environnement :
       RUNPOD_API_KEY, RUNPOD_ENDPOINT_ID
       RUNPOD_ARCH=flux|sdxl                     (défaut : flux, qui réutilise les LoRA de fal.ai)
       RUNPOD_MODEL=<nom du unet ou du checkpoint>
       RUNPOD_T5=t5xxl_fp8_e4m3fn.safetensors  RUNPOD_CLIP_L=clip_l.safetensors  RUNPOD_VAE=ae.safetensors (Flux)

Le workflow ComfyUI (format API) est construit dynamiquement : 0 à N LoRA chaînés (un par personnage présent).
"""
from __future__ import annotations

import base64
import json
import os
import random
import time
import urllib.request

API = "https://api.runpod.ai/v2"


class RunPodBackend:
    def __init__(self, dry_run: bool = False):
        self.dry_run = dry_run
        self.key = os.environ.get("RUNPOD_API_KEY", "")
        self.endpoint = os.environ.get("RUNPOD_ENDPOINT_ID", "")
        self.arch = os.environ.get("RUNPOD_ARCH", "flux")
        self.model = os.environ.get("RUNPOD_MODEL", "flux1-dev-fp8.safetensors" if self.arch == "flux" else "illustriousXL.safetensors")
        if not dry_run and (not self.key or not self.endpoint):
            raise SystemExit("RUNPOD_API_KEY et RUNPOD_ENDPOINT_ID requis (ou --dry-run)")

    # --- Workflows ComfyUI (format API) ---------------------------------------------------
    def workflow(self, prompt: str, negative: str, width: int, height: int, loras: list[tuple[str, float]],
                 seed: int | None = None, steps: int | None = None) -> dict:
        seed = seed if seed is not None else random.randint(1, 2**31 - 1)
        return (self._flux if self.arch == "flux" else self._sdxl)(prompt, negative, width, height, loras, seed, steps)

    def _flux(self, prompt, negative, width, height, loras, seed, steps) -> dict:
        wf = {
            "1": {"class_type": "UNETLoader", "inputs": {"unet_name": self.model, "weight_dtype": "default"}},
            "2": {"class_type": "DualCLIPLoader", "inputs": {"clip_name1": os.environ.get("RUNPOD_T5", "t5xxl_fp8_e4m3fn.safetensors"),
                                                             "clip_name2": os.environ.get("RUNPOD_CLIP_L", "clip_l.safetensors"), "type": "flux"}},
            "3": {"class_type": "VAELoader", "inputs": {"vae_name": os.environ.get("RUNPOD_VAE", "ae.safetensors")}},
        }
        model = ["1", 0]
        for i, (name, strength) in enumerate(loras):
            nid = str(10 + i)
            wf[nid] = {"class_type": "LoraLoaderModelOnly", "inputs": {"lora_name": name, "strength_model": strength, "model": model}}
            model = [nid, 0]
        wf.update({
            "4": {"class_type": "CLIPTextEncode", "inputs": {"text": prompt, "clip": ["2", 0]}},
            "5": {"class_type": "FluxGuidance", "inputs": {"conditioning": ["4", 0], "guidance": 3.5}},
            "6": {"class_type": "CLIPTextEncode", "inputs": {"text": "", "clip": ["2", 0]}},
            "7": {"class_type": "EmptySD3LatentImage", "inputs": {"width": width, "height": height, "batch_size": 1}},
            "8": {"class_type": "KSampler", "inputs": {"seed": seed, "steps": steps or 28, "cfg": 1.0, "sampler_name": "euler",
                                                       "scheduler": "simple", "denoise": 1.0, "model": model,
                                                       "positive": ["5", 0], "negative": ["6", 0], "latent_image": ["7", 0]}},
            "9": {"class_type": "VAEDecode", "inputs": {"samples": ["8", 0], "vae": ["3", 0]}},
            "20": {"class_type": "SaveImage", "inputs": {"filename_prefix": "manhwa_rpg", "images": ["9", 0]}},
        })
        return wf

    def _sdxl(self, prompt, negative, width, height, loras, seed, steps) -> dict:
        wf = {"1": {"class_type": "CheckpointLoaderSimple", "inputs": {"ckpt_name": self.model}}}
        model, clip = ["1", 0], ["1", 1]
        for i, (name, strength) in enumerate(loras):
            nid = str(10 + i)
            wf[nid] = {"class_type": "LoraLoader", "inputs": {"lora_name": name, "strength_model": strength,
                                                              "strength_clip": strength, "model": model, "clip": clip}}
            model, clip = [nid, 0], [nid, 1]
        wf.update({
            "4": {"class_type": "CLIPTextEncode", "inputs": {"text": prompt, "clip": clip}},
            "5": {"class_type": "CLIPTextEncode", "inputs": {"text": negative, "clip": clip}},
            "6": {"class_type": "EmptyLatentImage", "inputs": {"width": width, "height": height, "batch_size": 1}},
            "7": {"class_type": "KSampler", "inputs": {"seed": seed, "steps": steps or 30, "cfg": 6.0, "sampler_name": "dpmpp_2m_sde",
                                                       "scheduler": "karras", "denoise": 1.0, "model": model,
                                                       "positive": ["4", 0], "negative": ["5", 0], "latent_image": ["6", 0]}},
            "8": {"class_type": "VAEDecode", "inputs": {"samples": ["7", 0], "vae": ["1", 2]}},
            "20": {"class_type": "SaveImage", "inputs": {"filename_prefix": "manhwa_rpg", "images": ["8", 0]}},
        })
        return wf

    # --- Appel de l'endpoint -----------------------------------------------------------------
    def _request(self, method: str, url: str, payload: dict | None = None) -> dict:
        data = json.dumps(payload).encode() if payload is not None else None
        req = urllib.request.Request(url, data=data, method=method,
                                     headers={"Authorization": f"Bearer {self.key}", "Content-Type": "application/json"})
        with urllib.request.urlopen(req, timeout=600) as r:
            return json.loads(r.read().decode())

    def generate(self, prompt: str, negative: str, width: int, height: int, loras: list[tuple[str, float]]) -> bytes | None:
        wf = self.workflow(prompt, negative, width, height, loras)
        if self.dry_run:
            names = ", ".join(f"{n}@{s}" for n, s in loras) or "aucun"
            print(f"  [dry-run] runpod/{self.arch} {width}x{height} · LoRA : {names} · {len(wf)} nœuds ComfyUI")
            return None
        res = self._request("POST", f"{API}/{self.endpoint}/runsync", {"input": {"workflow": wf}})
        while res.get("status") in ("IN_QUEUE", "IN_PROGRESS"):
            time.sleep(3)
            res = self._request("GET", f"{API}/{self.endpoint}/status/{res['id']}")
        if res.get("status") != "COMPLETED":
            raise RuntimeError(f"RunPod : {res.get('status')} — {res.get('error', '')}")
        return self._extract_image(res.get("output", {}))

    @staticmethod
    def _extract_image(output: dict) -> bytes:
        # worker-comfyui ≥ 5 : {"images": [{"type": "base64"|"s3_url", "data": ...}]} ; anciennes versions : {"message": ...}
        images = output.get("images") or []
        item = images[0] if images else {"data": output.get("message", "")}
        data = item.get("data", "") if isinstance(item, dict) else str(item)
        if str(data).startswith("http"):
            with urllib.request.urlopen(data) as r:
                return r.read()
        return base64.b64decode(data)


SIZES = {"portrait_4_3": (896, 1152), "landscape_16_9": (1344, 768), "square": (1024, 1024)}
