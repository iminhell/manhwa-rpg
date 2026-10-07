# Génération gratuite des assets (Colab ou GPU local)

Un seul générateur, `free_gen.py`, lit les sources de vérité du jeu et écrit directement aux chemins attendus par Godot :

| Assets | Source | Modèle (gratuit) | Sortie |
|---|---|---|---|
| Portraits, sprites, décors, CG non nsfw (87) | `data/art/manifest.json` + `prompts.json` | SDXL Animagine XL 3.1 | `assets/…/*.png` |
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
- `test_backends_torch.py` : les **vrais** pipelines diffusers SDXL et transformers MusicGen sur des mini-modèles aléatoires construits localement (aucun téléchargement). Il est ignoré si torch n'est pas installé : `pip install torch -r tools/free_assets/requirements.txt`.

Les deux sont lancés par `tools/check_all.sh`.
