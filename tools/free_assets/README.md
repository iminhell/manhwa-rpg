# Génération gratuite des assets (Colab ou GPU local)

Un seul générateur, `free_gen.py`, lit les sources de vérité du jeu et écrit directement aux chemins attendus par Godot :

| Assets | Source | Modèle (gratuit) | Sortie |
|---|---|---|---|
| **Sprites des 11 personnages** : 101 portraits en pied (une pose par personnage, une image par expression) et 4 sprites de combat, **fond transparent** | `manifest.json` + `sprite_style.json` | Animagine XL 3.1 (fichier unique) + LoRA Takeda Hiromitsu et Add Detail XL (Civitai), détourage rembg `isnet-anime` | `assets/portraits/<perso>/<expression>.png`, `assets/sprites/<perso>.png` |
| Décors, ennemis, CG non nsfw | `data/art/manifest.json` + `prompts.json` | SDXL Animagine XL 3.1 | `assets/…/*.png` |
| Musique (18 pistes de 30 s, en boucle) | `data/audio/music.json` (`prompt`) | MusicGen medium | `assets/audio/music/<id>.ogg` |
| Voix coréennes et japonaises (554 × 2) | `tools/voice_pipeline/lines.csv` | XTTS-v2, voix `voice.xtts` de chaque personnage | `assets/voice/<ko\|ja>/<perso>/<id>.ogg` |

Les **30 CG nsfw** ne passent pas par ici : elles restent sur le backend RunPod (`python tools/generate_assets.py --paid`).

## En deux clics
1. Ouvrir le notebook : [generate_assets.ipynb dans Colab](https://colab.research.google.com/github/iminhell/manhwa-rpg/blob/main/tools/free_assets/generate_assets.ipynb) (*Exécution ▸ Modifier le type d'exécution ▸ T4 GPU*).
2. Cocher la licence XTTS (usage non commercial), puis **Exécution ▸ Tout exécuter**. Compter environ 2 heures en tout.

Livraison :
- avec un secret Colab `GITHUB_TOKEN` (jeton à grain fin, *Contents: read and write*), chaque lot est poussé sur GitHub ;
- sans jeton, `assets_generated.zip` est téléchargé à la fin.

Sur le PC, double-cliquer `GENERER_ASSETS.bat` (ou `./generer_assets.sh`) : il fait `git pull`, installe le zip trouvé dans Téléchargements, et affiche ce qui reste.

## Sprites de personnages
- **Style** : `sprite_style.json`, modifiable sans toucher au code. Il contient :
  - le checkpoint et les LoRA (URL, poids, mot déclencheur) ;
  - les mots-clés de qualité communs, le fond blanc et le négatif ;
  - la pose féminine (celle de la référence de Gaïa), la pose masculine et la pose de combat ;
  - les tags de chaque personnage (gabarit, identité, tenue), fidèles aux fiches : volumineux pour Hae-in ou Maricel, musclé pour Simone et Elias, fin pour Aoi, Nadia, Ryeon…
  - les tags de chaque expression.
- **Pondération** : la syntaxe A1111 (`(full body:1.4)`, `(mot)`, `[mot]`) est appliquée aux embeddings.
- **Cohérence** : la pose neutre de chaque personnage est générée une fois et gardée dans `art_work/sprite_bases/`. Chaque autre expression, clignement compris, est produite par **inpainting du seul visage** : le corps est identique au pixel près, et le clignement ne fait pas sauter le personnage.
- **Détourage** : `rembg` avec le modèle `isnet-anime` retire le fond blanc, puis `clean_alpha` nettoie le masque **sans toucher aux couleurs visibles**, pour que le trait de contour reste intact. Il supprime :
  - le fond blanc résiduel à l'alpha incertain (voile, fond coincé entre deux éléments) ;
  - l'ombre portée sous les pieds (gris neutre semi-transparent dans le bas de la silhouette) ;
  - les îlots isolés et le voile qui bave autour du contour (resserrement de l'alpha).

  Les pixels transparents reçoivent la couleur du bord voisin, pour éviter tout halo blanc ou noir au filtrage dans Godot. Testé sur l'image de référence de Gaïa : ombre 51 038 → 11 pixels, contour conservé. Réglages : `alpha_cleanup` dans `sprite_style.json`.
- **Netteté** :
  - échantillonneur DPM++ 2M Karras, 30 étapes, CFG 6 ;
  - VAE corrigé pour le fp16 (`madebyollin/sdxl-vae-fp16-fix`) : sans lui, une grande image peut sortir noire ;
  - **hires fix** : 832×1216 → ×4 par **Real-ESRGAN x4plus anime 6B** (chargé par `spandrel`, trait net), réduit à 1456×2128, puis img2img à 0,42 (≈ 13 étapes réelles). L'ancien agrandissement Lanczos laissait une image floue (rendu « 120p ») ;
  - **retouche des visages et des mains** : détectés par les modèles YOLO d'ADetailer (`Bingsu/adetailer`), puis repeints en 1024 px ;
  - taille finale **2048 px** de haut, image **recadrée sur la silhouette** (même cadre pour toutes les expressions d'un personnage) ;
  - tags de netteté et négatifs anti-flou et anti-mains déformées ; LoRA Takeda à 0,6.

  Sans modèle de détection ou d'agrandissement, la génération continue (retouche sautée, Lanczos), avec un avertissement.
- **Garde anti-sprite vide** : une image uniforme (rendu raté), un détourage presque vide (personnage effacé avec le fond) ou une silhouette tronquée déclenchent un nouvel essai avec une autre graine (`retries`, 3 par défaut) ; après le dernier, rien n'est enregistré (le jeu garde son placeholder) et un « ÉCHEC » est affiché. Si le nettoyage du détourage efface trop de pixels (vêtements sombres), le détourage rembg brut est gardé.
- **Traits ecchi** des héroïnes : `allure_female` (courbes, peau brillante, cuisses), ajouté à toutes les héroïnes, jamais à Elias ; aucune nudité (voir Garde-fous).
- **Refaire un personnage** : réglage `REGENERER` du notebook (ex. `elias`), ou `free_gen.py sprites --force --only elias`.
- **Garde-fous** : le négatif garde `nude, nipples` (sprites habillés) et les tags anti-juvénilité (`child, loli, childlike, young-looking`), et tous les profils portent `mature female` / `mature male`.
- **LoRA Civitai** : certains exigent un jeton (secret Colab `CIVITAI_TOKEN`). Les mots déclencheurs indiqués sont à vérifier sur la page de chaque LoRA. Un LoRA entraîné sur Illustrious fonctionne avec un checkpoint SDXL comme Animagine, mais son effet peut varier.

## Variantes
```bash
python tools/free_assets/free_gen.py plan                 # ce qui reste à produire
python tools/free_assets/free_gen.py images --limit 10    # PC avec carte NVIDIA : pip install torch torchaudio -r tools/free_assets/requirements.txt
python tools/free_assets/free_gen.py voices --only seo_yeon
python tools/generate_assets.py --paid --budget 15        # fal.ai + RunPod, estimation et confirmation avant tout appel
```
- Reprise : un fichier existant n'est jamais refait sans `--force`.
- Voix personnelle : déposer `assets/voice/refs/<personnage>.wav` (10 à 20 s propres) pour cloner cette voix au lieu de la voix XTTS prédéfinie.
- Autres modèles : variables `FREE_IMAGE_MODEL` et `FREE_MUSIC_MODEL`.

## Versions figées
`requirements.txt` fixe un ensemble testé (le notebook l'installe une fois) : **transformers 4.57.6**, **diffusers 0.39.0**, **coqui-tts[ja,ko,codec] 0.27.5** ; torch, torchaudio et ffmpeg restent ceux de Colab. Pourquoi :
- coqui-tts 0.27.5 ne se charge pas avec transformers 5.x (`isin_mps_friendly` retiré) ;
- transformers 4.57 exige huggingface-hub < 1.0, ce qu'acceptent diffusers ≤ 0.39 ;
- avec torch ≥ 2.9, coqui-tts exige le paquet torchcodec (extra `codec`).

Les prompts longs (au-delà de 77 jetons CLIP) sont encodés par `free_gen.py` lui-même, par tranches, comme le fait `StableDiffusionXLPipeline.encode_prompt` : plus de dépendance à compel, dont l'API a changé.

## Tests
- `test_free_gen.py` : sans GPU ni bibliothèque lourde, avec de faux moteurs (chemins, reprise, Ogg, zip, découpage des répliques sous les limites XTTS de 71 caractères en japonais et 95 en coréen).
- `test_backends_torch.py` : les **vrais** pipelines diffusers SDXL (encodage pondéré, LoRA chargé par `load_lora_weights`, inpainting du visage avec corps identique) et transformers MusicGen, sur des mini-modèles aléatoires construits localement, plus le vrai détourage rembg. Avec `SPRITE_REF_IMAGE=<image d'anime sur fond blanc>`, il vérifie aussi la qualité du détourage. Il est ignoré si torch n'est pas installé : `pip install torch -r tools/free_assets/requirements.txt`.

Les deux sont lancés par `tools/check_all.sh`.
