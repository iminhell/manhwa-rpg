# Pipeline d'images automatisé

Objectif : produire tous les visuels **sans GPU local et sans ComfyUI**. Tout tourne dans le cloud (fal.ai). Ton rôle se limite à **choisir une planche par personnage**.

## Installation (une seule fois)
```bash
pip install fal-client
export FAL_KEY="ta_clé_fal"        # https://fal.ai → Dashboard → API Keys
```

## Flux de travail
```bash
# 1. Générer 4 planches de référence par personnage (11 × 4 images)
python tools/art_pipeline/generate.py refs

# 2. Ouvrir art_work/review.html et choisir la meilleure planche de chaque personnage
# 3. Une commande par personnage : validation → jeu de données (20 images cohérentes)
#    → entraînement du LoRA → génération de tous ses assets du manifeste
python tools/art_pipeline/generate.py auto seo_yeon 03.png

# Décors, ennemis, CG (sans LoRA, ou avec les LoRA des personnages présents)
python tools/art_pipeline/generate.py assets --kind background enemy_sprite cg
```
- Les images arrivent directement dans `assets/` du projet Godot, avec les noms attendus par `AssetDB`.
- Tant qu'un fichier manque, le jeu affiche un **placeholder** coloré : le développement n'est jamais bloqué par l'art.
- `--dry-run` affiche les prompts et le plan sans rien appeler ni payer.
- Les fichiers existants ne sont pas régénérés ; `--force` pour les refaire.

## Sources de vérité
| Fichier | Rôle |
|---|---|
| `data/art/prompts.json` | Style global, gabarits, noyaux d'identité, tenues et expressions des 11 personnages |
| `data/art/manifest.json` | Liste des assets à produire (id, type, personnage, expression, chemin de sortie) |
| `docs/CHARADESIGN_PROMPTS.md` | Version lisible, générée par `build_prompt_doc.py` |
| `art_work/` (ignoré par git) | Candidats, planches validées, jeux de données, `loras.json` |

## Modèles utilisés (surchargeables par variables d'environnement)
| Étape | Variable | Défaut |
|---|---|---|
| Texte → image | `ART_MODEL_T2I` | `fal-ai/flux/dev` |
| Variations à identité fixe (jeu de données) | `ART_MODEL_EDIT` | `fal-ai/flux-pro/kontext` |
| Entraînement LoRA | `ART_MODEL_TRAIN` | `fal-ai/flux-lora-fast-training` |
| Génération avec LoRA | `ART_MODEL_LORA` | `fal-ai/flux-lora` |

## Coût indicatif (à vérifier sur la grille tarifaire fal.ai)
- **Planches de référence** : 44 images, quelques dollars.
- **Jeux de données** : 11 × 20 images, de l'ordre de 10 $.
- **LoRA** : 11 entraînements, de l'ordre de 2 à 5 $ chacun.
- **Assets du prototype** : 52 images, quelques dollars.
- **Jeu complet** : environ 200 CG avec 2 à 3 essais chacune, plus les portraits, soit quelques dizaines de dollars.

## Contenu 18+
Les appels désactivent le filtre de sécurité (`enable_safety_checker: false`), mais **les conditions d'utilisation de fal.ai et des modèles Flux s'appliquent** et peuvent refuser le contenu explicite. Si c'est le cas, la solution de repli prévue est un **endpoint serverless ComfyUI sur RunPod** : tes propres modèles et LoRA, aucun filtre, facturation à la seconde, et le même script avec un nouveau backend. Ce backend est prêt : `runpod_backend.py`. Il construit le workflow ComfyUI en Flux ou en SDXL, avec un LoRA par personnage présent. Les entrées du manifeste marquées `"backend": "runpod"` y sont routées automatiquement, et `--backend runpod` force tout le lot. Toute la configuration est décrite en tête du fichier.

## Portraits « Live2D-lite »
Le rigging Live2D ne s'automatise pas. Le prototype anime donc les portraits **dans Godot**, sans rigging :
- un shader de respiration et de balancement (`shaders/portrait_breathe.gdshader`) ;
- un clignement des yeux (variante `blink`) ;
- le changement d'expression par image.

Le vrai Live2D reste une option pour plus tard, pour les héroïnes principales.
