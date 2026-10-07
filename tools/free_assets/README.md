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
python tools/free_assets/free_gen.py images --limit 10    # sur un PC avec carte NVIDIA (pip install torch diffusers compel accelerate)
python tools/free_assets/free_gen.py voices --only seo_yeon
python tools/generate_assets.py --paid --budget 15        # fal.ai + RunPod, estimation et confirmation avant tout appel
```
- Reprise : un fichier existant n'est jamais refait sans `--force`.
- Voix personnelle : déposer `assets/voice/refs/<personnage>.wav` (10 à 20 s propres) pour cloner cette voix au lieu de la voix XTTS prédéfinie.
- Autres modèles : variables `FREE_IMAGE_MODEL` et `FREE_MUSIC_MODEL`.

`test_free_gen.py` (lancé par `tools/check_all.sh`) vérifie le tout sans GPU, avec de faux moteurs.
