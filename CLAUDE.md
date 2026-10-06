# Règles du projet — La Tour du Dernier Jour

Projet personnel : RPG narratif/tactique manhwa sous **Godot 4.5** (GDScript), données en JSON, documentation en français.

## Règle d'or : cohérence absolue
Après **chaque** nouveau bloc de dialogues, de données ou de code :
```bash
GODOT=/chemin/vers/godot ./tools/check_all.sh        # --quick pour sauter les parties automatiques
```
Ne jamais commiter si le script échoue. Le validateur (`tools/validate_data.py`) refuse notamment :
- les drapeaux, variables, objets ou souvenirs **lus mais jamais écrits** ;
- les blocs, rencontres, nœuds, dialogues, Fins, personnages ou compétences inexistants ;
- les conditions invalides et les effets inconnus ;
- les combats dont la défaite n'est pas gérée (l'étape suivante doit tester `v('combat.last')`) ;
- tout personnage romançable de moins de 18 ans.

## Conventions
- **Sources de vérité** : `docs/GDD.md` (design), `data/` (contenu du jeu), `data/art/prompts.json` (art). `docs/CHARADESIGN_PROMPTS.md` est **généré** : `python3 tools/art_pipeline/build_prompt_doc.py`.
- **Dialogues** : format décrit dans l'en-tête de `narrative/dialogue_runner.gd`. Chaque fichier qui contient un combat a un bloc `defeat`. Référencer un dialogue depuis la carte : `"fichier:bloc"`.
- **Variables d'état** : `align.protect` (+ protéger / − dominer), `align.bond` (+ lien / − solitude), `align.chaos`, `aff.<id>`, `trust.<id>`, `fear.<id>`, `ambivalence.<id>`, `argent`, `item.<id>`, `fatigue`, `camp.defense`, `refuge.*` (Refuge), `eau.controle`, `etage2.bruit`, `repos.<id>`. Groupe : `join <id>` / `leave <id>`. Fin connue : `fin <id>`.
- **Monde** : `data/world/sectors.json` (nœuds `secteur.nom`, liens symétriques), `events.json` (Ancres datées), `act_summary.json` (conséquences affichées en fin d'acte).
- **Voix** : après avoir écrit des répliques, lancer `python3 tools/voice_pipeline/voice_lines.py export`, puis compléter `tools/voice_pipeline/translations.json` (coréen et japonais).
- **Autotest** : `tests/autopilot.json` décrit l'itinéraire et les choix forcés (prologue → fin de l'Acte II). Le mettre à jour quand un acte change ; chaque étape doit être bornée dans le temps (`… or day() >= N`). `AUTOPILOT_DEBUG=1` trace l'itinéraire.
- **Refuge** : toute héroïne qui peut rejoindre le groupe (`join <id>` ou `flag party.<id>`) doit avoir un bloc `act2_refuge:<id>` (moment de repos) ; le validateur le vérifie.
- **Conditions** : comparer une variable texte avec une valeur par défaut, `v('eau.controle', '') == 'rats'` (sinon l'expression échoue tant que la variable n'existe pas).
- Le code GDScript n'utilise pas `class_name` : les dépendances se chargent avec `preload` (compatible avec les tests `-s`).
