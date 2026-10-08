# La Tour du Dernier Jour — manhwa-rpg

RPG narratif et tactique inspiré des manhwas/webtoons : régression temporelle, Registre des Fins, grilles de combat 3×3, 10 héroïnes, 30 jours avant le déversement de la Tour.

## Documents
- [Game Design Document](docs/GDD.md) — univers, mécaniques, personnages, architecture, état d'implémentation (§19.7).
- [Charadesign & prompts](docs/CHARADESIGN_PROMPTS.md) — prompts visuels des 11 personnages (morphologies, tenues, fanservice).
- [Pipeline d'images](tools/art_pipeline/README.md) — génération cloud (fal.ai) + backend 18+ (RunPod / ComfyUI).
- [Génération gratuite](tools/free_assets/README.md) — images, musique et voix sur le GPU gratuit de Colab ([ouvrir le notebook](https://colab.research.google.com/github/iminhell/manhwa-rpg/blob/main/tools/free_assets/generate_assets.ipynb)).
- [Règles du projet](CLAUDE.md) — conventions et contrôle de cohérence obligatoire.

## Jouer au prototype
1. Installer **Godot 4.5** (version standard), ouvrir le dossier du dépôt, lancer avec F5.
2. **Nouvelle boucle** : choix du mode (**Histoire**, **Normal**, **Survie**), prologue J1–J2, puis **la carte de Séoul** : Acte I jusqu'au Classement du J7, Acte II jusqu'au J15, Acte III jusqu'au J23, puis Acte IV jusqu'à la **Nuit du Déversement** (J30), ses Fins, et la régression vers la boucle suivante.
   **Continuer / Charger** reprennent une partie (autosauvegarde à chaque phase, 3 emplacements manuels).
3. **Fiches des personnages** et **Galerie** des CG débloquées : depuis l'écran titre ou le menu pause (Échap, ou bouton **Menu**).
4. **Options** : voix IA On/Off, langue coréenne ou japonaise, volumes, masquage des passages P3.

| Écran | Commandes |
|---|---|
| Dialogue | Clic, Espace ou Entrée pour avancer. Les choix sont des boutons magenta. Barre d'actions au-dessus du texte : **Sauver** (pendant une scène, la sauvegarde reprend sur la carte juste avant elle), **Charger**, **Auto** (A), **Passer** jusqu'au prochain choix (Tab), **Masquer** l'interface (H, clic pour la réafficher), **Journal** (L ou molette vers le haut), **Menu** (Échap) |
| Menu pause | Échap ou bouton **Menu** (carte, dialogue) : Reprendre, Sauvegarder, Charger, Fiches des personnages, Galerie, Options, Retour au titre |
| Carte | Clic sur un secteur (gauche) pour voyager. Clic sur une zone voisine (cercle bleu) pour s'y déplacer. Les actions sont listées en bas. Le bouton **Registre** affiche les Fins et les souvenirs |
| Refuge | Sur un nœud refuge : **Établir le Refuge**, puis **Gérer** (déposer ou retirer des rations, améliorations, vente de Fragments), **Moment de repos** avec chaque héroïne (une fois par héroïne et par jour, dès le crépuscule), **Cadeaux**, **scènes à plusieurs**, **Jour de répit** (à l'aube, avec un Sablier ; illimité en mode Histoire), **Dormir** |
| Combat | Une compétence, puis une case dorée. **Réécriture** (après la première mort) annule la dernière action |

Le temps est la ressource principale : chaque déplacement et chaque action coûtent des ticks. La fatigue s'accumule, et la nuit amène la Marée hors des refuges. Les Ancres du calendrier (Sceaux, camp de Yeouido, ouverture de la Tour, Nuée, concert du J9, Guerre de l'Eau, Sainte-Marie, Sommet, tunnels, mariage-duel, mutinerie, coup d'État, siège, contrat sur Simone, Machine d'Inversion, Exode, Protocole Cendre, Classements) n'attendent personne.

Tant que les images ne sont pas générées, le jeu affiche des **placeholders**. Tant que les pistes audio ne sont pas produites, il reste silencieux.

## Contenu actuel
- **Monde** : 7 secteurs et les étages 1 à 10 de la Tour, 85 sous-zones (souterrains, strates effondrées, sanctuaires, Cité Silencieuse, Marché des Âmes, Banquet, Labyrinthe, Tribunal, Jardin…), 84 événements datés.
- **Narration** : 23 fichiers de dialogues (environ 4 000 étapes).
  - Acte I : Hae-in, Haneul, Seo-Yeon et le camp, la Tour, rencontres-teasers des 10 héroïnes.
  - Acte II : Impôt du Sang, concert-piège d'Aoi, sacrifice des Élus, Guerre de l'Eau, Fin de Seo-Yeon, Sommet des Sceaux, tunnels de Maricel, étage 2.
  - Acte III : assaut du domaine Baek, mariage-duel de Ryeon, drones de Mirae, mutinerie du Dragon Pâle, l'Héritière au J20, coup d'État chez Haesong, Marée Rouge et siège de Myeongdong, étages 3 et 4.
  - Acte IV : Nadia et Simone (J24), Machine d'Inversion (J26), Dernier Exode (J27), Protocole Cendre (J28), étages 5 à 10, Nuit du Déversement (J30) : Fins de voie, 10 épilogues, Constellations, Harem, régression.
  - Refuge : moments de repos et nuits avec les 10 héroïnes (variantes Héros, Tyran et Mercenaire, Pactes : Dévotion et Rupture, Échos, emplacements P3), scènes à plusieurs (duos, conciliations, trio, quatuor, Nuit de la Maison).
- **Systèmes** : modes de difficulté, jours de répit, cadeaux, Échos inter-boucles, Indice de Résilience, Refuge (rations, améliorations, repos), sauvegarde/chargement, méta-progression entre les boucles.
- **Combat** : 114 compétences, 34 ennemis, 57 rencontres, groupe de 6. Réécriture, Pressentiment, Éveil, Peur, Grappin, Charme, poison, contre-attaque, paliers de Gardien, Règle du bruit, duels imposés.
- **Audio** : musique par contexte avec fondus, voix IA par réplique (554 répliques, coréen et japonais).
- **Art** : 61 CG rattachées à leur scène (nuits, scènes à plusieurs, Ancres de l'Acte IV), les scènes intimes passent par RunPod / ComfyUI.

## Validation
```bash
GODOT=godot ./tools/check_all.sh     # validateur + générateur d'assets + import + 6 663 tests + interface (--uitest) + 6 parties automatiques
AUTOPILOT_DEBUG=1 godot --headless --path . -- --autotest   # trace l'itinéraire de l'autopilote étape par étape
godot --path . -- --uitest            # interface : barre d'actions du dialogue, menu pause, fiches, galerie
godot --path . -- --capture           # captures d'écran dans user://captures/ (titre, carte, dialogue, journal, pause, fiches, galerie, combat)
```

## Outils
| Commande | Rôle |
|---|---|
| `python3 tools/validate_data.py` | Cohérence des données (références, variables orphelines, conditions…) |
| `python3 tools/art_pipeline/generate.py refs \| auto <id> <planche> \| assets` | Visuels (voir son README) |
| `python3 tools/voice_pipeline/voice_lines.py export \| generate --lang ko\|ja` | Répliques à doubler et synthèse vocale |
| `GENERER_ASSETS.bat` · `python3 tools/generate_assets.py [--paid]` | Assets en un clic : récupère ce que Colab a produit, ou génère (voir `tools/free_assets/README.md`) |
