# La Tour du Dernier Jour — manhwa-rpg

RPG narratif et tactique inspiré des manhwas/webtoons : régression temporelle, Registre des Fins, grilles de combat 3×3, 10 héroïnes, 30 jours avant le déversement de la Tour.

## Documents
- [Game Design Document](docs/GDD.md) — univers, mécaniques, personnages, architecture.
- [Charadesign & prompts](docs/CHARADESIGN_PROMPTS.md) — prompts visuels des 11 personnages (généré depuis `data/art/prompts.json`).
- [Pipeline d'images](tools/art_pipeline/README.md) — génération automatisée des visuels dans le cloud.

## Lancer le prototype
1. Installer **Godot 4.5** (version standard, pas .NET).
2. Ouvrir le dossier du dépôt dans Godot (le fichier `project.godot` est à la racine), puis lancer avec F5.
3. Au menu, choisir **Nouvelle boucle** pour jouer le prologue (J1–J2), ou **Combat de test** pour affronter le Portier avec 4 personnages.

**Commandes** : clic ou Espace/Entrée pour avancer. En combat, choisir une compétence puis une case dorée. **Réécriture** (disponible après la première mort) annule la dernière action.

Tant que les images ne sont pas générées, le jeu affiche des **placeholders** colorés.

## Contenu du prototype
| Système | Fichiers |
|---|---|
| Moteur de dialogue JSON (choix, effets, conditions, événements, id de réplique pour les voix) | `narrative/dialogue_runner.gd`, `scenes/dialogue/` |
| Combat 3×3 : frise CTB, mêlée limitée à la ligne avant, intentions ennemies (Pressentiment), Éveil et ultimes, Peur et fuite, Réécriture | `combat/`, `scenes/combat/` |
| Régression : la mort ramène au J1, avec les souvenirs et le compteur de boucle conservés | `core/game_state.gd` |
| Données : 11 personnages, 29 compétences, 4 ennemis, 4 rencontres, prologue de 149 étapes | `data/` |
| Portraits « Live2D-lite » : respiration, clignement, expressions | `scenes/dialogue/portrait_view.gd`, `shaders/` |

## Tests et validation (headless)
```bash
godot --headless --path . -s res://tests/run_tests.gd               # tests unitaires et combats simulés
godot --headless --path . -- --autotest                             # joue tout le prototype automatiquement
godot --headless --path . -- --autotest --autotest-regress          # idem, avec une défaite forcée (régression)
godot --path . -- --capture                                         # captures d'écran dans user://captures/
```

## Écrire des dialogues
Voir l'en-tête de `narrative/dialogue_runner.gd` pour le format complet. Exemple :
```json
{"s": "seo_yeon", "t": "Vous saignez. Asseyez-vous.", "e": "anger"},
{"choice": [{"t": "Merci.", "goto": "kind", "fx": ["add aff.seo_yeon 5"]}]},
{"if": "loop() > 1", "then": "deja_vu"},
{"event": "combat", "args": {"encounter": "j2_camp"}}
```
