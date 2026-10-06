# La Tour du Dernier Jour — manhwa-rpg

RPG narratif et tactique inspiré des manhwas/webtoons : régression temporelle, Registre des Fins, grilles de combat 3×3, 10 héroïnes, 30 jours avant le déversement de la Tour.

## Documents
- [Game Design Document](docs/GDD.md) — univers, mécaniques, personnages, architecture, état d'implémentation (§19.7).
- [Charadesign & prompts](docs/CHARADESIGN_PROMPTS.md) — prompts visuels des 11 personnages (morphologies, tenues, fanservice).
- [Pipeline d'images](tools/art_pipeline/README.md) — génération cloud (fal.ai) + backend 18+ (RunPod / ComfyUI).
- [Règles du projet](CLAUDE.md) — conventions et contrôle de cohérence obligatoire.

## Jouer au prototype
1. Installer **Godot 4.5** (version standard), ouvrir le dossier du dépôt, lancer avec F5.
2. **Nouvelle boucle** : prologue J1–J2, puis **la carte de Séoul** jusqu'au Classement du J7 (fin de l'Acte I).
3. **Options** : voix IA On/Off, langue coréenne ou japonaise, volumes.

| Écran | Commandes |
|---|---|
| Dialogue | Clic, Espace ou Entrée pour avancer. Les choix sont des boutons magenta |
| Carte | Clic sur un secteur (gauche) pour voyager. Clic sur une zone voisine (cercle bleu) pour s'y déplacer. Les actions sont listées en bas. Le bouton **Registre** affiche les Fins et les souvenirs |
| Combat | Une compétence, puis une case dorée. **Réécriture** (après la première mort) annule la dernière action |

Le temps est la ressource principale : chaque déplacement et chaque action coûtent des ticks. La fatigue s'accumule, et la nuit amène la Marée hors des refuges. Les Ancres du calendrier (Sceaux, camp de Yeouido, ouverture de la Tour, Nuée, Classement) n'attendent personne.

Tant que les images ne sont pas générées, le jeu affiche des **placeholders**. Tant que les pistes audio ne sont pas produites, il reste silencieux.

## Contenu actuel
- **Monde** : 7 secteurs et l'étage 1 de la Tour, 60 sous-zones dont 14 cachées (souterrains, strates effondrées, sanctuaires), 18 événements datés.
- **Narration** : 6 fichiers de dialogues (environ 780 étapes). Hae-in, Haneul, Seo-Yeon et le camp, la Tour, et des rencontres-teasers des 10 héroïnes.
- **Combat** : 30 compétences, 6 ennemis, 14 rencontres. Réécriture, Pressentiment, Éveil, Peur.
- **Audio** : musique par contexte avec fondus, voix IA par réplique (règles d'apparition et de scènes clés).

## Validation
```bash
GODOT=godot ./tools/check_all.sh     # validateur de données + import + 1 165 tests + 3 parties automatiques
godot --path . -- --capture           # captures d'écran dans user://captures/
```

## Outils
| Commande | Rôle |
|---|---|
| `python3 tools/validate_data.py` | Cohérence des données (références, variables orphelines, conditions…) |
| `python3 tools/art_pipeline/generate.py refs \| auto <id> <planche> \| assets` | Visuels (voir son README) |
| `python3 tools/voice_pipeline/voice_lines.py export \| generate --lang ko\|ja` | Répliques à doubler et synthèse vocale |
