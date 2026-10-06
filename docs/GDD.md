# LA TOUR DU DERNIER JOUR — Game Design Document v0.4

> RPG narratif et tactique inspiré des manhwas/webtoons, à haute liberté de choix.
> **Statut** : pré-production. Le document de conception fait foi avant toute phase de code.
> Toutes les valeurs chiffrées sont des points de départ à équilibrer pendant le prototype.
> **Projet personnel, usage privé.** Une seule version du jeu, contenu 18+ intégré de base. Aucune contrainte de distribution, aucune autocensure : les thèmes sombres et les passés bruts des personnages sont assumés.

---

## Sommaire
0. [Décisions validées](#0-décisions-validées)
1. [Concepts d'univers (historique)](#1-concepts-dunivers-historique)
2. [Prémisse & ton](#2-prémisse--ton)
3. [La mécanique des 30 jours](#3-la-mécanique-des-30-jours)
4. [La Régression (boucle temporelle)](#4-la-régression-boucle-temporelle)
5. [Les 7 secteurs de Séoul](#5-les-7-secteurs-de-séoul)
6. [Les 5 clans-chaebols & factions](#6-les-5-clans-chaebols--factions)
7. [Carte & navigation](#7-carte--navigation)
8. [Alignement & conséquences](#8-alignement--conséquences)
9. [Moteur de combat](#9-moteur-de-combat)
10. [Fiche du protagoniste — Elias Kang (+ Classes)](#10-fiche-du-protagoniste--elias-kang)
11. [Système de harem : règles communes (+ Pacte de Vassalité)](#11-système-de-harem--règles-communes)
12. [Les 10 héroïnes](#12-les-10-héroïnes)
13. [Matrice de cohésion, Fins liées, Constellations & Harem Absolu](#13-matrice-de-cohésion-fins-liées-constellations--harem-absolu)
14. [La Tour avant le Jour 30](#14-la-tour-avant-le-jour-30)
15. [L'Après-Jour 30 — L'Ère des Strates](#15-laprès-jour-30--lère-des-strates)
16. [Lore profond & le Prophète](#16-lore-profond--le-prophète)
17. [Fins du jeu](#17-fins-du-jeu)
18. [Direction artistique, voix & médias](#18-direction-artistique-voix--médias)
19. [Architecture technique](#19-architecture-technique)
20. [Périmètre de la démo](#20-périmètre-de-la-démo)
21. [Réponses validées & questions ouvertes](#21-réponses-validées--questions-ouvertes)

---

## 0. Décisions validées

| Sujet | Décision |
|---|---|
| Statut | **Projet personnel**, aucune distribution publique. Une seule version complète |
| Univers | **Concept A — La Tour du Dernier Jour** (apocalypse, Système/Tour, régression), avec des factions-chaebols et une héroïne-pivot |
| Protagoniste | Homme métis, 1m84 / 86 kg, imposé : **Elias Kang** (§10) |
| Casting romançable | **10 héroïnes** uniques, de profils, d'âges (22 à 41 ans) et d'origines variés (§12), toutes célibataires ou dans une union contractuelle non consommée |
| Combinaisons | **Toutes les compositions** sont gérées : Solo, Duos, Trios, Quatuors… jusqu'aux 10, chacune avec ses synergies, ses scènes et ses sous-routes (§13.3). **Harem Absolu** avec les 10 (§13.4) |
| Plateformes | PC (Windows, Linux, macOS), Android (APK), iOS (installation personnelle) |
| Contenu | **Tout le contenu 18+ est intégré de base**, sans version séparée. Il comprend des scènes sombres de domination sur la voie du Tyran (§11.4) |
| Ratio de jeu | **60 %** narration / choix / carte — **40 %** combat tactique au tour par tour (grilles 3×3) |
| Régression | Vraie boucle temporelle : mémoire, connaissances, compétences et **classes maîtrisées** conservées (§4, §10.8) |
| Structure | Jeu complet d'un seul bloc : avant le J30, puis l'**Ère des Strates** (étages 11 à 100, §15) |
| Doublage | Voix IA haute qualité en **coréen et japonais** (au choix), avec une option globale **On/Off** (§18.3) |
| Visuels | Portraits animés **Live2D / Spine** + **CG HD fixes**, produits par **génération IA** (Midjourney et Stable Diffusion avec LoRA, §18.6) |
| Périmètre v1.0 | **Séoul + les 50 premiers étages**. Carte mondiale et étages 51 à 100 en **extension** (§15) |
| Mobile | **Paysage exclusif** (§18.5, §19.6) |
| Antagoniste | Le **Prophète des Élus** est un personnage déjà connu, avec un twist révélé au fil des boucles (§16.3) |
| Moteur | **Godot 4.x** (GDScript), §19 |

**Règles de design de l'univers :**
1. **Tous les personnages romançables sont des adultes.** Leur âge est inscrit dans les données, et leur charadesign a des proportions adultes.
2. **Aucune autocensure** sur les thèmes sombres (traumas, crimes, emprise, exploitation, automutilation). Ils font partie du passé et des arcs des personnages.
3. **Pas de violence physique dans les scènes intimes.** La domination de la voie du Tyran passe par le pouvoir, l'ascendant psychologique et le **contrat de vassalité** (§11.4), jamais par les coups.
4. **La Loi des Contrats du Système** (lore, §16.1) : tout pacte exige une signature lucide et contient une clause de rupture. Ce cadre donne au Pacte sa tension dramatique : chaque héroïne vassale *pourrait* partir, et le prix de ce départ fait toute l'histoire.

---

## 1. Concepts d'univers (historique)

Trois concepts ont été étudiés à la v0.1 :
- **A — La Tour du Dernier Jour** : apocalypse, Système/Tour, régression. **Retenu.**
- **B — Neo-Hanseong 2099** : thriller cyber de factions. Ses chaebols-clans ont été intégrés au concept A.
- **C — Le Trône des Cendres** : dark fantasy, une princesse ressuscitée. Son compte à rebours émotionnel a été intégré via l'**Héritière de la Tour**.

---

## 2. Prémisse & ton

### 2.1 Prémisse
- **Jour 0, 23h59.** Une tour d'obsidienne de 3 km de haut se plante au cœur de **Yongsan**. Toutes les vitres de Séoul explosent au même instant. Une voix sans timbre résonne dans chaque crâne :

> **[SYSTÈME]** *Bienvenue, Candidats. L'Ascension commence. Dans 30 jours, la Tour descendra vers vous. Montez — ou soyez recouverts.*

- **Jour 1.** Environ 12 % des 9,4 millions d'habitants survivent à la première nuit. Parmi eux, environ 4 % « s'éveillent » : ils reçoivent une **Classe** et un **rang** (de F à S, plus EX, caché).
- Un dôme translucide, le **Voile**, isole la ville du reste du monde. Ni ondes, ni avions, ni sortie. Les militaires de Yongsan disposent seulement d'un canal radio intermittent avec l'extérieur (§6.7).
- **Jour 30.** La **Grande Descente** : les 10 premiers étages se « déversent » sur la ville comme une marée de pierre, de monstres et de règles.
- **Elias Kang** a déjà vécu ces 30 jours. Il est mort au sommet de l'étage 10, une balle dans la nuque, à 23h58 le jour 30. Il se réveille au **Jour 1, Aube**, avec le **Registre des Fins** gravé derrière les yeux.

### 2.2 Ton
- **Tension de thriller** : complots de chaebols, trahisons, comptes à rebours.
- **Action shonen** : éveils, montées en puissance, combats-spectacles avec cut-ins en cases manhwa.
- **Survie** : pénuries, marées nocturnes, choix moraux sans bonne réponse.
- **Romance à fort enjeu** : chaque héroïne a une date de mort inscrite dans le Registre. Aimer quelqu'un, c'est se battre contre son destin.
- **Humour sec** dans les dialogues d'Elias, pour éviter le misérabilisme.

---

## 3. La mécanique des 30 jours

### 3.1 Le temps comme ressource principale
- **1 jour = 4 phases** : 🌅 Aube · ☀️ Jour · 🌇 Crépuscule · 🌙 Nuit.
- **Une boucle = 30 jours = 120 phases.** C'est le budget absolu du joueur.
- **Coûts en temps :**

| Action | Coût |
|---|---|
| Voyage entre secteurs adjacents | 1 phase |
| Voyage entre secteurs non adjacents | 2 phases (ou 1 via un passage secret connu) |
| Déplacement entre deux nœuds d'un secteur | ¼ de phase |
| Scène de dialogue majeure / recrutement | ½ phase |
| Combat standard | ¼ de phase |
| Combat de boss / siège | 1 phase |
| Exploration d'un étage de la Tour | 1 à 3 phases selon l'étage |
| Événement de relation (rendez-vous, nuit au Refuge) | 1 phase |
| Sommeil | 1 phase (obligatoire, voir Fatigue) |
| Construction au Refuge, artisanat | ½ à 2 phases |
| Mission confiée à un allié (éclaireur, collecte) | 0 phase pour Elias. L'allié est indisponible 1 à 3 phases |

- **Fatigue** : Elias peut enchaîner 4 phases éveillé sans pénalité.
  - 5e phase : −15 % aux stats.
  - 6e phase : −30 % et risque d'erreur de jugement (des choix « impulsifs » s'imposent dans les dialogues).
  - 7e phase : malaise forcé.
- **Rythme 60/40** : une journée type compte 2 à 3 phases de narration et d'exploration pour 1 à 2 phases de combat. Durée cible : **25 à 35 minutes de jeu réel par jour**, donc 12 à 15 heures pour une première boucle complète. Les boucles suivantes sont plus rapides (§4.6).

### 3.2 La Pression de la Tour (P)
Une jauge globale de 0 à 100, visible dans le Registre dès la boucle 1 et cachée pour tous les autres personnages. Elle mesure la violence de la Descente au jour 30.

```
P(J) = 20 + 2,5 × (J − 1) + Σ modificateurs
```

Sans intervention, **P atteint 92,5 au jour 30**, ce qui donne l'Effacement (fin de partie, donc régression).

| Modificateur | Effet sur P |
|---|---|
| Gardien d'étage vaincu (étages 1 à 10) | −8 chacun |
| Premier Conquérant d'un étage (bonus persistant entre boucles, §4.3) | −2 supplémentaires |
| Sacrifice public des Élus (J10, J16, J22, J29, s'il n'est pas empêché) | +5 chacun |
| Un Sceau détruit (§6.1) | +8 |
| Pacte entre deux porteurs de Sceaux | −4 par pacte (maximum 3) |
| Héritière capturée par les Élus ou Mirae | +15 |
| Héritière ayant atteint l'étage 10 avec Elias, Lien ≥ 60 | −20 (déclenche l'arc de la fin vraie) |
| Protocole Cendre exécuté (J28) | −10 sur P, mais un secteur est rayé de la carte |

### 3.3 L'Indice de Résistance (IR)
- Chaque secteur a une **Défense** de 0 à 100. Elle augmente avec les fortifications, les éveillés armés, les alliances, un Refuge actif et la présence d'une héroïne alliée.
- **IR = moyenne des Défenses des secteurs encore habités.**
- **Issue du jour 30** (croisement de P et de l'IR) :

| | IR < 35 | IR 35–65 | IR > 65 |
|---|---|---|---|
| **P ≤ 30** | Descente avortée, ville exsangue | **Descente avortée** — victoire | **Aube Nouvelle** (meilleure issue de voie) |
| **P 31–60** | Déferlement partiel, 3 secteurs perdus | Ville sauvée, lourdes pertes | Victoire coûteuse |
| **P 61–85** | Chute de Séoul (fin tragique) | Survie dans les ruines (fin de voie dégradée) | Siège sans fin (fin ouverte) |
| **P > 85** | **Effacement** → régression forcée | Effacement → régression | Effacement → régression |

### 3.4 Les Marées nocturnes
- Chaque phase 🌙 Nuit, des monstres descendent de la Tour.
- **Palier de Marée** : `T = 1 + floor((J − 1) / 6)`, soit T1 aux jours 1–6, T2 aux jours 7–12, T3 aux jours 13–18, T4 aux jours 19–24, T5 aux jours 25–30.
- **Dégâts sur un secteur** = `T × 12 − Défense/2`. Si le résultat est positif, le secteur perd de la population, un nœud peut tomber (devenir un nid de monstres), et les PNJ présents risquent leur vie. Le Registre signale les Fins avancées.
- **Si Elias passe la Nuit dans un secteur**, il peut défendre le secteur (un combat de Marée), chasser (butin rare, PNJ nocturnes) ou se cacher.

### 3.5 Structure en Actes et Classements du Système
- Le Système publie un **Classement** des éveillés aux jours 7, 15 et 23, ce qui clôt chaque acte.
- Les rangs publics influencent la réputation, le recrutement et la façon dont les clans traitent Elias. Celui-ci peut **cacher son rang** (compétence *Voile d'Ombre*) pour jouer les Loups.

| Acte | Jours | Thème | Ce qui change |
|---|---|---|---|
| **I — Éveil** | 1–7 | Chaos, survie, premières alliances | Les clans prennent forme, la Tour ouvre ses portes |
| **II — Consolidation** | 8–15 | Territoires, impôts, ressources | Les clans se partagent la ville, les héroïnes entrent en crise |
| **III — Guerre des Sceaux** | 16–23 | Guerre ouverte, trahisons | Le Système annonce publiquement la Descente au jour 23 |
| **IV — Veille** | 24–30 | Exode, sacrifices, ascension finale | Protocole Cendre, ouverture des étages 7 à 10, Descente |

### 3.6 Calendrier des Ancres temporelles (événements fixes)
Les **Ancres** se produisent toujours si personne n'intervient. Elles forment la colonne vertébrale que le joueur apprend à manipuler d'une boucle à l'autre. Un 💀 signale une **Fin d'héroïne** (§12).

| Jour | Phase | Ancre | Secteur | Note de design |
|---|---|---|---|---|
| **J1** | 🌅 | Réveil d'Elias (point de régression) | Yongsan (Itaewon) | Tutoriel. Quête obligatoire du Système : *tuer un monstre avant J2 minuit, sinon la mort* |
| J1 | 🌙 | Première Marée | Tous | Combat de survie scénarisé |
| J2 | ☀️ | Formation du Camp de Yeouido | Yeouido | Rencontre possible avec **Seo-Yeon** |
| **J3** | 🌇 | **Distribution des Sceaux** : le Système remet 5 Sceaux aux 5 groupes qui comptent le plus d'éveillés | Tous | Naissance officielle des 5 clans (§6.1) |
| J4 | ☀️ | Décision du Camp de Yeouido (défendre, rançonner, piller, vendre) | Yeouido | Premier choix moral majeur (§8.6) |
| **J5** | 🌅 | La Porte de l'étage 1 s'ouvre. L'Unité 0 boucle Yongsan | Yongsan / Tour | Héritière accessible si Elias possède le Souvenir n°4 |
| J6 | 🌙 | Nuée sur Yeouido | Yeouido | Le camp tombe s'il n'a pas été défendu |
| **J7** | 🌇 | **Premier Classement** — fin de l'Acte I | Tous | Les clans recrutent les mieux classés |
| J8 | ☀️ | Cheonma instaure l'« Impôt du Sang » à Gangnam | Gangnam | Révolte possible |
| **J9** | 🌙 | 💀 Concert-piège de Mirae | Hongdae | Fin d'**Aoi** |
| J10 | 🌅 | Étage 2 ouvert. Premier sacrifice des Élus | Tour / Yongsan | P +5 si le sacrifice n'est pas empêché |
| J11 | ☀️ | Guerre de l'Eau : Longwei saisit les pompes du Han | Ponts du Han | Les pénuries touchent tous les secteurs |
| **J12** | 🌇 | 💀 Hôpital de Yeouido | Yeouido | Fin de **Seo-Yeon** |
| **J13** | ☀️ | **Sommet des Sceaux** dans la cathédrale de Myeongdong (terrain neutre) | Myeongdong | Diplomatie à grande échelle. Elias peut s'y inviter |
| **J14** | 🌅 | 💀 Effondrement des tunnels | Myeongdong (sous-sol) | Fin de **Maricel** |
| **J15** | 🌇 | **Deuxième Classement** — fin de l'Acte II. Quêtes de Faction | Tous | Choix de camp attendu par le Système |
| J16 | 🌅 | Cheonma attaque le domaine Baek. Deuxième sacrifice | Collines du Nord | Début de la guerre ouverte |
| **J17** | 🌇 | 💀 Mariage-duel Baek × Cheonma | Collines du Nord | Fin de **Ryeon** |
| J18 | 🌅 | Étages 3 et 4 ouverts. Mirae déploie ses drones | Tour / Hongdae | |
| **J19** | 🌙 | 💀 Mutinerie sur le Han | Ponts du Han | Fin de **Xiaoyu** |
| J20 | 🌅 | Les Élus découvrent l'Héritière (si Elias ne l'a pas trouvée avant) | Tour, étage 1 | Dans la première vie, c'est ce jour qu'Elias l'a rencontrée |
| **J21** | ☀️ | 💀 Coup d'État au conseil de Haesong | Yeouido | Fin de **Hae-in** |
| J22 | 🌙 | **Marée Rouge** (palier de Marée exceptionnel +1) et siège de Myeongdong. Troisième sacrifice | Myeongdong | Pic de la guerre |
| **J23** | 🌇 | **Troisième Classement** — fin de l'Acte III. Le Système annonce publiquement : *« Descente dans 7 jours »* | Tous | Panique, exode, ralliements |
| **J24** | 🌇 | 💀 Contrat sur la Commandante Hayes, depuis le toit de la Lotte Tower | Gangnam → Yongsan | Fin de **Nadia** OU de **Simone** (Fins liées, §13.2) |
| J25 | 🌅 | Étages 5 et 6 ouverts. Mirae teste la « Machine d'Inversion » | Tour / Hongdae | |
| **J26** | 🌙 | 💀 Surcharge de la Machine d'Inversion | Hongdae (DMC) | Fin de **Minh-Anh** |
| J27 | ☀️ | Dernier Exode : des barges tentent de traverser le Han | Ponts du Han | Sauver des civils ou les rançonner |
| **J28** | 🌅 | 💀 **Protocole Cendre** : bombardement thermobarique d'un secteur | Yongsan + secteur cible | Fin de **Simone** |
| J29 | 🌙 | La Tour « inspire » : les étages 7 à 10 s'ouvrent ensemble. Quatrième sacrifice | Tour | Dernière ascension |
| **J30** | 🌙 23h58 | 💀 **Grande Descente** | Tous | Fin de l'**Héritière**. Résolution P × IR |

**Ancres variables** : un tirage pondéré, influencé par le Chaos du Destin (§8.1), ajoute 1 à 2 événements non fixes par jour (rencontres, rumeurs, embuscades, cadeaux du Système). À haut Chaos, des **événements inédits** remplacent certaines Ancres.

### 3.7 Ouverture des étages de la Tour
| Étage | Ouverture | Règle d'étage | Gardien |
|---|---|---|---|
| 1 — Le Vestibule | J5 | Aucune arme apportée de l'extérieur ne fonctionne | Le Portier aux Mille Clés |
| 2 — La Cité Silencieuse | J10 | Tout son au-dessus d'un murmure attire le Gardien | La Mère Sourde |
| 3 — Le Marché des Âmes | J18 | Tout s'achète, même les souvenirs et les années de vie | Le Courtier |
| 4 — Le Banquet | J18 | On ne peut pas attaquer quelqu'un avec qui l'on a partagé un repas | L'Hôte Affamé |
| 5 — Le Labyrinthe Inversé | J25 | La gauche est la droite, les alliés apparaissent comme des ennemis | Le Minotaure de Miroir |
| 6 — La Forêt des Pendus | J25 | Chaque mort de la boucle actuelle y revient comme un spectre | Le Bourreau Vert |
| 7 — Le Tribunal | J29 | Les crimes commis en surface sont jugés : l'alignement donne des bonus ou des malus | Le Juge Sans Visage |
| 8 — L'Arène des Rangs | J29 | Seul le combat en duel est autorisé | Le Champion d'Hier (un double d'Elias issu de sa vie précédente) |
| 9 — Le Jardin des Fins | J29 | Le Registre est inutilisable. Les Fins s'y affichent physiquement, comme des fleurs | La Jardinière |
| 10 — Le Seuil | J29 | La règle est inconnue : elle se découvre en mourant | ??? |

Grâce à la mémoire des boucles (passages secrets, Souvenirs), Elias peut forcer un étage **avant** son ouverture officielle. Le coût est élevé (combat contre un Gardien « non éveillé » mais imprévisible).

---

## 4. La Régression (boucle temporelle)

### 4.1 Déclencheurs
1. **Mort d'Elias** (combat, événement, piège).
2. **Effacement** au jour 30 (P > 85).
3. **Rupture volontaire**, débloquée à la boucle 3 : un rituel du Registre qui « referme le livre ». Il coûte 1 Fragment d'âme. Il ne s'agit pas d'un suicide mis en scène : c'est un acte symbolique, celui de déchirer la page.
4. **Fins tragiques spécifiques** : certaines fins (Corruption totale, trahison fatale) proposent de régresser ou de valider la fin.

### 4.2 Ce qui est perdu à chaque régression
- L'inventaire, l'argent, le Refuge, les réputations, les Sceaux possédés.
- Les jauges de relation (Affinité, Confiance, Peur), ramenées à leurs valeurs de départ, avec des exceptions en §4.4.
- Les niveaux au-delà des Échos conservés.
- L'état du monde : il revient à J1, sauf les Ancrages.

### 4.3 Ce qui est conservé
| Élément | Détail |
|---|---|
| **Souvenirs** (pages du Registre) | Des drapeaux de connaissance permanents : codes, emplacements cachés, faiblesses de boss, secrets de PNJ. Ils débloquent des **raccourcis de dialogue** (« Je sais ce que tu caches sous la cathédrale ») |
| **Échos de puissance** | 30 % de l'XP gagnée au-delà du niveau 1 est conservée, avec un plafond qui monte de boucle en boucle |
| **Compétences d'âme** | Les compétences débloquées via le Registre sont permanentes (Réécriture, Lecture des Cœurs, Voile d'Ombre…) |
| **Classes gravées** | Toute classe maîtrisée à 100 % est « gravée » : elle redevient disponible dès le niveau 5 dans les boucles suivantes, et sa compétence signature peut devenir une compétence d'âme (§10.8) |
| **Titres de Premier Conquérant** | Être le premier à vaincre un Gardien inscrit le nom d'Elias dans les Archives de la Tour, de façon permanente : bonus de stats et −2 de Pression par étage |
| **Ancrages** (3 emplacements, 5 en fin de jeu) | Des choix majeurs que le joueur « grave » pour qu'ils persistent. Exemples : *les tunnels de Myeongdong sont étayés*, *le Prophète des Élus est déjà démasqué*, *Haesong ignore l'existence du Projet ARCHE*. Graver un Ancrage coûte 1 Fragment d'âme, obtenu en réécrivant une Fin |
| **Codex des Fins** | Toutes les Fins découvertes, avec leurs causes profondes connues |

### 4.4 Échos affectifs
- **Si une héroïne a atteint le Serment ou la Dévotion dans une boucle passée** : elle démarre la boucle suivante avec **Affinité +15**, des **déjà-vu** (dialogues spéciaux, rêves partagés) et, après trois boucles de Serment, des souvenirs conscients (arc « Elle se souvient »).
- **Si Elias l'a trahie, tuée, ou si un Pacte s'est fini en Ressentiment** : elle démarre avec **Peur +10** et **Confiance −10**, et fait des cauchemars à son sujet. C'est la mémoire du corps.
- **Morts répétées** : une héroïne qu'Elias a vue mourir trois fois devient un **Fantôme du Registre**. Sa Fin suivante est plus difficile à réécrire, car le destin se cristallise.

### 4.5 Dette temporelle
- Chaque régression ajoute **+1 Dette**. Elle a trois effets :
  - **Boucles 1–3** : aucun effet visible, en dehors de dialogues de déjà-vu chez les PNJ sensibles.
  - **Boucles 4–6** : le Système « remarque » Elias. Notifications glitchées et événements variables plus hostiles.
  - **Boucles 7 et plus** : des **Exécuteurs du Système** (mini-boss de chasse) apparaissent, et le Registre peut mentir sur une Fin par boucle. Cette tension finale mène à l'arc de la fin vraie.
- **Équilibrage anti-frustration** : le joueur peut désactiver les Exécuteurs avec le mode « Narratif ».

### 4.6 Confort de rejouabilité
- **Accélération des Souvenirs** : les scènes déjà vues se résument en une case webtoon, avec un choix « revivre » ou « passer ».
- **Ancre de retour** : débloquée après avoir vaincu le Gardien de l'étage 5 dans n'importe quelle boucle. Elle permet de revenir au **J15** de la boucle en cours plutôt qu'au J1. Il n'existe qu'un seul point d'ancre, et il est écrasé à chaque nouveau J15.
- **Tableau des Fins** : un écran qui récapitule les 10 Fins d'héroïnes, les causes connues et les Fins liées.

### 4.7 Mode « Une seule vie »
Pas de régression : chaque mort est une fin définitive. Option de difficulté réservée aux puristes.

---

## 5. Les 7 secteurs de Séoul

### 5.1 Carte d'adjacence
```
                 [COLLINES DU NORD]
                  /              \
        [HONGDAE–MAPO] ——— [MYEONGDONG–JONGNO]
           |      \               |
      [YEOUIDO]    \———————— [YONGSAN] ◄── LA TOUR
           \                /     ┆
            [PONTS DU HAN] ———————┘   (┆ = tunnel secret
                  |                       Gangnam → Yongsan)
              [GANGNAM]
```
- **Adjacences** : Collines ↔ Hongdae, Collines ↔ Myeongdong, Hongdae ↔ Myeongdong, Hongdae ↔ Yeouido, Hongdae ↔ Yongsan, Myeongdong ↔ Yongsan, Yeouido ↔ Ponts, Yongsan ↔ Ponts, Ponts ↔ Gangnam.
- **Passages secrets**, débloqués par des Souvenirs : le tunnel Gangnam ↔ Yongsan (ancien abri anti-aérien) et les égouts Myeongdong ↔ Ponts (réseau de Maricel).

### 5.2 Fiches secteurs

#### 🗼 YONGSAN — L'Ombre de la Tour
- **Contrôle** : **Unité 0** (militaires). Les Élus sont implantés aux portes de la Tour.
- **Danger** : ★★★★☆ — **Population** : environ 18 000 personnes, en majorité des militaires et des réfugiés sous quarantaine.
- **Ambiance** : l'ancienne garnison, Itaewon en ruines, des néons morts et des barbelés. La Tour occupe tout le ciel.
- **Nœuds clés** :
  - 🏚️ Appartement d'Elias (Itaewon), point de réveil ;
  - ⚔️ Porte de la Tour ;
  - 💬 QG de l'Unité 0 (ancienne base de Yongsan) ;
  - 💬 Musée de la Guerre (camp de réfugiés) ;
  - ⚔️ Gare de Yongsan (nid de monstres) ;
  - 💬 Parvis des Élus ;
  - 🔒 Abri anti-aérien n°7 (tunnel vers Gangnam) ;
  - 🔒 Silo d'artillerie (Protocole Cendre) ;
  - 🔒 Église d'Itaewon (cache de vivres).
- **Mécanique unique** : la **Quarantaine**. Il faut un laissez-passer, un pot-de-vin ou une infiltration pour entrer et sortir.
- **Héroïnes** : **Simone Hayes** (QG) et l'**Héritière** (étage 1 de la Tour).
- **Nuit** : les Marées frappent ici en premier, avec un palier T+1.

#### 🏢 GANGNAM — Le Royaume du Poing
- **Contrôle** : **Groupe Cheonma**. **Danger** : ★★★☆☆ (pour qui paie l'impôt) à ★★★★★ (pour les rebelles).
- **Population** : environ 140 000 personnes. C'est le secteur le plus peuplé et le plus ordonné, par la terreur.
- **Ambiance** : des tours de verre fendues, des écrans géants qui diffusent le Classement, une arène dans le COEX.
- **Nœuds clés** :
  - 💬 Tour Cheonma (QG) ;
  - ⚔️ Arène du COEX (combats classés, paris) ;
  - 💬 Marché des Vassaux (travail forcé) ;
  - 🏚️ Lotte World Tower (le toit du sniper) ;
  - 💬 Clinique clandestine de Sinsa ;
  - ⚔️ Station Gangnam (nid) ;
  - 🔒 Coffre de Cheonma ;
  - 🔒 Planque de Nadia ;
  - 🔒 Sortie du tunnel n°7.
- **Mécanique unique** : l'**Impôt du Sang**, à partir du J8. Chaque jour, payer en ressources ou en « volontaires » pour l'arène, ou bien se rebeller. L'**Arène** permet aussi de monter en rang en public.
- **Héroïne** : **Nadia Tsoi** (contractuelle de Cheonma).

#### 💹 YEOUIDO — L'Île des Comptes
- **Contrôle** : **Haesong Holdings**, sur la tour IFC. Le reste de l'île est disputé.
- **Danger** : ★★☆☆☆ (au J1) puis ★★★★☆ (après le J12).
- **Population** : environ 35 000 personnes.
- **Ambiance** : le quartier financier, l'Assemblée nationale effondrée, les cerisiers du parc devenus carnivores.
- **Nœuds clés** :
  - 💬 Tour Haesong (IFC) ;
  - 💬 Camp des survivants (le parc) ;
  - ⚔️ Hôpital Sainte-Marie de Yeouido ;
  - 🏚️ Assemblée nationale (ruines, archives) ;
  - 💬 Laboratoires Haesong Bio ;
  - ⚔️ Parc Hangang ouest ;
  - 🔒 Bunker sous le parking B6 (Souvenir n°1) ;
  - 🔒 Salle du conseil d'administration (Projet ARCHE).
- **Mécanique unique** : la **Bourse des Ressources**. Les prix fluctuent selon les événements, et Elias peut spéculer grâce à ses connaissances du futur. C'est le chemin naturel du Mercenaire.
- **Héroïnes** : **Park Seo-Yeon** (camp, hôpital) et **Yoon Hae-in** (tour Haesong).

#### 🎤 HONGDAE–MAPO — Les Écrans et le Bruit
- **Contrôle** : **Mirae Dynamics**, dans la Digital Media City (DMC). Les rues étudiantes sont libres mais surveillées.
- **Danger** : ★★★☆☆. **Population** : environ 60 000 personnes.
- **Ambiance** : murs tagués, scènes de concert improvisées, drones de surveillance, câbles partout.
- **Nœuds clés** :
  - 💬 Campus Mirae (DMC) ;
  - 💬 Scène de la Rue des Clubs ;
  - ⚔️ Université Hongik (zone de rafle) ;
  - 💬 Studio d'enregistrement abandonné (refuge d'Aoi) ;
  - 🏚️ Stade de la Coupe du Monde (camp) ;
  - ⚔️ Parc Haneul (nid) ;
  - 🔒 Laboratoire Sous-niveau 9 (Machine d'Inversion) ;
  - 🔒 Serveurs Mirae (données du Système).
- **Mécanique unique** : la **Surveillance**. Une jauge de suivi monte avec chaque action visible ; au-delà de 100, les drones et les chasseurs de Mirae traquent Elias. Les actions de Loup y sont avantagées.
- **Héroïnes** : **Aoi Tsukishiro** et **Dr. Tran Minh-Anh**.

#### ⛪ MYEONGDONG–JONGNO — Le Cœur Neutre
- **Contrôle** : le **Sanctuaire**, dans la cathédrale. Le **Marché Souterrain** appartient aux Rats du Han.
- **Danger** : ★★☆☆☆, puis ★★★★★ lors du siège du J22. **Population** : environ 50 000 personnes.
- **Ambiance** : la cathédrale illuminée de bougies, les ruelles commerçantes reconverties en troc, les palais de Jongno envahis par la végétation de la Tour.
- **Nœuds clés** :
  - 💬 Cathédrale (Sanctuaire, Sommet du J13) ;
  - 💬 Marché Souterrain (Rats) ;
  - 🏚️ Palais Gyeongbokgung (ruines, pierre-relique) ;
  - 💬 Tour N Seoul (vigie) ;
  - ⚔️ Station Euljiro (nid) ;
  - 💬 Atelier du forgeron Gu ;
  - 🔒 Tunnels de l'ère coloniale (réseau de Maricel) ;
  - 🔒 Crypte du Sanctuaire.
- **Mécanique unique** : la **Trêve**. La violence ouverte y est interdite jusqu'au J22 : se battre fait chuter la réputation auprès de tous. C'est le lieu des négociations, des alliances et des rumeurs.
- **Héroïne** : **Maricel Dizon** (Marché Souterrain).

#### 🌉 PONTS DU HAN — Le Fleuve Noir
- **Contrôle** : **Consortium Longwei**, qui tient les ponts, les barges et les pompes à eau. Les Rats du Han occupent les piles des ponts.
- **Danger** : ★★★☆☆. **Population** : environ 25 000 personnes, en partie flottante.
- **Ambiance** : des ponts transformés en forteresses-péages, des barges-casinos, et un fleuve devenu noir où quelque chose de très grand nage.
- **Nœuds clés** :
  - 💬 Pont Banpo (péage de Longwei) ;
  - 💬 Barge-casino du *Dragon Pâle* (QG de Longwei) ;
  - 💬 Station de pompage de Ttukseom ;
  - 💬 Piles du pont Mapo (camp des Rats) ;
  - ⚔️ Îlot Nodeul (nid aquatique) ;
  - 🏚️ Quais du Dernier Exode ;
  - 🔒 Épave du ferry *Hangang 3* (cargaison d'armes) ;
  - 🔒 Grotte sous le pont Seongsu.
- **Mécanique unique** : les **Péages**. Chaque traversée coûte de l'argent, un service ou un passage en force. Le contrôle de l'eau, à partir du J11, influence la Défense de tous les secteurs.
- **Héroïne** : **Long Xiaoyu**.

#### 🏯 COLLINES DU NORD — Les Vieilles Maisons
- **Contrôle** : la **Maison Baek** (Baekho Group), retranchée dans les manoirs de Seongbuk-dong et sur les pentes du Bukhansan.
- **Danger** : ★★☆☆☆ puis ★★★★★ à partir du J16. **Population** : environ 15 000 personnes.
- **Ambiance** : des manoirs traditionnels, des forêts de pins, des temples bouddhistes et des murailles de l'ère Joseon. C'est l'unique endroit encore beau.
- **Nœuds clés** :
  - 💬 Domaine Baek (dojo, salle des ancêtres) ;
  - 💬 Temple Jingwansa (moines éveillés) ;
  - ⚔️ Forteresse de Bukhansan (nid de bêtes) ;
  - 🏚️ Ancienne Maison Bleue (archives présidentielles) ;
  - 💬 Village de réfugiés de Buam-dong ;
  - 🔒 Sanctuaire de l'Épée scellée ;
  - 🔒 Source chaude cachée (lieu d'événement romantique).
- **Mécanique unique** : l'**Honneur**. Les promesses faites ici sont contraignantes (le Système les enregistre) et les duels formels sont possibles. Rompre une promesse inflige le malus « Parjure » dans tout le secteur.
- **Héroïne** : **Baek Ryeon**.

---

## 6. Les 5 clans-chaebols & factions

### 6.1 Le Conseil des Cinq Sceaux
- **Au J3**, le Système remet un **Sceau** (un artefact de la Tour) aux 5 groupes qui comptent le plus d'éveillés. Ces groupes sont des conglomérats d'avant la catastrophe : leur argent, leurs bâtiments et leurs milices privées leur ont donné une longueur d'avance.
- **Pouvoirs d'un Sceau** :
  - le Système reconnaît son porteur comme **Seigneur de secteur** : il peut lever des impôts, et les quêtes territoriales lui reviennent ;
  - bouclier de +20 de Défense sur le secteur ;
  - accès prioritaire aux étages.
- **Le Sixième Sceau** : un Sceau peut être **volé, gagné en duel, hérité ou offert**. Elias peut en obtenir un et devenir la sixième puissance. C'est central pour les voies du Tyran et du Héros-bâtisseur. Il peut aussi **détruire** un Sceau (P +8) ou **réunir** des Sceaux par des pactes (P −4 par pacte).

### 6.2 Hiérarchie de départ (Puissance au J3)
| Rang | Clan | Puissance | Secteur | Sceau | Tendance |
|---|---|---|---|---|---|
| 1 | **Groupe Cheonma** (天魔) | 92 | Gangnam | Sceau du Poing | ↑ Actes I et II, ↓ si Baek tient |
| 2 | **Haesong Holdings** (海松) | 81 | Yeouido | Sceau de la Balance | → stable, effondrement au J21 |
| 3 | **Consortium Longwei** (龍威) | 74 | Ponts du Han | Sceau du Courant | ↑ au J11 (Guerre de l'Eau) |
| 4 | **Mirae Dynamics** (未來) | 68 | Hongdae–Mapo | Sceau de l'Œil | ↑↑ Acte III (drones) |
| 5 | **Maison Baek** (白虎) | 55 | Collines du Nord | Sceau du Tigre Blanc | ↓ chute au J17 sans intervention |

- La **Puissance** (0–100) agrège les éveillés, le territoire, les ressources et les rangs.
- Elle fluctue chaque jour et peut être consultée dans le Registre, onglet *Sceaux*.

### 6.3 Hiérarchie interne commune
Tous les clans suivent la même structure, ce qui facilite la production et les mécaniques d'infiltration et d'ascension :

```
SEIGNEUR (porteur du Sceau)
 └─ CONSEIL / HÉRITIERS (2–4 personnes) ......... cibles politiques, alliances matrimoniales
     └─ EXÉCUTEURS (3–5 éveillés de rang A–S) ... mini-boss, peuvent être retournés
         └─ CAPITAINES (rang B–C) ............... chefs de nœuds
             └─ CHASSEURS (rang C–F) ........... troupes
                 └─ VASSAUX (non-éveillés) ..... population, travail, otages
```

- Elias peut **entrer** dans un clan (recrue de rang F), puis **gravir les échelons** par des missions ou des duels.
- Il peut aussi **usurper** : tuer ou destituer le Seigneur avec le soutien d'au moins 2 Exécuteurs, ce qui lui donne le Sceau.
- Il peut enfin **vassaliser** un clan entier : le soumettre de l'extérieur, en Seigneur du Sixième Sceau.

### 6.4 Fiches des clans

#### 1) Groupe Cheonma — « La force fait le droit »
- **Avant J0** : BTP, défense et sécurité privée. **Seigneur** : le **Président Cheon Mu-gyeong** (64 ans, rang S, classe *Roi Démon*), un patriarche colossal qui ne s'est jamais excusé de sa vie.
- **Doctrine** : méritocratie de la violence. Le rang du Système est la seule loi.
- **Spécialité** : les éveillés de mêlée les plus puissants de la ville. Arène de sélection.
- **Exécuteurs notables** :
  - **Cheon Tae-ju**, le fils héritier, rang A, promis à Ryeon ;
  - **« Le Boucher » Ma Dong-gil** ;
  - **Nadia Tsoi**, contractuelle externe, Exécutrice n°3.
- **Agenda** : Acte I, conquérir Gangnam. Acte II, l'Impôt du Sang. Acte III, absorber la Maison Baek par le mariage, ou par la guerre au J16–17.
- **Ce qui le motive en secret** : Cheon Mu-gyeong sait qu'il mourra au J30 quoi qu'il arrive (le Système le lui a dit). Il veut seulement laisser une dynastie.
- **Elias peut** s'y faire recruter par l'arène, l'affronter, ou retourner Tae-ju contre son père.

#### 2) Haesong Holdings — « Tout a un prix »
- **Avant J0** : finance, médias et biotech. **Seigneur** : la **Présidente Yoon Hae-in** (héroïne, §12.2).
- **Doctrine** : gouverner par la dette. Haesong prête des vivres, des soins et des armes contre des contrats que le Système fait respecter.
- **Spécialité** : les classes de *Contractant*, ou comment changer la monnaie en pouvoir ; la Bourse des Ressources.
- **Exécuteurs notables** :
  - **Vice-président Nam Gi-seok**, le traître du J21 ;
  - **Agent Shin**, garde du corps muet.
- **Agenda** : contrôler l'économie de la ville et effacer les traces du **Projet ARCHE**.
- **Secret** : Haesong Bio étudiait des signaux venus du sous-sol de Yongsan depuis **3 ans**. Le Projet ARCHE a peut-être « appelé » la Tour.

#### 3) Consortium Longwei — « Le courant emporte tout »
- **Avant J0** : logistique portuaire et fluviale, investissements sino-coréens, et une façade légale de triade. **Seigneur** : le **Vieux Long**, malade. L'héritière **Long Xiaoyu** (héroïne, §12.5) dirige de fait.
- **Doctrine** : contrôler les flux (eau, passage, marchandises). Neutralité commerciale.
- **Spécialité** : poisons, contrebande, combattants aquatiques ; les barges et les péages.
- **Exécuteurs notables** :
  - **Oncle Fang**, conseiller fidèle au vieux maître ;
  - **Les Trois Lotus**, des assassins jumeaux.
- **Agenda** : la Guerre de l'Eau au J11, pour devenir indispensable. En coulisses, la mutinerie du J19 se prépare contre Xiaoyu.

#### 4) Mirae Dynamics — « Le futur se calcule »
- **Avant J0** : intelligence artificielle, robotique, divertissement (une agence d'idols). **Seigneur** : le **PDG Jang Woo-hyun** (47 ans, rang B), un technocrate charismatique et un homme creux.
- **Doctrine** : rationaliser l'apocalypse. Les humains sont des données.
- **Spécialité** :
  - les drones (dès le J18) ;
  - l'analyse du Système ;
  - le **Chant d'Aoi**, utilisé comme outil de contrôle des foules ;
  - la scientifique **Dr. Tran Minh-Anh** (héroïne, §12.9).
- **Agenda** : percer le code du Système et construire la **Machine d'Inversion**, une régression artificielle pour le PDG.
- **Secret** : Mirae a détecté les **anomalies temporelles** autour d'Elias dès la boucle 2, et elle le traque.

#### 5) Maison Baek — « L'honneur ne se vend pas »
- **Avant J0** : vieux chaebol traditionnel (hôtellerie de luxe, culture), héritier d'une lignée d'escrimeurs. **Seigneur** : **Maître Baek Jin-ho** (71 ans, rang A, *Sabre du Tigre Blanc*), mourant.
- **Doctrine** : la protection des siens, la parole donnée, le code martial.
- **Spécialité** : l'escrime d'éveil, les moines-guerriers alliés de Jingwansa, les promesses enregistrées par le Système.
- **Exécuteurs notables** :
  - **Baek Ryeon**, héritière (héroïne, §12.3) ;
  - **Grand-mère Song**, intendante et ancienne espionne.
- **Agenda** : survivre. La Maison est la plus faible des cinq, et le mariage d'alliance avec Cheonma est la solution désespérée de Jin-ho.

### 6.5 Matrice des relations entre clans (au J3)
| | Cheonma | Haesong | Longwei | Mirae | Baek |
|---|---|---|---|---|---|
| **Cheonma** | — | Alliance de façade | Rivalité (ponts) | Mépris | Prédation |
| **Haesong** | Créancier | — | Concurrence féroce | Partenariat secret (ARCHE) | Indifférence |
| **Longwei** | Méfiance | Haine commerciale | — | Contrebande de pièces | Respect ancien |
| **Mirae** | Fournisseur de drones | Complice | Client | — | Convoitise (Sceau) |
| **Baek** | Peur et haine | Dette ancienne | Amitié ancienne | Mépris | — |

### 6.6 Factions autonomes (sans Sceau)
| Faction | Secteur | Chef | Rôle | Interaction clé |
|---|---|---|---|---|
| **Le Sanctuaire** | Myeongdong | Mère Agatha Seo (67 ans) | Soins, refuge, garante de la Trêve | Allié naturel du Héros. Garde une crypte et sa relique |
| **Les Rats du Han** | Ponts du Han, Myeongdong (sous-sol) | « Grand-père Pigeon », puis **Maricel** | Contrebande, information, tunnels | Allié naturel du Loup et du Mercenaire |
| **L'Unité 0** | Yongsan | **Cdt Simone Hayes** | Ordre militaire, quarantaine, canal radio vers l'extérieur | Tient le Protocole Cendre |
| **Les Élus** | Yongsan, étages 1 à 3 | **Le Prophète** (identité cachée : un personnage déjà connu, §16.3) | Culte de la Tour, sacrifices (P +5) | Antagonistes. Veulent l'Héritière |
| **Les Indépendants** | Partout | — | Survivants non affiliés, recrutables pour le Refuge | Population du Refuge |

### 6.7 Secret de l'Unité 0 : le canal extérieur
L'Unité 0 reçoit, par intermittence, des messages venus de l'extérieur du Voile. Le monde n'a pas disparu, et il a fixé un ultimatum : **si la Tour n'est pas contenue au J28, un secteur sera « stérilisé »** (Protocole Cendre). C'est Simone qui détient le code.

---

## 7. Carte & navigation

Principe : **trois couches emboîtées**. Chaque couche est riche en décisions, aucune n'est un couloir vide.

```
COUCHE 1 — CARTE STRATÉGIQUE (Séoul + colonne de la Tour)
   │  destination, temps, Pression, Sceaux, marqueurs de Fin
   ▼
COUCHE 2 — CARTE DE SECTEUR (graphe de 10 à 18 nœuds)
   │  déplacement nœud à nœud, brouillard, rencontres, nœuds cachés
   ▼
COUCHE 3 — SCÈNE (diorama 2.5D illustré + hotspots)
      dialogues, fouille, combat, scènes clés en « scroll webtoon »
```

### 7.1 Couche 1 — Carte stratégique
- **Visuel** : une carte illustrée de Séoul en ruines vue de dessus, avec la Tour au centre en vue latérale. Cliquer sur la Tour fait pivoter la caméra vers la colonne des étages (§3.7).
- **Informations affichées** :
  - couleur du clan qui contrôle chaque secteur ;
  - Défense du secteur ;
  - niveau de danger ;
  - icônes de rumeurs ;
  - **marqueurs de Fin** (un crâne avec un compte à rebours) ;
  - jauge de **Pression** en bordure d'écran ;
  - calendrier des 30 jours, avec les Ancres connues.
- **Mobile** : la même carte, avec pinch-zoom et des panneaux en tiroir.

### 7.2 Couche 2 — Carte de secteur
- **Nœuds** :
  - 🏚️ Lieu ;
  - ⚔️ Menace ;
  - 💬 PNJ ou camp ;
  - 🔒 Caché : révélé par une compétence, une réputation, un **Souvenir** ou la phase de la journée ;
  - 🏠 Refuge revendicable.
- **Propriétés des chemins** : *bruyant* (risque de rencontre), *exposé* (témoins, §8.3), *bloqué* (dégager, contourner ou payer), *surveillé* (Surveillance de Mirae, Péage de Longwei).
- **Brouillard de guerre** : dissipé par l'exploration, les éclaireurs ou les informations achetées.
- **État persistant pendant la boucle** : les nœuds tombent, changent de clan, deviennent des nids.

### 7.3 Couche 3 — Scène
- **Diorama 2.5D semi-fixe** : une illustration en couches avec parallaxe, des pans et zooms de caméra, et des **hotspots** cliquables.
- **Scènes clés en scroll webtoon vertical** (révélations, boss, romances, morts). C'est la signature visuelle du jeu.
- **Actions contextuelles** selon la voie : `Fouiller`, `Intimider`, `Voler`, `Soigner`, `Exécuter`, `Recruter`, `Espionner`, `Lire la Fin`.

### 7.4 Production
- **Un secteur** = 1 illustration de graphe + 10 à 18 dioramas, avec des variantes : jour/nuit, intact/détruit, contrôle de clan.
- **Variantes par superposition de calques** (affiches, barricades, cadavres, néons), pour limiter le coût d'illustration.

---

## 8. Alignement & conséquences

### 8.1 Deux axes visibles et un axe caché
```
                    LIEN (collectif)
                         ▲
        HÉROS PROTECTEUR │  TYRAN / SEIGNEUR
        (refuge, serment)│  (empire, cour, peur)
 PROTÉGER ◄──────────────┼──────────────► DOMINER
        LOUP SOLITAIRE   │  MERCENAIRE / VOLEUR
        (ombre, survie)  │  (contrats, butin)
                         ▼
                   SOLITUDE (solo)
```
- **Protéger ↔ Dominer** (−100 à +100) et **Lien ↔ Solitude** (−100 à +100).
- **Ordre ↔ Chaos du Destin** (caché) : combien de Fins Elias a réécrites et à quel point il utilise la Réécriture. Un Chaos élevé rend le Registre moins fiable et fait apparaître des événements inédits ; à partir de la boucle 7, il attire les Exécuteurs du Système.
- Les voies sont **émergentes**, et les profils hybrides sont valides (un Robin des Bois est un Loup protecteur, un Roi-Mercenaire un Tyran transactionnel).

### 8.2 Les actes, pas les dialogues
- **Intensité des actes** :
  - *mineur* (±2) ;
  - *majeur* (±10) ;
  - *de bascule* (±25, déclenche un événement).
- Les répliques de dialogue ne pèsent que ±1.

### 8.3 Réputation locale & témoins
- **Réputation propre à chaque secteur et à chaque clan** : Inconnu / Respect / Crainte / Haine / Vénération.
- **Un acte sans témoin ne modifie pas la réputation.** Les rumeurs avancent d'un secteur par jour.
- **Double vie possible** : saint à Myeongdong, boucher à Gangnam. Être démasqué déclenche un événement de thriller.

### 8.4 Titres du Système
| Seuil atteint | Titre | Débloque |
|---|---|---|
| Protéger ≥ 40, Lien ≥ 40 | **Bouclier des Sans-Voix** | Aura de protection, recrutement de civils, Refuge niveau 2 |
| Dominer ≥ 40, Lien ≥ 40 | **Seigneur de Guerre** | Commandement par la peur, impôt, exécutions spectaculaires |
| Solitude ≥ 50 | **Ombre Sans Nom** | Furtivité avancée, assassinat hors combat, nœuds cachés |
| Dominer ≥ 20, Solitude ≥ 30 | **Chacal** | Contrats, vol, marché noir, double jeu |
| Possède un Sceau | **Sixième Seigneur** | Pouvoirs de Sceau, voix au Conseil |
| Chaos ≤ −60 | **Anomalie** | Manipulation du temps, mais traqué par le Système |

### 8.5 Changer de voie : inertie, arcs de bascule et Refuge
- **Inertie** : au-delà de ±50 sur un axe, les points de retour sont divisés par 2.
- **Mémoire permanente des PNJ** pendant la boucle.
- **Arcs de bascule** :
  - *Rédemption* : Tyran → Héros ;
  - *Chute* : Héros → Tyran ;
  - *Retrait* : → Loup.
- **Le Refuge reflète la voie** :
  - Héros : **Sanctuaire** ;
  - Tyran : **Forteresse** ;
  - Loup : **réseau de planques** ;
  - Mercenaire : **Comptoir**.

### 8.6 Exemple : le Camp de Yeouido (J4)
| Choix | Effet immédiat | Conséquence |
|---|---|---|
| Défendre et organiser le camp | Protéger +10, Lien +10, coûte 2 jours | Avant-poste du Refuge. **Seo-Yeon** recrutable |
| « Protéger » contre un tribut | Dominer +10, ressources +++ | Camp vassal. **Pacte de Vassalité** avec Seo-Yeon (§11.4), révolte au J15 |
| Voler les vivres la nuit | Dominer +5, Solitude +10 | Le camp tombe au J6, Seo-Yeon disparaît du Registre |
| Vendre la position du camp à Cheonma | Dominer +10, argent +++ | Seo-Yeon devient vassale de Cheonma (sous-route de libération) |
| Ignorer le camp | — | La Fin du J12 survient plus tôt, au J6 |

---

## 9. Moteur de combat

### 9.1 Format
- **Deux grilles 3×3 face à face**, avec trois lignes : avant, milieu, arrière.
  - Les unités de l'avant protègent celles de derrière.
  - Les attaques ont une **portée** (mêlée, distance, perçante, zone).
- **Initiative en frise de type CTB** (*Conditional Turn-Based*), visible en haut de l'écran. Les actions lourdes retardent le prochain tour de leur auteur.
- **Ressources** : PV, Mana du Système et **Jauge d'Éveil**. La jauge se remplit en subissant des coups et en protégeant des alliés ; pleine, elle déclenche une **Ultime** avec cut-in en cases manhwa.
- **Décor interactif** : voitures, plafonds, civils à protéger, eau, néons.
- **Escouade** : Elias et 3 alliés actifs ; 2 réservistes peuvent être permutés pour 1 tour.

### 9.2 Le Registre en combat
- **Pressentiment** : les intentions des ennemis sont visibles. Au niveau 1, seules celles des deux premières cases ennemies apparaissent ; au niveau maximal, toute la grille.
- **Réécriture** : 1 à 3 charges par combat. Elle annule un événement et rejoue le tour, mais augmente le Chaos.
- **Boss à Règles** : leur règle cachée se découvre souvent au prix d'une mort dans une boucle précédente.

### 9.3 Résolution hors combat
- **Intimider** : Peur contre Volonté ennemie.
- **Négocier / Soudoyer** : Charisme ou Argent.
- **Assassiner avant le combat** : furtivité.
- **Fuir** : coûte du temps.

### 9.4 Rôles de grille (référence pour les héroïnes)
| Rôle | Ligne | Exemples |
|---|---|---|
| Lame (burst mêlée) | Avant | Ryeon, Elias (Tyran) |
| Rempart | Avant | Simone (forme blindée), Elias (Héros) |
| Agile / voleur | Avant ou milieu (mobile) | Maricel, Elias (Loup) |
| Contrôle / poison | Milieu | Xiaoyu |
| Tireur | Milieu ou arrière | Simone, Nadia |
| Soigneur | Arrière | Seo-Yeon |
| Support / chant | Arrière | Aoi |
| Commandement / contrat | Arrière | Hae-in |
| Technomancie / invocation | Arrière | Minh-Anh |
| Mage spatial / temporel | Flexible | Héritière |

### 9.5 Statistiques
- **FOR** (force), **AGI** (agilité), **PER** (perception), **VOL** (volonté), **CHA** (charisme).
- **Corruption** : cachée, monte avec les pouvoirs des Élus.
- **Endurance** : liée à la Fatigue.

---

## 10. Fiche du protagoniste — Elias Kang

### 10.1 Identité
| Champ | Valeur |
|---|---|
| **Nom** | **Elias Kang** (강엘리아스). Les militaires l'appelaient « Kang ». Les Rats l'appellent « le Revenant » |
| **Âge** | 29 ans |
| **Origine** | Métis : père français d'origine martiniquaise (Julien Moreau, ancien ingénieur, reparti en France quand Elias avait 8 ans), mère coréenne (Kang Mi-sook, couturière à Itaewon, morte quand il avait 14 ans) |
| **Nationalités** | Coréenne et française. Il parle coréen, français, anglais, et des rudiments d'arabe et de wolof appris sur le terrain |
| **Taille / poids** | 1m84 / 86 kg |
| **Profession avant J0** | Recouvreur de dettes pour une société de prêt façade de Longwei, après 6 ans comme contractuel dans une société militaire privée (Sahel, Golfe) |
| **Classe d'origine** (hors Système, permanente) | **Vétéran-Recouvreur** (§10.8) |
| **Classe Système visible** | **Porteur (F)**, le rang le plus méprisé, qui cache la capacité de « porter » d'autres classes (§10.8) |
| **Classe réelle (cachée)** | **Lecteur des Fins (EX)**, révélée à la fin de l'Acte I ou à la boucle 2 |

### 10.2 Background
- **Enfance à Itaewon (Yongsan)**. Un enfant métis dans un quartier de bases militaires, de bars et de regards. Il apprend tôt deux choses : frapper le premier, et se taire pour protéger sa mère. Elle lui coud ses vêtements et lui répète **« 살아남아 » (« survis »)**. À 12 ans, il découvre la vérité brute : couturière le jour, sa mère **se prostitue la nuit** dans les bars d'Itaewon pour rembourser les dettes laissées par Julien. Il ne lui en a jamais parlé.
- **14 ans**. Sa mère meurt d'un cancer non soigné, faute d'argent. Son père ne vient pas à l'enterrement. Elias passe chez une tante, puis à la rue, puis dans les salles de boxe.
- **19–25 ans**. Recruté par une société militaire privée grâce à son passeport français et à sa carrure. Il en garde des réflexes, des cicatrices, et une mission au Sahel qu'il ne raconte jamais. Sur ordre du client, son unité a « nettoyé » un village soupçonné d'abriter des djihadistes. **Elias a tiré.** 31 morts, dont des femmes. Il connaît le nom du village et ne le prononce jamais.
- **25–29 ans**. Retour à Séoul, endetté. Il « récupère » de l'argent pour Longwei, ce qui lui vaut une réputation de type calme et dangereux qui ne frappe que quand c'est nécessaire. Il a cassé des doigts, et un débiteur s'est pendu le lendemain de sa visite.
- **Statut & passé intime** : **célibataire**. **Expérimenté** : des liaisons brèves, des nuits payées dans les bars d'Itaewon, jamais rien de durable. Il refuse qu'on l'attende.
- **Première vie (avant la régression)** :
  - éveillé **Porteur (F)**, il survit par la ruse, sans rien sauver ni personne ;
  - au **J20**, il rencontre l'**Héritière** à l'étage 1 et décide pour la première fois de protéger quelqu'un ;
  - il la porte jusqu'au sommet de l'étage 10 ;
  - au **J30 à 23h58**, il est abattu d'une balle dans la nuque par une silhouette au fusil (Nadia, ce qu'il découvrira) ;
  - en mourant, l'Héritière pose la main sur ses yeux, et il se réveille au J1.
- **Ce qu'il ignore au départ** : pourquoi elle l'a choisi, qui a payé le tireur, et ce qu'est vraiment le Registre.

### 10.3 Fiche physique & charadesign

| Champ | Description |
|---|---|
| **Taille / poids** | **1m84 / 86 kg** |
| **Morphologie** | Grand et dense. Épaules larges (environ 50 cm de carrure), dos en V, taille fine, jambes longues. Une musculature **sèche et fonctionnelle** de combattant (boxe, terrain militaire), avec des veines saillantes aux avant-bras et aux mains, pas un physique de bodybuilder. Environ 12 % de masse grasse : abdominaux visibles sans être sculptés |
| **Posture & gestuelle** | Légèrement voûté au repos, comme un fauve qui économise ses forces. Il se redresse d'un coup en combat ou quand il se met en colère. Il s'adosse aux murs pour garder une vue sur les sorties. Il fait tourner sa montre cassée entre ses doigts quand il réfléchit, et sourit d'un seul côté |
| **Peau** | Brun clair, **caramel chaud** à sous-ton doré. Elle bronze vite, et sous les néons elle prend des reflets cuivrés |
| **Visage** | Ovale allongé aux angles nets : mâchoire carrée bien dessinée, menton légèrement fendu, **pommettes hautes** héritées de sa mère, nez droit au bout un peu large (de son père), lèvres pleines au pli ironique. **Barbe de trois jours** soigneusement entretenue le long de la mâchoire |
| **Yeux** | En amande, légèrement tombants aux coins extérieurs, sous des sourcils épais et droits. Iris **noisette ambré** (brun clair et or vert au centre), cils noirs épais. Regard mi-clos, évaluateur, souvent amusé. **Registre activé** : iris **or pur**, un anneau d'horloge tourne autour des pupilles, les sclères se teintent d'un léger halo doré |
| **Cheveux** | Noirs, **épais et bouclés** (boucles serrées de type 3B–3C). Côtés et nuque coupés court en dégradé, dessus plus long (environ 7 cm). Quelques boucles tombent sur le front et sur le sourcil gauche. Ils frisent davantage sous la pluie, un détail repris dans les CG |
| **Mains** | Grandes, articulations marquées et calleuses (boxe, armes), une phalange de l'auriculaire droit déformée par une vieille fracture, ongles courts |
| **Signes particuliers** | Cicatrice verticale qui fend le **sourcil gauche** (un éclat d'obus, au Sahel) · brûlure en plaque sur l'**avant-bras droit** · impact de balle cicatrisé sur le **flanc gauche** (sous les côtes) · fine cicatrice de couteau en travers de la **paume gauche** · tatouage **살아남아** (« survis ») sur l'avant-bras intérieur gauche, dans l'écriture de sa mère · grain de beauté sous l'oreille droite |
| **Voix** | Baryton grave, posé, légèrement rauque. Il parle peu et bas, et son accent coréen de Séoul se teinte de français quand il jure. Casting de voix IA : timbre chaud et grave, débit lent, souffle audible (§18.3) |
| **Style vestimentaire habituel** | Utilitaire et sombre : bomber ou veste militaire, t-shirts unis gris ou noirs, cargos, bottes de combat. Aucun bijou en dehors de la **montre militaire cassée** (arrêtée à 23h58) et, sur la voie du Tyran, du pendentif du Sceau. Il retrousse toujours ses manches jusqu'aux coudes |
| **Palette de couleurs (DA)** | Noir, anthracite, orange brûlé (la doublure du bomber), or (le Registre) |
| **Odeur** (texte et dialogues) | Cuir, poudre, savon bon marché. Plusieurs héroïnes le remarquent |

- **Effets visuels du Registre** : des glyphes dorés courent le long des veines du cou et des mains. En Éveil EX, un halo de « pages » lumineuses tourbillonne autour de lui.
- **Tenues** :

| Tenue | Description |
|---|---|
| **Base (J1)** | Blouson bomber noir usé (doublure orange), t-shirt gris anthracite, pantalon cargo tactique noir, bottes de combat, montre militaire cassée (arrêtée à 23h58) |
| **Héros** | Long manteau gris perle à col montant, brassard blanc du Refuge, gants renforcés, plastron léger |
| **Tyran** | Manteau noir long à épaulettes et col haut, chemise noire ouverte, chaîne et Sceau en pendentif, gants de cuir rouge sombre |
| **Loup** | Capuche sombre, demi-masque respiratoire, harnais de couteaux, bandages aux mains |
| **Mercenaire** | Veste tactique sable, harnais porte-chargeurs, bandana, lunettes de tir relevées sur le front |
| **Détente / Refuge** | Débardeur noir, jogging, pieds nus. Tenue des scènes intimes et des scènes de quotidien |
| **Éveil EX** | Version « dorée » de la tenue de voie, avec des glyphes du Registre en motif lumineux |

### 10.4 Personnalité (de départ, façonnée par le joueur)
- **Base** : laconique, observateur, humour noir à froid. Méfiant envers les institutions, loyal envers les rares personnes qu'il respecte.
- **Blessure** : l'ordre suivi au Sahel. Il se sait capable du pire, et c'est pour cela qu'il a peur de s'engager.
- **Ce qui le fait réagir** :
  - les enfants en danger, car c'est son point faible ;
  - l'injustice économique, car c'est la mort de sa mère ;
  - la condescendance raciste, qui provoque une réaction froide et mémorable.
- **Ressorts selon la voie** :
  - Héros : sa blessure devient sa promesse ;
  - Tyran : « plus jamais personne ne décidera à ma place » ;
  - Loup : « on meurt toujours seul, autant vivre seul » ;
  - Mercenaire : « tout le monde a un prix, moi aussi, mais je le fixe ».

### 10.5 Statistiques initiales (J1, boucle 1)
| FOR | AGI | PER | VOL | CHA | Endurance | Corruption |
|---|---|---|---|---|---|---|
| 12 | 14 | 15 | 13 | 11 | 4 phases | 0 |

- **Compétences de base** : *Combat rapproché (PMC) Niv.2*, *Armes à feu Niv.2* (inutilisables dans la Tour, règle de l'étage 1), *Intimidation Niv.1*, *Endurance du Porteur* (+50 % de capacité d'inventaire, la seule bonne surprise apparente du rang F).
- Le détail des classes et des compétences actives de combat est en §10.8 et §10.9.

### 10.6 Le Registre des Fins : capacités initiales et progression
| Capacité | Disponibilité | Effet |
|---|---|---|
| **Lecture des Fins** (Niv.1) | J1 | Après une interaction avec un PNJ nommé, révèle sa Fin **partielle** (date + lieu). La cause se complète par des indices ou d'une boucle à l'autre |
| **Archives** | J1 | **5 Souvenirs initiaux** (voir ci-dessous) |
| **Pressentiment** (Niv.1) | J1 | En combat, intentions des 2 premières cases ennemies |
| **Écho de Mort** (passif) | J1 | À chaque mort : +1 page de Souvenir et conservation des Échos |
| **Réécriture** | Après la 1re régression | 1 charge par combat (jusqu'à 3) |
| **Lecture des Cœurs** | Réécrire 2 Fins | Affiche les vraies jauges des héroïnes, Masque compris |
| **Voile d'Ombre** | Titre Ombre ou boucle 3 | Cache le rang et la classe aux yeux du Système et des PNJ |
| **Ancre de retour** | Gardien de l'étage 5 vaincu | Revenir au J15 au lieu du J1 |
| **Lecture inverse** | Fin de jeu | Lire la Fin… de la Tour elle-même |

**Les 5 Souvenirs initiaux :**
1. *« Il y a un bunker sous le parking B6 de la tour IFC. Des vivres pour 200 personnes. »*
2. *« La médecin du camp de Yeouido… je l'ai vue se transformer. J12, au crépuscule. »*
3. *« Le Portier de l'étage 1 ne peut ouvrir qu'une porte à la fois. Il ment toujours sur la troisième. »*
4. *« Elle dort à l'étage 1, derrière la porte qui n'a pas de serrure. Je l'ai trouvée trop tard, au J20. »*
5. *« Le canon du fusil brillait sur le toit, à gauche. Un reflet blanc. Des cheveux blancs ? »* (Nadia, flou)

### 10.7 Profil mature (18+)

| Champ | Valeur |
|---|---|
| Orientation | Hétérosexuel |
| Expérience | Adulte expérimenté, relations passées brèves. Aucune relation durable depuis la PMC |
| Physique intime (CG) | Proportions cohérentes avec la fiche physique : corps athlétique, cicatrices visibles dans les scènes (le flanc, la paume) et le tatouage, qui servent de points d'ancrage narratifs (« Raconte-moi celle-là ») |
| Tempérament intime, selon la voie | **Héros** : tendre, protecteur, attentif, il laisse l'héroïne mener. **Tyran** : dominant, possessif, d'une autorité froide. Les scènes de **Pacte** (§11.4) sont sombres et psychologiques, sans violence physique. **Loup** : rare, intense, distant après coup, la vulnérabilité comme enjeu. **Mercenaire** : joueur, taquin, séduction par le défi et le marchandage |
| Évolution | Le tempérament se module par héroïne : chaque partenaire « révèle » une facette différente d'Elias. Sur la voie du Tyran, une héroïne en Dévotion peut faire ressurgir sa tendresse, et Elias doit choisir de la montrer ou de la cacher |
| Paliers de scènes | **P1** Romance / Allégeance · **P2** Intime · **P3** Explicite. Tous sont intégrés de base, en CG HD fixes et doublés (§18) |
| Monologue intérieur | Dans les scènes de Pacte, des cases de pensée montrent le doute ou la jouissance du pouvoir selon l'alignement. Elles nourrissent l'arc moral d'Elias |

### 10.8 Système de Classes

#### 10.8.1 Les quatre couches de classe
| Couche | Nature | Pour Elias | Persistance entre boucles |
|---|---|---|---|
| **Classe d'origine** | Ce que la personne était avant J0 (hors Système) | **Vétéran-Recouvreur** | Permanente, jamais perdue |
| **Classe Système** | Attribuée au J0 par le Système, avec un rang de F à S (EX caché) | **Porteur (F)** | Réattribuée au J1. Ses niveaux reviennent avec les Échos |
| **Classe principale** | La classe active choisie, qui définit les compétences de combat | Débloquée selon la voie | Les classes **gravées** restent disponibles (§10.8.4) |
| **Sous-classe(s)** | Classes secondaires : 50 % de leurs passifs et 1 compétence active équipable | Exclusivité du Porteur : 1 sous-classe, puis 2 à partir de la boucle 3 | Même règle que la classe principale |

**Twist de gameplay du Porteur** : le Système méprise ce rang F, mais le Porteur est la seule classe capable de **« porter » d'autres classes** en même temps. C'est la vraie raison du choix de Haneul : un Lecteur des Fins doit pouvoir endosser toutes les voies. Le joueur le découvre en atteignant le niveau 10 de Porteur (notification glitchée du Système : *« Capacité de charge : classes »*).

#### 10.8.2 Passifs de base
- **Vétéran-Recouvreur (origine)** :
  - *Sang-froid* : immunité au premier effet de Peur de chaque combat ;
  - *Lecture de la menace* : +15 % d'initiative au premier tour ;
  - *Recouvrement* : +25 % d'argent et de butin sur un ennemi intimidé ou qui se rend ;
  - *Endurance de terrain* : +1 phase de Fatigue avant malus ;
  - *Langues* : options de dialogue exclusives avec les étrangers (Simone, Nadia, Maricel, Xiaoyu).
- **Porteur (F)** :
  - *Endurance du Porteur* : +50 % d'inventaire ;
  - *Bât* : peut porter un allié KO hors du combat ou d'une zone, ce qui le sauve d'une mort définitive ;
  - *Porter les classes* : débloque l'emplacement de sous-classe (niveau 10).

#### 10.8.3 Arbre des classes par voie
Les niveaux de tier : **T1** de base (niveau 1) · **T2** de voie (niveau 10 + Titre de voie) · **T3** avancée (niveau 25 + quête de classe) · **T4** légendaire (après le J30, niveau 40 + Strate franchie, §15).

| Voie | T2 | T3 | T4 (Ère des Strates) | Condition d'alignement |
|---|---|---|---|---|
| **Héros** | **Gardien** | **Paladin du Refuge** | **Bastion de l'Aube** | Protéger ≥ 40, Lien ≥ 40 |
| **Tyran** | **Seigneur de Guerre** | **Empereur des Cendres** | **Roi-Démon Souverain** | Dominer ≥ 40, Lien ≥ 40 |
| **Loup** | **Infiltrateur** | **Ombre Sans Nom** | **Faucheur du Crépuscule** | Solitude ≥ 50 |
| **Mercenaire** | **Chasseur de Primes** | **Marchand de Fins** | **Roi des Contrats** | Dominer ≥ 20, Solitude ≥ 30 |
| *Hybride* Héros + Tyran | **Souverain Protecteur** | **Monarque de Fer** | **Empereur de l'Aube** | Lien ≥ 60, Protéger/Dominer entre −20 et +20 |
| *Hybride* Héros + Loup | **Vigilant** | **Justicier Masqué** | **Spectre Bienveillant** | Protéger ≥ 40, Solitude ≥ 30 |
| *Hybride* Tyran + Mercenaire | **Seigneur-Pirate** | **Baron des Ruines** | **Prince-Marchand** | Dominer ≥ 50, Lien/Solitude entre −20 et +20 |
| *Hybride* Loup + Mercenaire | **Lame à Gages** | **Spectre à Gages** | **Fantôme Doré** | Solitude ≥ 60, Dominer ≥ 10 |

**Classes secrètes :**
| Classe | Déblocage | Rôle |
|---|---|---|
| **Lecteur des Fins (EX)** | Fin de l'Acte I ou boucle 2. Équipable en sous-classe à vie | Améliore le Registre : +1 Réécriture, Pressentiment amélioré, *Lire la Fin* en combat (révèle la mort d'un ennemi, qui gagne un bonus d'exécution) |
| **Anomalie** | Chaos ≤ −60 | Manipulation du temps (rejouer un allié, vieillir ou rajeunir un buff), mais traqué par les Exécuteurs du Système |
| **Élu Déchu** | Corruption ≥ 40 (pouvoirs des Élus) | Puissance brute de la Tour, avec sacrifice de PV. Mène vers la fin *La Bête de la Tour* |
| **Gardien du Seuil** | Lien d'âme avec Haneul + étage 10 franchi | La classe de la fin vraie : fusion des pouvoirs d'Elias et de Haneul |

#### 10.8.4 Maîtrise, gravure et régression
- **Maîtrise** (0–100 %) : chaque classe progresse par l'usage (combats, actes de voie, quêtes de classe).
- **Gravure** : à 100 %, la classe est **gravée** dans le Registre. Aux boucles suivantes, elle redevient disponible **dès le niveau 5** (au lieu de 10 ou 25), même si le Titre de voie n'est pas encore obtenu. L'alignement doit cependant rester compatible (voir Dissonance).
- **Compétence signature → compétence d'âme** : chaque classe gravée offre 1 compétence signature, qui peut occuper un **emplacement d'âme**. Ces emplacements sont équipables quelle que soit la classe active. Il y en a **3 à la boucle 2**, puis **+1 toutes les 2 boucles**, jusqu'à 8 au maximum.
- **Dissonance** : si l'alignement sort de la zone d'une classe active, ses compétences subissent −20 % d'efficacité et l'Ultime est verrouillée, jusqu'au changement de classe (au Refuge, ½ phase).
- **Changer de voie entre deux boucles** : c'est le cœur de la rejouabilité. Une boucle Tyran grave *Seigneur de Guerre* ; la boucle suivante, en Héros, peut porter *Gardien* en principale et *Seigneur de Guerre* en sous-classe. Le joueur compose ainsi un Elias unique au fil des vies.

### 10.9 Compétences actives de combat (hors Registre)

**Kit de base (Vétéran-Recouvreur + Porteur), disponible dès le J1 :**
| Compétence | Coût | Effet | Ligne |
|---|---|---|---|
| **Frappe de Recouvreur** | — | Dégâts de mêlée, +10 Peur sur la cible | Avant |
| **Clé de bras** | 15 Mana | Immobilise 1 tour, la cible ne peut pas changer de case | Avant |
| **Tir de couverture** | 10 Mana | À distance, réduit l'esquive de la cible. Dans la Tour (règle de l'étage 1), devient **Lancer de lame** | Toutes |
| **Porter** | 10 Mana | Déplace un allié vers n'importe quelle case adjacente et lui donne +30 % de défense pendant 1 tour | Toutes |
| **Charge du Porteur** | 20 Mana | Avance d'une ligne, renverse la cible (perte de tour si sa VOL est faible) | Milieu → avant |
| **Sang-froid** | 15 Mana | Purge les effets mentaux, le prochain coup est critique | Toutes |
| **Ultime : Dernier Recouvrement** | Jauge d'Éveil | Frappe la cible la plus blessée : dégâts ×3, exécution sous 15 % de PV | Avant |

**Compétences par classe de voie (T2 / T3) :**
| Classe | Compétences actives | Ultime |
|---|---|---|
| **Gardien** (T2) | *Bouclier vivant* (prend les coups d'un allié pendant 2 tours) · *Provocation* · *Rempart* (Défense +50 % sur la ligne) · *Second souffle* (soin personnel) | **Aegis de l'Aube** : le groupe est invulnérable pendant 1 tour ennemi |
| **Paladin du Refuge** (T3) | + *Serment de protection* (lie un allié : ses dégâts sont partagés) · *Châtiment* (dégâts × nombre d'alliés blessés) | **Phare du Refuge** : soin de groupe de 50 % et résurrection d'un allié |
| **Seigneur de Guerre** (T2) | *Ordre absolu* (un allié vassal rejoue, +Ambition s'il est sous Pacte) · *Terreur* (Peur de zone) · *Exécution* (tue un ennemi sous 25 % de PV, les autres ennemis perdent leur tour de peur) · *Tribut* (vole du Mana) | **Couronne de Cendres** : tous les ennemis effrayés se rendent ou fuient, et les boss subissent −30 % de stats |
| **Empereur des Cendres** (T3) | + *Garde prétorienne* (invoque 2 vassaux) · *Décret* (interdit une catégorie de compétences à l'ennemi pendant 2 tours) | **Trône de la Tour** : domination de la grille, les ennemis frappent leurs alliés pendant 1 tour |
| **Infiltrateur** (T2) | *Ombre* (invisible 2 tours) · *Égorgement* (critique garanti dans le dos, sur la ligne arrière) · *Leurre* · *Disparition* (fuite garantie hors boss) | **Mille Coupures** : 8 frappes réparties sur toute la grille |
| **Ombre Sans Nom** (T3) | + *Marque de mort* (la cible meurt à la fin du 3e tour si elle n'est pas purgée) · *Pas de l'ombre* (se téléporte derrière n'importe quelle case) | **Nuit Sans Lune** : la grille ennemie est aveuglée et toutes les attaques d'Elias sont critiques pendant 2 tours |
| **Chasseur de Primes** (T2) | *Marquage de prime* (butin ×2 sur la cible) · *Filet* · *Tir de précision* · *Pot-de-vin* (un ennemi humain change de camp pendant 2 tours) | **Contrat Exécuté** : dégâts massifs sur la cible marquée, plus une prime d'argent |
| **Marchand de Fins** (T3) | + *Vendre le destin* (échange les buffs d'Elias contre les malus d'un ennemi) · *Assurance* (annule une mort alliée contre de l'argent) | **Liquidation Totale** : convertit tout l'argent dépensé dans le combat en dégâts |

**Synergies d'Elias** : chaque héroïne a 1 attaque combinée avec Elias (débloquée à Confiance ≥ 60 ou en Dévotion). La forme de la cut-in change selon la classe d'Elias : en Seigneur de Guerre et Ryeon, *Lame du Trône* ; en Gardien et Ryeon, *Double Croisement*.

---

## 11. Système de harem : règles communes

### 11.1 Les jauges
| Jauge | Plage | Augmente par | Effet |
|---|---|---|---|
| **Affinité** | 0–100 | Temps passé, cadeaux, choix qui correspondent à ses valeurs | Scènes personnelles, romance |
| **Confiance** | 0–100 | Promesses tenues, Fins réécrites pour elle, vérité dite | Stabilité, Synergies avancées |
| **Peur** | 0–100 | Menaces, démonstrations de force, punitions | Obéissance à court terme, nourrit l'Ambition cachée |
| **Ambition cachée** | 0–100 (cachée) | La Peur, la frustration, son agenda propre | Une Ambition au-dessus du seuil rend la trahison possible |
| **Ambivalence** (Pacte uniquement) | −100 à +100 (cachée) | Justice, protection, considération / humiliation, négligence | Décide du destin du Pacte : Dévotion, Couteau ou Rupture (§11.4.4) |

```
Loyauté = 0,4 × Confiance + 0,3 × Affinité + 0,2 × Peur + Compatibilité(valeurs)
          − Ambition cachée × 0,5
```

La Loyauté exacte n'est visible qu'avec *Lecture des Cœurs*.

### 11.2 Les étapes de relation
1. **Inconnue** : première rencontre et Lecture de la Fin.
2. **Alliée** : recrutée, utilisable en combat.
3. **Proche** : quête personnelle débloquée.
4. **Fin réécrite** : moment-pivot de la route, qui ouvre une nouvelle Fin plus lointaine.
5. **Liée** : choix de la dynamique (§11.3).
6. **Route accomplie** : fin personnelle débloquée.

### 11.3 Les dynamiques de relation
| Dynamique | Condition | Effet | Contenu intime |
|---|---|---|---|
| **Serment** (exclusif) | Affinité ≥ 80, Confiance ≥ 80, fin de la quête personnelle, aucune autre relation intime en cours | Synergie *Serment* (la plus puissante), fin dédiée, Échos affectifs maximaux | P1 à P3, romantique |
| **Cour ouverte** (polyamour) | Affinité ≥ 60, Confiance ≥ 50, l'héroïne **accepte le partage** (trait propre), Cohésion de la Cour ≥ 50 | Synergies multiples, scènes de groupe à la Maison, fin « Maison » | P1 à P3, plus des scènes de groupe |
| **Dévotion** (domination désirée) | Affinité ≥ 70, Confiance ≥ 85, l'héroïne a le **trait « Dévotion »**, souvent sur la voie du Tyran. Ou bien évolution d'un Pacte (§11.4.4) | Synergie *Ordre absolu* sans coût d'Ambition | P1 à P3, domination assumée et passionnelle |
| **Pacte de Vassalité** (domination par l'ascendant) | Voie du Tyran (Dominer ≥ 40), **Peur ≥ 50 ou Ascendant** (§11.4.1), signature du Pacte | Obéissance contractuelle, +20 % d'efficacité, Ambivalence suivie au jour le jour | **P1 à P3, scènes sombres** (§11.4.3) |
| **Masque** (soumission feinte) | Héroïne sous Pacte dont l'Ambition cachée dépasse l'Affinité | Elle joue la soumission en préparant sa vengeance. Seule *Lecture des Cœurs* le révèle | Les scènes de Pacte restent accessibles : c'est le piège, le joueur ne sait pas s'il est trompé |

### 11.4 Le Pacte de Vassalité (voie du Tyran)
Le cœur sombre de la voie du Tyran. **La domination par la peur et l'ascendant psychologique ouvre des scènes intimes et romantiques sombres**, encadrées par un contrat que le Système fait respecter. Il n'y a jamais de violence physique : tout passe par le pouvoir, la dette, la soumission à l'autorité et la tension psychologique.

#### 11.4.1 Obtenir un Pacte : la Peur ou l'Ascendant
L'héroïne doit avoir **Peur ≥ 50**, ou Elias doit détenir un **Ascendant** sur elle :
| Ascendant | Exemple |
|---|---|
| **Défaite** | Vaincue en duel formel ou militairement (Ryeon, Simone, Xiaoyu) |
| **Dette de vie** | Elias lui a sauvé la vie, ou a sauvé ceux qu'elle protège, *à un prix annoncé* (Seo-Yeon, Maricel) |
| **Dépossession** | Elias lui a pris son Sceau, son clan ou son contrat (Hae-in, Aoi, Nadia) |
| **Secret** | Elias connaît son secret du Registre et peut le révéler (Xiaoyu et le poison de son père, Hae-in et ARCHE, Minh-Anh et ses recherches) |
| **Mécénat** | Elias finance et protège ce qui compte pour elle (Minh-Anh et son laboratoire) |

**La scène de signature** : une scène-pivot doublée et illustrée en CG. Elias énonce ses termes, l'héroïne négocie, cède ou se brise. Le Système matérialise le contrat (un parchemin de glyphes rouges), et elle le signe de son sang ou de son nom.

#### 11.4.2 Les clauses
| Clause | Contenu | Effet de jeu |
|---|---|---|
| **Allégeance** | Elle reconnaît Elias comme Seigneur | Recrutement forcé, obéissance en combat et en mission |
| **Résidence** | Elle vit à la Forteresse | Disponible pour les événements de Nuit |
| **Service personnel** | Elle se tient à la disposition d'Elias | **Ouvre les scènes intimes de Pacte** |
| **Protection** (contrepartie obligatoire) | Elias garantit sa sécurité et celle de ce qu'elle protège | **Le Système la fait respecter.** Si Elias échoue (camp détruit, Fin non empêchée par négligence), le Pacte se brise automatiquement |
| **Clause de rupture** (Loi des Contrats) | Elle peut rompre à tout moment, contre un prix fixé à la signature (perte de rang, dette, exil) | Elle reste vassale tant que le prix lui paraît plus lourd que sa servitude. C'est le moteur dramatique |
| **Clauses optionnelles** | Exclusivité, silence, port du sceau d'Elias (un tatouage-glyphe à la nuque ou au poignet), présence à la cour | Plus de clauses, c'est plus d'efficacité et plus de Ressentiment |

#### 11.4.3 Les scènes de Pacte : une romance sombre
- **Trois paliers** :
  - **P1 Allégeance** : cérémonies, mise à genoux symbolique, port du sceau, présence à la cour ;
  - **P2 Service** : tension, ordres, intimité imposée par le statut, jeux de regard et de pouvoir ;
  - **P3 Possession** : scènes explicites où le rapport de pouvoir est au centre.
- **Ton** : psychologique et ambigu. Les cases de pensée de l'héroïne montrent sa honte, sa colère, son trouble et parfois son désir naissant. Les cases d'Elias montrent la jouissance du pouvoir ou le doute, selon son alignement.
- **Pas de violence physique** : ni coups ni blessures. La domination est verbale, posturale, contractuelle et psychologique.
- **Variantes selon l'Ambivalence** (ci-dessous) : la même scène existe en version **Ressentiment** (froide, défiante) et en version **Trouble** (l'héroïne commence à céder intérieurement). La version jouée dépend de la jauge.
- **Personnalisation** : chaque héroïne réagit au Pacte selon son caractère (voir sa fiche, rubrique « Pacte »).

#### 11.4.4 L'Ambivalence et les trois destins d'un Pacte
Une jauge cachée propre au Pacte, **l'Ambivalence**, va de −100 (Ressentiment) à +100 (Attachement). Elle évolue chaque jour :
- **Elle monte** quand Elias tient la clause de Protection, se montre juste ou sauve ce qu'elle aime, lui montre de la considération en privé, ou réécrit sa Fin.
- **Elle baisse** avec l'humiliation publique, l'ajout de clauses, la négligence, l'atteinte à ses valeurs ou à ses proches.

| Destin | Condition | Résultat |
|---|---|---|
| **Dévotion** | Ambivalence ≥ +60 et Affinité ≥ 70 | Elle **renouvelle librement le Pacte**. La domination reste, mais elle devient passionnelle et désirée. Synergie *Ordre absolu* sans coût d'Ambition, fin « Le Trône » possible |
| **Couteau** (Masque) | Ambivalence ≤ −40 et Ambition cachée ≥ 60 | Elle porte un **Masque** et prépare sa trahison au moment critique (§11.6). Les scènes restent jouables : le joueur peut être trompé |
| **Rupture** | Elle invoque la clause de rupture (Ambivalence ≤ −60, ou déclencheur absolu) | Elle paie le prix et part, hostile. Une confrontation ou une quête de reconquête peut suivre |

#### 11.4.5 Règles de lore et garde-fous
- **Le Système refuse les contrats signés par une « coquille »** : une héroïne inconsciente, droguée ou effacée ne peut pas signer. C'est pourquoi **Haneul ne peut jamais être sous Pacte** (§12.10).
- **Effets de la Dette temporelle** : aux boucles suivantes, une héroïne qui a vécu un Pacte en Ressentiment démarre avec Peur +10 et des cauchemars. Si elle l'a vécu en Dévotion, elle démarre avec un trouble inexpliqué en présence d'Elias (Affinité +10).
- **Préférences du joueur** (options, toutes activées par défaut) : on peut masquer individuellement les scènes de Pacte P3, sans conséquence sur le gameplay.

### 11.5 Cohésion de la Cour
- La **Cohésion** (0–100) est une jauge commune aux héroïnes « liées » en Cour ouverte ou sous Pacte. Elle se calcule à partir de la matrice de compatibilité (§13.1), du temps partagé au Refuge, de l'équité d'attention et des événements de groupe.
- **Au-dessous de 30** : jalousies, ultimatums, départs ; une Ambition cachée peut être activée chez les héroïnes à fort ego.
- **Au-dessus de 70** : scènes de groupe, Synergies en trio, événement « Nuit de la Maison ».

### 11.6 Trahison : règles générales
- Chaque héroïne a un **seuil de trahison** (une valeur de Loyauté) et des **déclencheurs**.
- La trahison survient lors d'un **moment critique** (boss, siège, Sommet des Sceaux, J24, J28, J30) si Loyauté < seuil, ou immédiatement si un déclencheur absolu est touché.
- **Signes avant-coureurs** obligatoires (au moins 2, sur 2 jours différents), pour que la trahison reste juste et lisible.
- **Réponses possibles** : confronter, pardonner, exécuter, retourner (agent double), laisser faire pour remonter au commanditaire.

### 11.7 Calendrier relationnel
- **Rendez-vous** : 1 phase. Au plus 1 événement de relation majeur par jour et par héroïne.
- **Nuit au Refuge** : en phase Nuit, choisir avec qui passer la soirée (événements de quotidien, de confidence, intimes).
- **Cadeaux** : chaque héroïne a 3 cadeaux aimés, 3 détestés et 1 cadeau « clé », lié à son passé.

---

## 12. Les 10 héroïnes

> Format commun : identité → rôle → **fiche physique complète** → tenues → personnalité → Fin du Registre → secret → recrutement → trahison → dynamiques (dont le **Pacte**) → combat → notes 18+.
> **Tous les âges sont fixés dans les données et sont ceux de personnages adultes.**

### Vue d'ensemble
| # | Nom | Âge | Taille / poids | Origine | Secteur / affiliation | Archétype | Fin |
|---|---|---|---|---|---|---|---|
| 1 | **Park Seo-Yeon** | 27 | 1m63 / 52 kg | Coréenne | Yeouido, Camp / Sanctuaire | Soignante idéaliste | J12 |
| 2 | **Yoon Hae-in** | 41 | 1m72 / 58 kg | Coréenne | Yeouido, Haesong Holdings | Reine de glace (chaebol) | J21 |
| 3 | **Baek Ryeon** | 23 | 1m68 / 55 kg | Coréenne | Collines du Nord, Maison Baek | Princesse-épéiste orgueilleuse | J17 |
| 4 | **Simone Hayes** | 38 | 1m78 / 72 kg | Afro-américaine | Yongsan, Unité 0 | Commandante de fer | J28 (ou J24) |
| 5 | **Long Xiaoyu** | 31 | 1m70 / 54 kg | Chinoise (Shanghai) | Ponts du Han, Longwei | Reine de la pègre, femme fatale | J19 |
| 6 | **Aoi Tsukishiro** | 22 | 1m60 / 47 kg | Japonaise (Osaka) | Hongdae, Mirae (agence) | Idol brisée | J9 |
| 7 | **Nadia Tsoi** | 34 | 1m76 / 63 kg | Koryo-saram (Kazakhstan) | Gangnam, contractuelle de Cheonma | Sniper mercenaire, loup solitaire | J24 |
| 8 | **Maricel Dizon** | 26 | 1m57 / 50 kg | Philippine | Myeongdong (sous-sol), Rats du Han | Voleuse solaire | J14 |
| 9 | **Dr. Tran Minh-Anh** | 36 | 1m66 / 53 kg | Vietnamo-coréenne | Hongdae, Mirae (labo) | Scientifique obsessionnelle | J26 |
| 10 | **L'Héritière (« Haneul »)** | apparence 25 ans, adulte | 1m69 / 54 kg | Inconnue (la Tour) | Tour, étage 1 | Mystérieuse amnésique, clé du destin | J30 |


### Résumé de validation du charadesign
| Personnage | Taille / poids & silhouette | Style, visage & cheveux | Personnalité & trait marquant | Statut & passé intime |
|---|---|---|---|---|
| **Elias Kang** (29) | 1m84 / 86 kg. Grand, épaules larges, musculature sèche de combattant | Peau caramel, mâchoire carrée, barbe de trois jours, yeux noisette ambré (or avec le Registre), boucles noires courtes. Bomber noir, cargo, montre cassée à 23h58, cicatrice au sourcil, tatouage 살아남아 | Laconique, humour noir, protecteur enfoui. *Fait tourner sa montre quand il réfléchit* | Célibataire, expérimenté (liaisons brèves, nuits payées). Massacre au Sahel ; sa mère se prostituait pour les dettes du père |
| **Seo-Yeon** (27) | 1m63 / 52 kg. Menue, taille fine | Chignon châtain tenu par un crayon, yeux bruns, lunettes rondes scotchées, blouse tachée et cardigan trop grand | Douce et d'acier, rongée par la culpabilité. *Remonte ses lunettes quand elle ment* | Célibataire, vierge. A falsifié un triage, un homme en est mort |
| **Hae-in** (41) | 1m72 / 58 kg. Grande, sablier mûr | Chignon noir strict, mèche argentée, lèvres bordeaux, jade, tailleur blanc, manteau camel sur les épaules | Calculatrice, ironique, glaciale. *Baisse la voix pour menacer* | Veuve d'un mariage blanc jamais consommé, inexpérimentée. Brûlée par son mari, elle l'a regardé mourir |
| **Ryeon** (23) | 1m68 / 55 kg. Athlétique, élancée, jambes d'escrimeuse | Queue de cheval jusqu'aux genoux, ruban rouge, yeux gris acier, hanbok de combat noir et blanc, sabre | Fière, tsundere, honneur absolu. *Mange des sucreries en cachette* | Fiancée par contrat à Tae-ju (non consommé), vierge. Mère pendue ; elle a tué à 15 ans |
| **Simone** (38) | 1m78 / 72 kg. Puissante, musclée, épaules larges | Peau brun foncé, tresses plaquées et undercut, cicatrice à la mâchoire, treillis, plaques et bague de fiançailles | Stricte, directe, protectrice. *Un cigare les jours où l'on a survécu* | Célibataire, fiancée endeuillée, expérimentée. A validé une frappe sur un mariage afghan |
| **Xiaoyu** (31) | 1m70 / 54 kg. Féline, taille de guêpe | Carré noir, frange, mèche rouge, yeux de chat ambrés, qipao noir fendu et veste de cuir, dragon tatoué dans le dos | Joueuse, théâtrale, le contrat est sacré. *Éventail ouvert ou fermé selon son humeur* | Célibataire, expérimentée (amants-outils), jamais « possédée ». A empoisonné son père |
| **Aoi** (22) | 1m60 / 47 kg (le poids imposé par l'agence). Danseuse fine | Couettes basses noir et rose, yeux noisette, sweat gris oversize et veste pailletée, bracelets au poignet gauche | Pétillante en public, brisée en privé. *Son sourire de scène n'a pas de fossette* | Célibataire, vierge. Contrat d'esclave ; le sponsor Jang ; elle s'est ouvert le poignet ; automutilation |
| **Nadia** (34) | 1m76 / 63 kg. Sèche, nerveuse | Platine en undercut, mèche sur l'œil, yeux gris pâle, manteau militaire gris, écharpe rouge, cigarette éteinte | Laconique, sarcastique, fatiguée de tuer. *L'écharpe rouge signifie la confiance* | Célibataire, expérimentée, un amour mort (Dmitri). A tué Elias ; un enfant-soldat |
| **Maricel** (26) | 1m57 / 50 kg. Petite, pulpeuse | Ondulations noires et mèches cuivre, casquette, fossettes, crop hoodie moutarde, cargo, bracelets | Rieuse, voleuse, loyale à sa « famille ». *Vole tout ; claustrophobe* | Célibataire, trahie par son seul amour (Jun-ho), méfiante. Séquestrée, elle a poignardé son employeur |
| **Minh-Anh** (36) | 1m66 / 53 kg. Longiligne, frêle | Tresse noire jusqu'aux reins, lunettes rectangulaires, implants à LED à la tempe, blouse sur combinaison noire | Brillante, sans filtre, obsessionnelle. *Ses LEDs virent au rouge quand elle est émue* | Célibataire, vierge, peur d'être touchée. 9 morts lors des tests ARCHE |
| **Haneul** (adulte, ~25 ans en apparence) | 1m69 / 54 kg. Élancée, irréelle | Cheveux argent qui noircissent, yeux d'or à anneau d'horloge, glyphes, bomber d'Elias trop grand | Curieuse, douce, étrange, très ancienne. *N'a d'ombre que lorsqu'elle est heureuse* | Aucun lien, vierge de cette vie. Le souvenir d'une nuit avec Elias dans la première vie. A compté 9 millions de morts |

---

### 12.1 PARK SEO-YEON (박서연) — « La Main qui ne tremble pas »
- **Âge / taille / poids** : 27 ans / **1m63 / 52 kg**. **Origine** : coréenne, née à Daegu.
- **Rôle** : interne en médecine d'urgence à l'hôpital Sainte-Marie de Yeouido. Au J2, elle devient de fait la cheffe médicale du Camp de Yeouido. Elle est liée au Sanctuaire (Mère Agatha l'a formée au bénévolat).
- **Archétype** : soignante idéaliste, la « bonne personne » qui refuse de devenir autre chose.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m63 / 52 kg |
| **Morphologie** | Menue et compacte, mais tenace. Épaules étroites, taille fine, hanches douces, poitrine moyenne. Une silhouette de quelqu'un qui oublie de manger pendant les gardes. Bras fins mais nerveux, à force de porter des patients |
| **Peau** | Claire, légèrement rosée, qui rougit facilement (aux joues, aux oreilles et au cou). Pâleur de manque de soleil, cernes bleutés |
| **Visage** | Rond et doux : joues pleines, petit nez retroussé, lèvres fines naturellement rosées. Visage « de petite sœur » qui contraste avec un regard d'une fermeté inattendue |
| **Yeux** | Grands, ronds, **brun chocolat** chaud, avec une paupière simple. Derrière de **fines lunettes rondes** à monture dorée, rafistolées au scotch blanc à la branche gauche après le J1 |
| **Cheveux** | **Châtain foncé** aux reflets roux sous la lumière, mi-longs (jusqu'aux omoplates), raides avec une légère ondulation aux pointes. Souvent en **chignon défait** tenu par un crayon, quelques mèches folles autour du visage. Détachés, ils changent complètement son allure |
| **Signes particuliers** | Mains abîmées par le désinfectant (gerçures, ongles très courts) · petit grain de beauté au coin de l'œil droit · tache de café permanente sur la manche · bracelet en tissu tressé rouge, cadeau d'un patient enfant · ses lunettes, qu'elle remonte du doigt quand elle ment |
| **Gestuelle** | Se mord la lèvre quand elle réfléchit, parle vite quand elle a peur, se redresse d'un coup face à une blessure. Repousse ses mèches avec le dos du poignet (mains gantées) |
| **Voix** | Soprano légère, douce, un peu essoufflée. Elle devient sèche et autoritaire en mode médical. Léger accent de Daegu quand elle s'emporte |
| **Style habituel** | Pratique et négligé : vêtements médicaux, cardigans trop grands, sneakers blanches abîmées. Aucun maquillage. Coquette en secret (elle garde un rouge à lèvres rose dans sa poche, jamais utilisé) |
| **Palette (DA)** | Bleu ciel, beige, blanc cassé, rouge (bracelet, croix) |

- **Tenues** :
  - *base* : blouse médicale bleu ciel tachée sous un cardigan beige trop grand, sneakers blanches, stéthoscope ;
  - *combat* : gilet de secours orange à poches, brassard à croix, sacoche médicale ;
  - *détente* : pull oversize, cheveux détachés, sans lunettes, ce qui provoque une réaction d'Elias.
- **Personnalité** :
  - douce en apparence, d'acier dès qu'il s'agit d'un patient ;
  - têtue, perfectionniste, culpabilité chronique ;
  - humour maladroit quand elle est fatiguée ;
  - sur les axes : **Protéger +70, Lien +60**.
- **Aime / déteste** : le café sucré et les mots croisés ; le gaspillage, les « tris » de patients selon leur utilité.
- **Fin du Registre** : *J12, Crépuscule, hôpital Sainte-Marie. Mordue en protégeant 6 enfants d'un Rôdeur. Se transforme à minuit.*
  - **Cause profonde** : les enfants se sont cachés à l'hôpital parce que le camp a été rationné. Le vaccin existe dans les laboratoires de Haesong Bio.
  - **Réécriture** : il faut à la fois **sécuriser le camp** (pour que les enfants ne fuient pas) et **obtenir le sérum H-07** chez Haesong (vol, négociation avec Hae-in ou piratage avec Minh-Anh).
  - **Nouvelle Fin débloquée** : *J27, Quais du Dernier Exode, noyée en aidant des réfugiés*.
- **Secret lié au Registre** : elle est **immunisée** contre la souche de la Tour (la « Souche Zéro »). Son sang permettrait un vaccin de masse. Haesong et Mirae la veulent vivante. Les Élus la veulent sacrifiée… mais leur Prophète l'interdit en secret (§16.3). Seo-Yeon est aussi, sans le savoir, la version jeune de Mère Agatha.
- **Passé sombre** :
  - fille d'un père alcoolique et violent à Daegu, elle recoud les arcades de sa mère dès 12 ans : c'est là qu'elle a appris la médecine ;
  - pendant son internat, sous la pression d'un chef de service, elle a **falsifié un dossier de triage** pour faire passer le fils d'un député. Un ouvrier de 54 ans est mort sur un brancard, dans le couloir. Elle ne l'a jamais avoué à personne, et sa culpabilité chronique vient de là ;
  - elle a déjà « choisi » qui mourait. Elle se jure de ne jamais recommencer, ce qui rend le Pacte d'autant plus cruel pour elle.
- **Statut & passé intime** : **célibataire**. Aucune relation aboutie : un interne l'a humiliée devant tout le service après un premier rendez-vous, et elle s'est enfermée dans le travail. **Inexpérimentée (vierge).**
- **Recrutement** :
  - *Héros* : défendre le camp au J4 et tenir jusqu'au J6 ;
  - *Mercenaire* : la payer en médicaments et lui garantir des soins pour le camp ;
  - *Tyran* : par la contrainte (camp vassal), ce qui ouvre un **Pacte de Vassalité** ;
  - *Loup* : quasi impossible. Rencontre ponctuelle, un soin unique contre un service.
- **Trahison** :
  - **seuil** : Loyauté < 30 ;
  - **déclencheur absolu** : Elias tue ou abandonne des civils devant elle, ou la livre à un clan ;
  - **forme** : elle empoisonne la ration d'Elias au Refuge (une dose non létale, mais qui le met hors combat 2 phases) et s'enfuit au Sanctuaire avec les blessés ;
  - **signes** : elle évite son regard, son inventaire médical disparaît, elle chuchote avec Mère Agatha.
- **Dynamiques** :
  - **Serment** : sa route idéale, la plus émouvante (« le seul homme pour qui j'ai triché sur un tri ») ;
  - **Cour ouverte** : possible mais difficile. Elle accepte seulement si la Cohésion ≥ 70, et elle est jalouse de Hae-in ;
  - **Dévotion** : ✗, elle n'a pas ce trait ;
  - **Pacte** : il s'obtient par la *Dette de vie* (le camp vassal du J4 : Elias protège le camp contre sa servitude). Ambivalence de départ **−40**. Elle vit le Pacte comme une trahison de tout ce qu'elle est : ses scènes sont faites de honte et de défi silencieux. Destin probable : **Rupture** (elle s'enfuit avec les blessés) ou **Couteau** (le poison). La Dévotion n'est possible que si Elias protège réellement le camp mieux que personne : c'est l'arc de la « tyrannie protectrice ».
- **Combat** : *Chirurgienne de Terrain*, en arrière.
  - soins ciblés, *Triage* (soigne tout le groupe, mais celui qui a le plus de PV en perd) ;
  - *Adrénaline* (relève un allié KO une fois par combat) ;
  - **Ultime** : *Code Bleu*, résurrection de groupe avec 30 % de PV.
- **Notes 18+** : tempérament timide qui se libère avec la Confiance. Cherche la tendresse et le réconfort après les nuits de garde. Scènes clés : la salle de repos de l'hôpital (P2), le bunker B6 (P3).

---

### 12.2 YOON HAE-IN (윤해인) — « La Présidente »
- **Âge / taille / poids** : 41 ans / **1m72 / 58 kg**. **Origine** : coréenne, issue de l'aristocratie financière de Séoul.
- **Rôle** : présidente de **Haesong Holdings**, porteuse du **Sceau de la Balance** et Seigneur de Yeouido.
- **Archétype** : reine de glace, dirigeante de chaebol, figure d'autorité mûre et redoutable.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m72 / 58 kg (1m80 en talons, qu'elle ne quitte presque jamais) |
| **Morphologie** | Grande, élancée, port de reine. Silhouette en sablier mûre et maîtrisée : épaules droites, taille très marquée, hanches pleines, poitrine généreuse, jambes longues et galbées. Une femme qui entretient son corps comme un actif (pilates, natation à l'aube) |
| **Peau** | Porcelaine mate, parfaitement soignée. Quelques ridules d'expression au coin des yeux, qu'elle ne cache pas (« Elles m'ont coûté assez cher ») |
| **Visage** | Ovale aristocratique : pommettes hautes et sculptées, nez fin et droit, mâchoire délicate mais ferme. **Lèvres pleines, toujours rouge sombre** (bordeaux). Un **grain de beauté** sous la lèvre inférieure, à gauche |
| **Yeux** | En amande allongée, paupière double fine, **noir d'encre** aux reflets bruns. Eyeliner en aile discret. Un regard d'évaluation permanent, qui s'adoucit très rarement |
| **Cheveux** | **Noir de jais**, lisses, très longs (jusqu'à la taille quand ils sont détachés). D'ordinaire en **chignon bas strict**, avec une raie sur le côté. Une **unique mèche argentée** à la tempe gauche, apparue à la mort de son mari, qu'elle refuse de teindre |
| **Signes particuliers** | Boucles d'oreilles en **jade impérial** (héritage maternel) · alliance de son mariage blanc, portée à la main droite comme un trophée · petites **cicatrices rondes de brûlures de cigarette** à l'intérieur de la cuisse gauche, laissées par son mari (visibles en CG intime, sujet de confidence) · parfum boisé d'iris et de cuir · montre en or rose à cadran nacré |
| **Gestuelle** | Ne se presse jamais. Tient sa tasse de thé à deux mains. Lève un seul sourcil pour exprimer son mépris. Tapote la table d'un ongle quand elle s'impatiente. Ne laisse personne marcher derrière elle |
| **Voix** | Alto profond, velouté, diction parfaite. Elle ne hausse jamais le ton : elle baisse la voix pour menacer. Rire bref, rare et grave |
| **Style habituel** | Haute couture minimaliste : tailleurs-pantalons blancs ou crème, chemisiers de soie, **manteau camel porté sur les épaules** (jamais les manches), talons aiguilles nude. En privé : soie bordeaux et noire |
| **Palette (DA)** | Blanc, crème, camel, bordeaux, vert jade, or rose |

- **Tenues** :
  - *base* : tailleur-pantalon blanc haute couture, manteau camel jeté sur les épaules (elle ne met jamais les manches), talons aiguilles, montre en or ;
  - *combat* : version renforcée, avec un trench noir aux doublures runiques (contrats du Système) et des gants blancs ;
  - *détente* : robe de soie bordeaux, cheveux détachés, un verre de vin. Elle ne se montre ainsi qu'à ceux qu'elle respecte.
- **Personnalité** :
  - calculatrice, élégante, ironique, d'une politesse coupante ;
  - méprise la faiblesse, mais respecte profondément la compétence ;
  - solitude glaciale : veuve d'un mariage blanc, et sa fille adoptive, Yoon Da-bin (19 ans), est coincée **hors du Voile** ;
  - sur les axes : **Dominer +35, Lien −10**.
- **Aime / déteste** : le thé vert de Jeju, les échecs, les gens qui tiennent parole ; la flatterie, l'amateurisme, qu'on la touche sans permission.
- **Fin du Registre** : *J21, Jour, salle du conseil de la tour Haesong. Exécutée par le vice-président Nam Gi-seok lors d'un coup d'État interne.*
  - **Cause profonde** : Nam a pactisé avec Mirae et Cheonma pour récupérer le Sceau et enterrer le Projet ARCHE.
  - **Réécriture** : il faut exposer Nam avant le J21 (preuves dans les serveurs de Mirae, ou témoignage de l'Agent Shin), ou être présent au conseil avec assez de force pour inverser le coup.
  - **Nouvelle Fin débloquée** : *J30, assassinée par le Prophète des Élus, qui a besoin du Sceau de la Balance*.
- **Secret lié au Registre** : elle a signé le **Projet ARCHE**. Haesong Bio a capté des signaux sous Yongsan et y a envoyé une sonde… qui a reçu une **réponse**. Elle croit que la Tour est de sa faute, et elle cherche à la fois à **racheter sa faute et à l'effacer**.
- **Passé sombre** :
  - mariée à 22 ans par ses familles à **Yoon Gwang-su**, héritier de Haesong de 20 ans son aîné. C'était une **union purement contractuelle** (une fusion) ;
  - il la méprisait et la **brûlait avec ses cigarettes** pour la « dresser ». Elle ne lui a jamais cédé : le mariage n'a **jamais été consommé** ;
  - il y a 9 ans, il a fait une crise cardiaque devant elle. **Elle a fini son thé avant d'appeler les secours** ;
  - **Da-bin** est la fille illégitime de son mari et d'une maîtresse. Hae-in l'a adoptée et élevée comme la sienne : c'est la seule personne qu'elle aime sans calcul.
- **Statut & passé intime** : **veuve d'un mariage blanc**, jamais consommé. Aucune liaison depuis : elle n'a jamais laissé personne l'approcher. **Inexpérimentée sous une maîtrise absolue**, c'est la contradiction au cœur de ses scènes.
- **Recrutement** :
  - *Mercenaire* : lui vendre 3 Souvenirs exploitables (des prédictions de marché), puis prouver sa valeur au J13 ;
  - *Héros* : la sauver au J21, avec l'arc du rachat d'ARCHE ;
  - *Tyran* : la vaincre politiquement (lui prendre son Sceau ou la mettre en minorité au conseil). Elle s'allie alors par pragmatisme (ou signe un **Pacte de Vassalité**) et peut glisser vers la Cour ;
  - *Loup* : impossible de la recruter. Elle peut seulement l'employer comme agent ponctuel.
- **Trahison** :
  - **seuil** : Loyauté < 45, le plus élevé du casting ;
  - **déclencheur absolu** : Elias révèle publiquement le Projet ARCHE sans son accord, ou menace sa fille via le canal radio ;
  - **forme** : elle vend Elias au Conseil des Sceaux au moment le plus rentable (le Sommet du J13 ou le J28) ;
  - **signes** : réunions à huis clos, contrats modifiés en petits caractères, l'Agent Shin qui suit Elias.
- **Dynamiques** :
  - **Serment** : très difficile. Il faut qu'elle renonce à son Sceau, et c'est le plus beau retournement du jeu ;
  - **Cour ouverte** : ✓ à condition d'être **« première »**, avec un statut de Reine de la Maison. Elle est en conflit ouvert avec Xiaoyu ;
  - **Dévotion** : ✗, mais **Dévotion inversée** possible : c'est *elle* qui mène, si Elias l'accepte, sur la voie Héros ou Mercenaire ;
  - **Pacte** : il s'obtient par la *Dépossession* (Sceau de la Balance pris, conseil renversé) ou le *Secret* (Projet ARCHE). Ambivalence de départ **−30**. Elle signe avec une lucidité glaciale et négocie chaque clause. Ses scènes de Pacte mettent en scène une souveraine qui se plie par calcul, puis le vertige de ne plus porter seule le poids du pouvoir. Destin probable : **Couteau**, avec un Masque parfait (invisible sans *Lecture des Cœurs* Niv.2) et la trahison la plus coûteuse du jeu. **Retournement possible** : si Elias la surpasse trois fois stratégiquement, elle bascule en **Dévotion** (« Pour la première fois, quelqu'un d'autre décide »).
- **Combat** : *Souveraine*, en arrière.
  - *Clause* : lie un ennemi, qui subit des dégâts s'il attaque la cible désignée ;
  - *Liquidation* : exécute un ennemi sous 20 % de PV et rapporte de l'argent ;
  - *Ordre du Conseil* : buff d'initiative de groupe ;
  - **Ultime** : *Faillite*, qui retire tous les buffs ennemis et vole leur Mana.
- **Notes 18+** : mène, exigeante, magnétique. Fait payer chaque centimètre de vulnérabilité, puis l'offre entièrement. Scènes clés : son bureau au 50e étage la nuit, devant la ville en ruines (P3), un bain au penthouse (P2).

---

### 12.3 BAEK RYEON (백련) — « Le Lotus Blanc »
- **Âge / taille / poids** : 23 ans / **1m68 / 55 kg**. **Origine** : coréenne, héritière de la lignée Baek (escrimeurs depuis l'ère Joseon).
- **Rôle** : héritière de la Maison Baek, épéiste de rang A, première Exécutrice du clan.
- **Archétype** : princesse guerrière orgueilleuse, tsundere au cœur noble.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m68 / 55 kg |
| **Morphologie** | Athlétique et élancée, faite pour l'escrime : épaules dessinées, dos droit, ventre plat et ferme, hanches étroites, poitrine menue à moyenne, **jambes longues et musclées** (les fentes). Les muscles se lisent sous la peau quand elle se met en garde |
| **Peau** | Claire et lumineuse, légèrement hâlée sur les avant-bras et le visage (entraînement à l'aube, en plein air). Elle rougit de façon spectaculaire, jusqu'aux oreilles |
| **Visage** | Ovale fin aux traits nobles et sévères : sourcils fins et droits souvent froncés, nez droit, lèvres minces qui se pincent quand elle est contrariée, menton volontaire. Une beauté classique « de portrait Joseon » |
| **Yeux** | En amande, légèrement relevés aux coins, paupière double nette. Iris **gris acier**, rare et hérité de la lignée Baek. Le regard est tranchant comme une lame, sauf quand elle est prise au dépourvu |
| **Cheveux** | **Noir bleuté**, raides et lourds, **très longs** (jusqu'aux genoux une fois détachés). En **queue de cheval haute** nouée d'un **ruban rouge** (celui de sa mère), avec une frange effilée et deux longues mèches qui encadrent le visage |
| **Signes particuliers** | Fine **cicatrice sur la clavicule gauche** (son premier duel, à 15 ans), qu'elle cache · cals aux paumes et aux doigts · trois grains de beauté alignés sur l'omoplate droite (« la constellation du Tigre », selon sa grand-mère) · le ruban rouge, qu'elle ne quitte jamais |
| **Gestuelle** | Posture parfaite, même assise. Pose la main sur la garde de son sabre quand elle est nerveuse. Croise les bras et détourne la tête pour cacher sa gêne (tsundere). Mange des sucreries en cachette, en vérifiant que personne ne regarde |
| **Voix** | Mezzo claire et ferme, phrasé formel et archaïque (registre honorifique). Sa voix se brise en aigus quand elle est embarrassée |
| **Style habituel** | Traditionnel et martial : **hanbok de combat** noir et blanc modernisé, ceinture rouge, sabre au côté. En civil : des vêtements sobres de qualité, jamais de jupe courte (« inutile pour se battre ») |
| **Palette (DA)** | Noir, blanc, rouge vermillon, argent (lame) |

- **Tenues** :
  - *base* : **hanbok de combat** modernisé noir et blanc (jeogori court ajusté, pantalon large serré aux chevilles), ceinture rouge, sabre long *Baekho* au côté ;
  - *combat* : protections de cuir laqué blanc et un demi-masque de tigre ;
  - *détente* : yukata de source chaude, cheveux détachés, ce qui la met dans un embarras flagrant ;
  - *cérémonie* (J17) : hanbok de mariage rouge et or. Image iconique du jeu.
- **Personnalité** :
  - fière, droite, impulsive, piètre menteuse ;
  - cache ses émotions derrière la rigueur ;
  - sens de l'honneur absolu ; drôle sans le vouloir à cause de sa rigidité ;
  - sur les axes : **Protéger +50, Lien +40**.
- **Aime / déteste** : les sucreries (en secret), l'entraînement à l'aube, les chats ; Cheon Tae-ju, les lâches, qu'on la protège.
- **Fin du Registre** : *J17, Crépuscule, domaine Baek. Tuée lors du duel d'honneur contre Cheon Tae-ju, qu'elle a provoqué pour refuser le mariage.*
  - **Cause profonde** : son père, mourant, a promis sa main à Cheonma pour sauver la Maison. Elle préfère mourir que de déshonorer sa parole ou de céder.
  - **Réécriture** :
    - affronter Tae-ju **à sa place** (droit de champion, si la Confiance ≥ 50) ;
    - ou rompre l'alliance (prouver la trahison prévue de Cheonma) ;
    - ou renforcer la Maison au point de rendre le mariage inutile (Défense des Collines ≥ 60 avant le J16).
  - **Nouvelle Fin débloquée** : *J29, étage 8 (l'Arène des Rangs), tuée par le Champion d'Hier*.
- **Secret lié au Registre** : le sabre *Baekho* est un **fragment de la Tour**, scellé par ses ancêtres. Il y a 400 ans, une « Tour » est déjà apparue et la lignée Baek l'a refermée. Ryeon porte sans le savoir la **technique de scellement**.
- **Passé sombre** :
  - sa mère **s'est pendue** dans la salle des ancêtres quand Ryeon avait 12 ans, après des années de mépris de Jin-ho, qui voulait un fils. Le ruban rouge est celui qu'elle portait ce jour-là ;
  - son père l'a formée à l'épée **à coups de bâton**, et elle le remercie encore ;
  - à 15 ans, lors de son premier duel officiel, elle a **tué** son adversaire, un garçon de 17 ans d'une maison rivale (d'où la cicatrice de la clavicule). On l'a félicitée, et elle a vomi toute la nuit.
- **Statut & passé intime** : **fiancée par contrat politique** à Cheon Tae-ju. C'est une union jamais consommée : elle ne l'a vu que trois fois, et elle le hait. Élevée dans un code strict, **elle n'a aucune expérience (vierge).**
- **Recrutement** :
  - *Héros* : défendre le domaine au J16, puis la sauver au J17 ;
  - *Tyran* : la vaincre en **duel formel** (Honneur) ; elle devient votre épée par serment martial (**Pacte d'Épée**), et la Dévotion est possible plus tard ;
  - *Mercenaire* : contrat de garde du corps (elle déteste ça, Affinité lente) ;
  - *Loup* : elle méprise les lâches. Il faut un exploit solo pour gagner son respect.
- **Trahison** :
  - **seuil** : Loyauté < 25, le plus bas : elle trahit rarement ;
  - **déclencheur absolu** : Elias rompt une **promesse enregistrée** ou s'allie à Cheonma ;
  - **forme** : elle ne trahit jamais en secret. Elle **défie Elias en duel à mort**, publiquement ;
  - **signes** : elle cesse de l'appeler par son nom, et aiguise son sabre la nuit devant sa porte.
- **Dynamiques** :
  - **Serment** : ✓, sa route naturelle, un serment sous le pin des ancêtres ;
  - **Cour ouverte** : réticente au début. Elle accepte si Elias est son « suzerain » et que la Cour a un ordre clair. Rivalité amicale avec Nadia ;
  - **Dévotion** : ✓, **trait présent** : la loyauté chevaleresque, celle de l'épée qui choisit son maître. Elle reste fière, et sa dévotion est une conquête, jamais une soumission ;
  - **Pacte** : il s'obtient uniquement par la *Défaite* en **duel formel** (le code d'honneur des Collines). C'est le **Pacte d'Épée** : elle s'agenouille, offre son sabre, et le Système enregistre le serment. Ambivalence de départ **0** : l'honneur prime sur la rancœur. Ses scènes mettent en scène une guerrière fière qui se soumet *parce qu'elle a été vaincue*, partagée entre humiliation et fascination pour plus fort qu'elle. Destin probable : **Dévotion**, la plus naturelle du jeu. Le Couteau est impossible : sa Rupture prend la forme d'un **duel à mort public**. Un Masque ? Jamais : elle préfère mourir. Une Peur ≥ 60 *hors Pacte* déclenche le duel.
- **Combat** : *Sabre du Tigre Blanc*, à l'avant.
  - *Iai* : premier coup garanti critique si elle agit en premier ;
  - *Garde du Lotus* : contre-attaque ;
  - *Danse des Pétales* : frappe toute la ligne avant ;
  - **Ultime** : *Tigre Blanc Céleste*, gros dégâts qui ignorent la défense, avec une cut-in de tigre spectral ;
  - **Synergie avec Elias** : *Double Croisement*.
- **Notes 18+** : inexpérimentée et terriblement gênée. Elle réfléchit trop, puis se jette à l'eau avec la même intensité qu'en duel. Scènes clés : la source chaude cachée (P2), la nuit après le J17 (P3).

---

### 12.4 SIMONE HAYES — « Commandante Zéro »
- **Âge / taille / poids** : 38 ans / **1m78 / 72 kg**. **Origine** : afro-américaine, née à Atlanta, militaire de carrière.
- **Rôle** : major de l'US Army, officière de liaison des forces américaines en Corée au moment du J0. Elle a pris le commandement de l'**Unité 0** (des restes de forces coréennes et américaines) à Yongsan, et détient le **code du Protocole Cendre**.
- **Archétype** : commandante de fer, autorité militaire, devoir avant tout.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m78 / 72 kg |
| **Morphologie** | Puissante et athlétique : **épaules larges**, bras musclés (biceps et deltoïdes dessinés), dos large, abdominaux marqués, taille ferme, **hanches et cuisses solides**, poitrine pleine et ferme. Une silhouette de militaire de terrain, qui court 10 km par jour même pendant l'apocalypse |
| **Peau** | **Brun foncé**, chaud et satiné, à sous-ton cuivré. Elle brille sous l'effort et la lumière des néons |
| **Visage** | Mâchoire **carrée** et forte, pommettes hautes, nez large et droit, **lèvres pleines** souvent serrées. Une **cicatrice** nette en diagonale sur la mâchoire gauche (un éclat, en Afghanistan). Beauté sévère qui s'illumine d'un sourire rare, très blanc |
| **Yeux** | En amande, profonds, **noir brun** très foncé, cils épais. Regard perçant de commandante, qui évalue les menaces. Des pattes-d'oie apparaissent quand elle rit enfin |
| **Cheveux** | Noirs et crépus (type 4C), en **tresses plaquées** (cornrows) serrées sur le dessus et le côté droit, **undercut rasé** sur le côté gauche. Tresses courtes à la nuque. En privé, elle les détache en un volume afro qui surprend tout le monde |
| **Signes particuliers** | Cicatrice à la mâchoire · **plaques d'identification** doubles au cou : les siennes et celles de Marcus, son fiancé · **bague de fiançailles** passée sur la chaîne des plaques · tatouage de l'insigne de son unité (un aigle) sur l'épaule droite · cicatrice chirurgicale au genou gauche |
| **Gestuelle** | Se tient bras croisés, jambes écartées (repos militaire). Parle en regardant droit dans les yeux. Fait tourner la bague de fiançailles sur la chaîne quand elle pense à Marcus. Allume un cigare uniquement les « jours où l'on a survécu » |
| **Voix** | Alto grave, puissante, accent d'Atlanta (le Sud) qui ressort dans l'émotion. Jure en anglais. Voix de commandement qui porte sans crier |
| **Style habituel** | Militaire en toutes circonstances : treillis multicam, veste de commandement aux manches retroussées, gilet tactique, béret noir à l'épaulette, bottes. En privé : débardeur kaki, jogging, pieds nus |
| **Palette (DA)** | Kaki, multicam, noir, or (insignes), rouge (cigare) |

- **Tenues** :
  - *base* : treillis multicam, veste de commandement aux manches retroussées, gilet porte-plaques, bottes, béret noir glissé sous l'épaulette ;
  - *combat* : **exosquelette léger** de l'Unité 0, avec un fusil d'assaut « éveillé » ;
  - *détente* : débardeur kaki, jogging, plaques au cou. Elle fume un unique cigare, réservé aux « jours où l'on a survécu ».
- **Personnalité** :
  - stricte, directe, pragmatique, humour militaire sec ;
  - protectrice envers ses soldats jusqu'au sacrifice ;
  - porte seule le poids de décisions impossibles ;
  - sur les axes : **Protéger +30, Lien +50**. Elle croit aux structures.
- **Aime / déteste** : le jazz, les échecs rapides, qu'on lui dise la vérité en face ; l'insubordination inutile, les fanatiques, les politiciens.
- **Fin du Registre** : *J28, Aube, silo d'artillerie de Yongsan. Meurt en déclenchant manuellement le Protocole Cendre après le sabotage du système automatique, en restant à son poste.*
  - Variante liée : *J24, Crépuscule, abattue par un sniper depuis la Lotte Tower* (§13.2).
  - **Cause profonde** : l'ultimatum extérieur (§6.7). Elle préfère sacrifier un secteur que la ville entière.
  - **Réécriture** :
    - faire baisser la Pression sous 50 avant le J27 (l'extérieur suspend alors le Protocole) ;
    - ou convaincre Simone de **désobéir**, ce qui demande une Confiance ≥ 85 ;
    - ou saboter le silo avec Maricel ou Minh-Anh, ce qui la met en danger face à ses propres hommes.
  - **Nouvelle Fin débloquée** : *J30, tuée en défendant le dernier pont pendant la Descente*.
- **Secret lié au Registre** : son fiancé, le capitaine Marcus Bell, est mort dans un accident d'entraînement à Yongsan il y a 2 ans. En réalité, il est mort pendant la **mission d'escorte de la sonde du Projet ARCHE**. Elle l'ignore. Le découvrir la fait basculer contre Haesong.
- **Passé sombre** :
  - en Afghanistan (2012), elle a **validé une frappe de drone** sur un « convoi ». C'était un cortège de mariage : 23 civils, dont 9 enfants. Elle garde la liste des noms pliée dans son gilet ;
  - elle **boit en cachette** (une flasque de bourbon dans le gilet tactique) et ne dort jamais plus de 4 heures.
- **Statut & passé intime** : **célibataire**, une fiancée en deuil. **Expérimentée** : plusieurs relations passées, puis Marcus, l'amour de sa vie. Abstinente depuis sa mort, il y a 2 ans.
- **Recrutement** :
  - *Héros* : défendre les réfugiés du Musée de la Guerre et partager ses informations sur la Tour (des Souvenirs) ;
  - *Mercenaire* : contrat de l'Unité 0 (missions dans la Tour) ;
  - *Tyran* : alliance de force à force si Elias possède un Sceau (elle reste méfiante), ou reddition de l'Unité 0 (**Pacte de Vassalité**) ;
  - *Loup* : elle peut l'employer comme éclaireur indépendant, avec un laissez-passer.
- **Trahison** :
  - **seuil** : Loyauté < 40 ;
  - **déclencheur absolu** : Elias menace la chaîne de commandement ou tente de voler le code du Protocole ;
  - **forme** : elle le fait **arrêter**, pas assassiner. Prison de Yongsan, puis évasion ou procès ;
  - **signes** : son laissez-passer est révoqué, des soldats le suivent, elle ne le tutoie plus.
- **Dynamiques** :
  - **Serment** : ✓, la route du « devoir contre l'amour », où elle désobéit pour lui ;
  - **Cour ouverte** : ✓, par pragmatisme : « on peut mourir demain, je ne vais pas faire de scène ». Respect mutuel avec Ryeon, tension avec Nadia ;
  - **Dévotion** : ✗ ;
  - **Pacte** : il s'obtient par la *Défaite* militaire (l'Unité 0 vaincue, ou Yongsan contrôlé par Elias). C'est une **reddition d'officier** : elle signe pour la survie de ses soldats. Ambivalence de départ **−20**. Ses scènes mettent en scène une commandante qui obéit à un nouveau chef, avec une discipline froide et un trouble de céder le commandement. Destin probable : **Rupture** au J28 (le devoir envers le Protocole Cendre l'emporte), sauf si Elias assume lui-même le poids du Protocole, ce qui mène à la **Dévotion** (« Enfin quelqu'un porte les ordres à ma place »). Hors Pacte, elle ne porte jamais de Masque : elle obéit à la hiérarchie.
- **Combat** : *Commandante*, au milieu.
  - *Tir de suppression* : retarde toute une ligne ennemie dans la frise ;
  - *À couvert !* : bouclier de groupe ;
  - *Ordre tactique* : fait rejouer immédiatement un allié ;
  - **Forme Exosquelette** : bascule en Rempart à l'avant pendant 3 tours ;
  - **Ultime** : *Frappe d'artillerie*, des dégâts de zone sur toute la grille ennemie, mais une case aléatoire du joueur est touchée.
- **Notes 18+** : assurée, directe, physique. Elle ne joue pas, elle prend ce qu'elle veut quand elle a décidé de vivre, puis se montre d'une douceur inattendue. Scènes clés : le bureau de commandement après le J24 (P3), le toit de la caserne (P2).

---

### 12.5 LONG XIAOYU (龙小雨) — « La Pluie du Dragon »
- **Âge / taille / poids** : 31 ans / **1m70 / 54 kg**. **Origine** : chinoise, née à Shanghai, à Séoul depuis ses 16 ans.
- **Rôle** : héritière et dirigeante de fait du **Consortium Longwei**, Seigneur des Ponts du Han. Son père, le Vieux Long, est mourant.
- **Archétype** : reine de la pègre, femme fatale, joueuse.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m70 / 54 kg |
| **Morphologie** | Élancée et féline, faite pour le qipao : épaules fines, **taille de guêpe**, hanches marquées, poitrine moyenne et haute, longues jambes fines (la fente du qipao les dévoile à chaque pas). Souplesse de danseuse (arts martiaux de l'éventail) |
| **Peau** | Ivoire pâle, lisse, presque lumineuse sous les néons du casino. Le **tatouage de dragon** (noir et or) court de l'épaule droite jusqu'à la hanche gauche, en travers du dos |
| **Visage** | Ovale en cœur, pommettes délicates, nez fin, **lèvres carmin** au sourire en coin permanent, **grain de beauté** sous l'œil gauche. Beauté provocante et théâtrale |
| **Yeux** | **Yeux de chat** étirés vers les tempes, paupière simple, eyeliner noir en aile prononcé. Iris **brun ambré**, presque doré à la lumière des lanternes |
| **Cheveux** | Noirs brillants, coupés en **carré net** à hauteur de la mâchoire, **frange droite** au ras des sourcils. Une **mèche teinte en rouge** à gauche, derrière l'oreille. Épingle à cheveux en jade (une arme) |
| **Signes particuliers** | Tatouage de dragon · ongles longs laqués de rouge · bague-sceau du Consortium à l'index · cicatrice de lame fine sous le sein gauche (une tentative d'assassinat à 19 ans), visible en CG intime · parfum de jasmin et de fumée d'opium |
| **Gestuelle** | Ouvre et ferme son éventail selon son humeur : **ouvert** avec ceux qu'elle apprécie, **fermé** comme une menace. Croise les jambes lentement. Pose le menton sur sa main pour écouter. Rit en se cachant derrière l'éventail |
| **Voix** | Mezzo suave, langoureuse, accent shanghaïen en coréen. Elle allonge les syllabes pour taquiner et passe au mandarin pour les insultes |
| **Style habituel** | **Qipao noir modernisé** fendu haut, brodé de dragons d'or, sous une **veste de cuir** noire cintrée. Bottines à talons, bas noirs. En privé : peignoir de soie rouge |
| **Palette (DA)** | Noir laqué, or, rouge carmin, jade |

- **Tenues** :
  - *base* : **qipao noir moderne** fendu haut, brodé de dragons d'or, sous une veste de cuir noire, bottines à talons, éventail de métal (**lames rétractables**) ;
  - *combat* : la même tenue, avec des gantelets à aiguilles empoisonnées et une ceinture de fioles ;
  - *détente* : peignoir de soie rouge sur la barge-casino, un mahjong en cours.
- **Personnalité** :
  - joueuse, provocante, théâtrale ; ment avec plaisir ;
  - **tient toujours un contrat**, c'est sa religion ;
  - aime le risque et les hommes qui la surprennent ;
  - en dessous, une fille qui a dû tuer pour exister dans un monde d'hommes ;
  - sur les axes : **Dominer +40, Solitude +20**.
- **Aime / déteste** : le mahjong, le baijiu millésimé, les paris absurdes ; l'ennui, les promesses rompues, Yoon Hae-in.
- **Fin du Registre** : *J19, Nuit, sur le Han. Poignardée puis jetée dans le fleuve noir par l'Oncle Fang et les Trois Lotus, en pleine mutinerie.*
  - **Cause profonde** : les anciens du Consortium refusent une femme à leur tête, et la Guerre de l'Eau a coûté trop cher. Fang a un acheteur pour le Sceau du Courant : Mirae.
  - **Réécriture** : il faut retourner l'un des Trois Lotus (2 Souvenirs nécessaires), ou être à bord du *Dragon Pâle* le soir du J19, ou faire réussir la Guerre de l'Eau sans pertes.
  - **Nouvelle Fin débloquée** : *J28, si elle a trahi Elias, tuée par lui ; sinon, mourante d'un poison du Prophète*.
- **Secret lié au Registre** : c'est **elle** qui a fait empoisonner lentement son père, pour prendre la tête du clan avant qu'il ne la marie de force. Le Vieux Long le sait, et il l'a pardonnée. Il lui reste une lettre à lui remettre.
- **Passé sombre** :
  - fille de la seconde épouse, élevée comme une **monnaie d'échange** ;
  - à 25 ans, son père l'a promise à un parrain de Hong Kong de 63 ans. Le soir même, elle a commencé à l'empoisonner : de l'**arsenic dans son thé**, pendant 2 ans ;
  - elle a fait **noyer** elle-même son premier lieutenant traître dans le Han, les mains liées, en le regardant. Elle sourit en le racontant.
- **Statut & passé intime** : **célibataire**. **Expérimentée** : la séduction est son arme, et ses amants sont des outils qu'elle congédie au matin. Personne ne l'a jamais « possédée » : c'est précisément ce qu'elle désire et ce qu'elle redoute.
- **Recrutement** :
  - *Mercenaire* : la voie royale, par des contrats successifs. Trois contrats honorés donnent une alliée ;
  - *Tyran* : la vaincre **à son propre jeu** (pari, duel, OPA sur les ponts). Elle respecte la force et devient une partenaire de pouvoir, liée par un **Pacte** qu'elle honore ;
  - *Héros* : difficile. Il faut la sauver au J19 sans lui faire la morale ;
  - *Loup* : elle l'embauche comme lame anonyme ; la romance est possible mais lente.
- **Trahison** :
  - **seuil** : Loyauté < 40 ;
  - **déclencheur absolu** : **rompre un contrat** avec elle, quelle que soit la Loyauté ;
  - **forme** : elle vend sa tête au plus offrant, avec élégance, et prévient par une lettre parfumée la veille ;
  - **signes** : l'éventail fermé (elle le garde ouvert avec ceux qu'elle aime bien), des tarifs qui montent, des rendez-vous annulés.
- **Dynamiques** :
  - **Serment** : ✓, mais seulement si Elias **parie tout sur elle**, littéralement, à la table de mahjong du destin ;
  - **Cour ouverte** : ✓✓, elle adore la compétition. Rivalité ouverte avec Hae-in, complicité avec Maricel ;
  - **Dévotion** : ✓, **trait présent**. Elle désire un homme qui la domine *loyalement*, au jeu comme au lit. C'est sa part secrète, qu'elle n'admet qu'à Confiance ≥ 85 ;
  - **Pacte** : il s'obtient par la *Défaite* à son propre jeu (pari à enjeu total, OPA sur les ponts) ou par le *Secret* (le poison de son père). Ambivalence de départ **+10** : un contrat perdu loyalement, elle l'honore religieusement. Ses scènes mettent en scène une joueuse qui paie sa dette avec panache, puis découvre qu'elle **aime perdre contre lui**. Destin probable : **Dévotion**. Le **Couteau est immédiat** si Elias viole une seule clause, car la parole est sa religion. Par défaut, elle porte toujours un Masque à moitié.
- **Combat** : *Éventail de Jade*, au milieu.
  - *Mille Aiguilles* : poisons cumulatifs ;
  - *Pas du Dragon* : esquive, et échange de place avec un ennemi ;
  - *Pari* : 50 % de chances de doubler son tour, sinon de le perdre ;
  - **Ultime** : *Pluie du Dragon Noir*, qui fait exploser tous les poisons actifs.
- **Notes 18+** : séductrice qui mène le jeu… jusqu'à ce qu'on la batte, ce qui révèle sa part de Dévotion. Joue avec les règles et les rôles. Scènes clés : la suite de la barge-casino (P3), la partie de mahjong « strip » (P2, humoristique).

---

### 12.6 AOI TSUKISHIRO (月代葵) — « L'Idol des Ruines »
- **Âge / taille / poids** : 22 ans / **1m60 / 47 kg**. **Origine** : japonaise, née à Osaka. Stagiaire, puis débutante, dans l'agence K-pop de Mirae Dynamics depuis ses 18 ans.
- **Rôle** : idol bloquée à Hongdae, éveillée en classe ***Diva*** (chant amplifié par le Système). Mirae l'utilise comme « voix de l'espoir » pour **calmer et contrôler les foules**.
- **Archétype** : idol brisée, rayon de soleil de façade, dépression cachée.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m60 / 47 kg |
| **Morphologie** | Fine et tonique, une **silhouette de danseuse** : épaules délicates, taille très fine, ventre plat dessiné par les chorégraphies, hanches légères, poitrine petite à moyenne, jambes galbées et musclées (huit ans de danse). Proportions adultes, élégantes et sportives |
| **Peau** | Claire, teint de porcelaine travaillé par les soins d'agence, avec de légères taches de rousseur sur le nez quand le maquillage disparaît (après le J1) |
| **Visage** | Petit visage en V, grands yeux expressifs, nez fin, lèvres en cœur. Une **fossette** à droite quand elle sourit vraiment, et seulement dans ce cas. Son sourire de scène, parfait, n'en a pas |
| **Yeux** | Grands, légèrement arrondis, paupière double. Iris **noisette clair** aux reflets verts. Maquillage de scène pailleté et rosé qui **coule** après le J1 |
| **Cheveux** | **Bicolores** : noir sur le dessus, **rose pastel** sur la moitié inférieure (teinture d'agence). Mi-longs, jusqu'à la poitrine, coiffés en **twin-tails basses** ou détachés et légèrement ondulés. La racine noire repousse au fil des jours (une progression visuelle) |
| **Signes particuliers** | **Pansements** colorés aux doigts (ampoules de répétitions) · **bracelets serrés au poignet gauche** qui cachent la cicatrice de sa tentative de suicide et des marques d'automutilation · piercing en étoile au lobe gauche · petite cicatrice au genou droit (une chute en concert) · numéro de stagiaire « 0417 » tatoué discrètement sur la nuque, imposé par l'agence, qu'elle déteste · porte-clés en forme de poulpe (takoyaki) accroché à son micro |
| **Gestuelle** | En public : poses d'idol, cœurs avec les doigts, sourire figé. En privé : se recroqueville en boule, tire sur ses manches, fredonne quand elle est anxieuse. Rit fort et sans retenue quand elle oublie d'être une idol, avec l'accent d'Osaka |
| **Voix** | Soprano claire et cristalline, d'une justesse parfaite quand elle chante. Voix parlée plus grave et éraillée qu'on ne l'imagine. Dialecte du Kansai quand elle se détend |
| **Style habituel** | Avant : des tenues de scène imposées. Après le J1 : **sweat à capuche gris oversize**, casquette, masque, short en jean, baskets, c'est son « vrai moi ». Garde une veste de scène pailletée sur le dos, par défi |
| **Palette (DA)** | Rose pastel, noir, blanc, paillettes argent, gris (sweat) |

- **Tenues** :
  - *base* : tenue de scène déchirée (veste à paillettes, jupe-short à volants, bottes plates), bomber oversize par-dessus ;
  - *combat* : micro-casque transformé en arme sonore, et un ruban-scène lumineux ;
  - *civil* : sweat à capuche gris trop grand, masque, casquette, son « vrai moi » ;
  - *concert du J9* : tenue blanche et dorée, angélique, la tenue de la Fin.
- **Personnalité** :
  - joyeuse, pétillante et attentionnée en public ;
  - épuisée, anxieuse et en quête de sens en privé ;
  - un humour d'Osaka qui ressort quand elle se détend ;
  - n'a jamais rien choisi de sa vie ;
  - sur les axes : **Protéger +40, Lien +30**.
- **Aime / déteste** : les takoyaki, les vieux jeux vidéo, chanter pour une seule personne ; les caméras, les contrats, qu'on lui dise de sourire.
- **Fin du Registre** : *J9, Nuit, scène de la Rue des Clubs. Le concert « de l'espoir » organisé par Mirae est un piège : la foule rassemblée sert d'appât pour tester l'amplificateur de Minh-Anh. Aoi est écrasée par la Marée attirée par son propre chant.*
  - **Cause profonde** : le PDG Jang a besoin de données de foule pour la Machine d'Inversion.
  - **Réécriture** :
    - convaincre Aoi d'annuler (Confiance ≥ 40) ;
    - ou saboter l'amplificateur (avec Minh-Anh, ou par un vol) ;
    - ou transformer le concert en **contre-piège** (Défense de Hongdae ≥ 50 et embuscade).
  - **Nouvelle Fin débloquée** : *J22, siège de Myeongdong, elle chante jusqu'à la mort pour couvrir l'évacuation*.
- **Secret lié au Registre** : son chant ne fait pas que calmer. Il **réécrit brièvement les émotions** : c'est un fragment du même pouvoir que le Registre. Elle sent quand Elias régresse (rêves de « chansons qu'elle n'a jamais écrites »).
- **Passé sombre** (la vérité brute) :
  - stagiaire à 18 ans, sous **contrat d'esclave** : une dette de formation de 300 millions de wons, des **pesées publiques** chaque semaine, un régime à 600 calories, l'interdiction de toute relation. Boulimie cachée pendant trois ans ;
  - à 21 ans, l'agence l'envoie « dîner » avec un **sponsor** : le PDG **Jang Woo-hyun** lui-même, dans une suite d'hôtel ;
  - elle s'enferme dans la salle de bains et **s'ouvre le poignet gauche** pour que la nuit n'ait pas lieu. L'agence étouffe l'affaire (« surmenage ») ;
  - depuis, des épisodes d'**automutilation** sporadiques. Ses bracelets et ses pansements cachent les cicatrices. Jang est vivant, et il veut récupérer « son investissement ».
- **Statut & passé intime** : **célibataire** (l'agence interdisait toute relation). **Aucune expérience (vierge).** Son corps a été la propriété de l'agence : sa route parle de **se le réapproprier**, ou, dans sa version sombre, d'en changer seulement de propriétaire.
- **Recrutement** :
  - *Héros* : la sauver au J9, puis l'aider à rompre son contrat ;
  - *Loup* : l'enlever discrètement à Mirae, dans un arc « cavale » romantique ;
  - *Mercenaire* : la « racheter » à Mirae. Elle vous suit, mais se sent possédée (Affinité lente) ;
  - *Tyran* : la racheter et l'utiliser comme voix de propagande, ce qui ouvre un **Pacte de Vassalité** et aggrave sa dépression.
- **Trahison** :
  - **seuil** : Loyauté < 35 ;
  - **déclencheur absolu** : Elias la force à chanter pour contrôler des gens ;
  - **forme** : on la fait chanter (chantage de Mirae sur sa famille à Osaka, via le canal militaire) : elle livre la position du Refuge à Mirae, puis s'effondre de remords ;
  - **signes** : elle chante faux, sort la nuit, reçoit des « messages » qu'elle cache.
- **Dynamiques** :
  - **Serment** : ✓, la route de la « chanson pour une seule personne », sa libération ;
  - **Cour ouverte** : ✓, elle apprécie la « famille » et adore Maricel et Seo-Yeon. Cohésion facile ;
  - **Dévotion** : ✓, en variante sombre, la **Dévotion conditionnée**. Son obéissance d'idol se transfère sur Elias : elle devient parfaite, souriante, docile… et se perd. Elle mène à la fin sombre *La Poupée*. Sa route lumineuse reste la reconquête de son autonomie (*« Je choisis »*) ;
  - **Pacte** : il s'obtient par la *Dépossession*, en rachetant son contrat à Mirae (elle passe d'un propriétaire à un autre). Ambivalence de départ **−20**. Ses scènes de Pacte sont parmi les plus sombres du jeu, car elles rejouent son histoire de contrôle : sourire de scène, obéissance parfaite, une idol qui « performe » la soumission. Destin probable : **Couteau** (le chantage de Mirae) ou la **Rupture libératrice**, son arc *« Je choisis »*, où elle brise le Pacte et chante pour elle-même. Si l'Ambivalence monte sans qu'Elias la libère jamais, elle glisse vers la **Dévotion conditionnée** (fin *La Poupée*). Le Masque, elle en a l'expérience (le métier d'idol), et le sien est quasi parfait.
- **Combat** : *Diva*, en arrière.
  - *Encore !* : buff d'attaque de groupe ;
  - *Ballade* : soin sur la durée ;
  - *Fausse Note* : charme un ennemi, qui attaque ses alliés pendant 1 tour ;
  - **Ultime** : *Dernier Rappel*, la scène s'illumine, tous les alliés rejouent et les ennemis sont étourdis ;
  - **Synergie Aoi + Héritière** : *Hymne du Seuil*.
- **Notes 18+** : affectueuse, curieuse, joueuse. Découvre ce qu'elle veut *elle* ; le consentement est un thème explicite de sa route. Scènes clés : le studio d'enregistrement abandonné (P2), la nuit après la rupture de contrat (P3).

---

### 12.7 NADIA TSOI (Надя Цой / 최나디아) — « Le Reflet Blanc »
- **Âge / taille / poids** : 34 ans / **1m76 / 63 kg**. **Origine** : **Koryo-saram**, une Coréenne d'Asie centrale née à Almaty (Kazakhstan). Ancienne tireuse d'élite de l'armée kazakhe, puis mercenaire internationale.
- **Rôle** : contractuelle de **Cheonma** (Exécutrice n°3), basée à Gangnam. Elle travaille pour qui paie. C'est la tireuse qui a tué Elias dans sa première vie.
- **Archétype** : sniper mercenaire, louve solitaire, cynique au cœur gelé.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m76 / 63 kg |
| **Morphologie** | Grande, **sèche et nerveuse** : épaules droites, bras longs aux muscles fins (tireuse), abdominaux secs, hanches étroites, poitrine moyenne, longues jambes. Une silhouette de prédatrice qui peut rester immobile 12 heures |
| **Peau** | Très pâle, froide, presque translucide aux tempes et aux poignets (veines bleutées). Elle rosit au froid, aux pommettes et au nez |
| **Visage** | Anguleux, entre l'Asie centrale et la Corée : **pommettes très hautes et saillantes**, mâchoire fine et nette, nez droit et étroit, lèvres pâles et minces, souvent avec une **cigarette éteinte** au coin. Beauté froide de statue |
| **Yeux** | En amande étirée, paupière simple, légèrement bridés. Iris **gris pâle**, presque argentés et translucides, d'un regard de lunette de visée. Cernes permanents |
| **Cheveux** | **Blanc platine** (décoloration entretenue, sa racine naturelle est noire), courts : **undercut** rasé à droite et à la nuque, **mèche longue asymétrique** qui tombe sur l'œil droit. C'est le « reflet blanc » du Souvenir n°5 |
| **Signes particuliers** | **Écharpe de laine rouge** élimée (tricotée par sa grand-mère, qu'elle ne porte qu'avec ceux en qui elle a confiance) · cal à l'index droit et à l'épaule droite (la crosse) · tatouages de cyrillique sur les côtes (les noms des 7 camarades morts) · cicatrice de brûlure au dos de la main gauche · odeur de tabac froid et de poudre |
| **Gestuelle** | Économie absolue de mouvement. Fixe sans cligner des yeux. Joue avec un briquet Zippo qu'elle n'allume jamais. S'assoit toujours dos au mur, face à la porte. Tête légèrement penchée quand quelque chose l'intrigue |
| **Voix** | Contralto basse, rauque (le tabac), monocorde. Accent russe en coréen, phrases courtes. Murmure plutôt qu'elle ne parle |
| **Style habituel** | **Long manteau militaire gris ardoise**, col roulé noir, pantalon de combat, mitaines, bottes. En privé : **chemise d'homme trop grande**, jambes nues, une bouteille de vodka |
| **Palette (DA)** | Gris ardoise, noir, blanc platine, rouge (écharpe) |

- **Tenues** :
  - *base* : long manteau militaire gris ardoise, col roulé noir, pantalon de combat, mitaines, écharpe de laine rouge élimée ;
  - *combat* : poncho de camouflage urbain, **fusil anti-matériel** « Saïga » éveillé, lunette à reflet blanc ;
  - *détente* : chemise d'homme trop grande, une bouteille de vodka, un vieux vinyle de Viktor Tsoi.
- **Personnalité** :
  - laconique, sarcastique, professionnelle jusqu'à l'os ;
  - croit que l'attachement tue ; ne promet jamais rien ;
  - humour noir russe ;
  - en dessous, une profonde fatigue de tuer et le besoin d'être vue par quelqu'un qui n'a pas peur d'elle ;
  - sur les axes : **Dominer +10, Solitude +70**.
- **Aime / déteste** : le silence, la neige, les chats errants, le rock soviétique ; les bavards, les héros, la pitié.
- **Fin du Registre** : *J24, Crépuscule, toit de la Lotte World Tower. Abattue par le contre-sniper de l'Unité 0 alors qu'elle exécute son contrat sur la Commandante Hayes.*
  - Variante : *si elle réussit, c'est Simone qui meurt*, et Nadia meurt au J30.
  - **Cause profonde** : Cheonma (pour le compte du Prophète) l'a engagée pour décapiter l'Unité 0 avant la Descente. C'est son dernier contrat, avec assez d'argent pour disparaître… dans une ville sans sortie.
  - **Réécriture** : il faut la convaincre d'abandonner le contrat (Confiance ≥ 60, plus *rompre un contrat* contre ses principes), ou payer davantage (racheter le contrat), ou prévenir Simone sans faire tuer Nadia (un défi diplomatique, voir les Fins liées §13.2).
  - **Nouvelle Fin débloquée** : *J30, 23h58, toit de l'étage 10 : elle tire sur Elias… ou sur celui qui la payait.* C'est l'écho de la première vie.
- **Secret lié au Registre** : elle a **tué Elias** au J30 de la première vie, sur contrat du **Prophète des Élus**. Et elle a une sensation persistante de l'avoir **déjà vu dans sa lunette**. Après deux boucles avec une relation forte, elle se souvient de l'avoir tué, ce qui ouvre un arc de culpabilité et de rédemption majeur.
- **Passé sombre** :
  - née dans un quartier pauvre d'Almaty, traitée de « *koreika* » par les Kazakhs et de « Russe » par les Coréens. Un père violent, mort d'avoir trop bu ;
  - tireuse d'élite à 19 ans, puis mercenaire en Syrie et au **Sahel**, **la même année qu'Elias, dans le camp d'en face** : ils ont pu se croiser dans une lunette ;
  - sur contrat, elle a abattu un **enfant-soldat de 13 ans** qui portait une ceinture d'explosifs. Ce fut sa première nuit sans sommeil d'une longue série.
- **Statut & passé intime** : **célibataire**. **Expérimentée** : des aventures froides, sans lendemain. Un seul amour, **Dmitri**, l'observateur de son binôme, mort dans ses bras à Alep. Personne depuis.
- **Recrutement** :
  - *Loup* : la voie royale. Elle reconnaît un semblable : survivre ensemble lors d'une nuit de Marée (2 personnes contre la nuée) ;
  - *Mercenaire* : la payer plus cher que Cheonma ;
  - *Tyran* : racheter son contrat à vie (**Pacte de Vassalité**). Si l'Ambivalence chute, elle tirera au pire moment ;
  - *Héros* : difficile. Elle méprise les « héros ». Il faut lui sauver la vie sans le lui faire remarquer.
- **Trahison** :
  - **seuil** : Loyauté < 50, le plus élevé, car elle est mercenaire par nature ;
  - **déclencheur absolu** : quelqu'un offre plus, et la Confiance < 60 ;
  - **forme** : une balle, de loin, au moment critique (J30 si elle n'est pas « réécrite ») ;
  - **signes** : elle nettoie son fusil devant Elias en silence, l'écharpe rouge disparaît (elle ne la porte qu'avec ceux en qui elle a confiance), et elle demande un jour : « tu as déjà pensé à la façon dont tu mourrais ? ».
- **Dynamiques** :
  - **Serment** : ✓, la route « deux loups ». Elle jette son fusil du haut de l'étage 10. Fin émotionnellement la plus forte du jeu ;
  - **Cour ouverte** : réticente (« je ne fais pas la queue »). Seulement avec une Cohésion ≥ 70 et si Ryeon ou Simone en font partie (respect des guerrières) ;
  - **Dévotion** : ✗ ;
  - **Pacte** : il s'obtient par la *Dépossession*, en rachetant son contrat **à vie**, ce qui fait de l'arme le bien d'Elias. Ambivalence de départ **−30**. Ses scènes sont froides et silencieuses, chargées de défi : la louve tolère la laisse en mesurant la distance jusqu'à la gorge. Destin probable : **Couteau**, une balle au moment critique (la plus létale du jeu). Exception : si Elias réécrit sa Fin du J24 et qu'elle se souvient de l'avoir tué (arc de culpabilité), l'Ambivalence bascule brutalement, de +50. **La Dévotion lui reste fermée** ; son seul destin positif est la Rupture, puis le retour libre (route Serment).
- **Combat** : *Fantôme de Steppe*, en arrière.
  - *Tir d'élite* : ignore la ligne avant et frappe n'importe quelle case ;
  - *Marquage* : tous les alliés font +30 % de dégâts à la cible ;
  - *Repositionnement* : invisible pendant 1 tour ;
  - **Ultime** : *Balle de 23h58*, élimination instantanée d'un ennemi non-boss, ou 60 % des PV d'un boss.
- **Notes 18+** : brusque, intense, peu de mots ; la vulnérabilité post-intimité est le vrai enjeu. Elle ne reste jamais jusqu'au matin… jusqu'au jour où elle reste. Scènes clés : le toit de sa planque sous la neige de cendres (P3), « le matin où elle est restée » (P2).

---

### 12.8 MARICEL « CEL » DIZON — « La Reine des Rats »
- **Âge / taille / poids** : 26 ans / **1m57 / 50 kg**. **Origine** : philippine, née à Cebu. Arrivée à Séoul à 20 ans comme employée de maison, elle a fui un employeur abusif et vit depuis dans l'économie informelle.
- **Rôle** : cheffe des équipes de récupération des **Rats du Han**. Elle gère le **Marché Souterrain** de Myeongdong. Héritière désignée de « Grand-père Pigeon », elle connaît **chaque tunnel** de la ville.
- **Archétype** : voleuse solaire, débrouillarde, cœur sur la main et doigts dans votre poche.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m57 / 50 kg |
| **Morphologie** | Petite, vive et **pulpeuse** : épaules arrondies, taille marquée, **hanches et fesses rondes**, poitrine généreuse pour sa taille, cuisses fortes (elle grimpe partout), bras toniques. Une silhouette de grimpeuse énergique |
| **Peau** | **Dorée**, brun chaud et lumineux, à sous-ton miel. Quelques cicatrices claires d'écorchures aux genoux et aux coudes |
| **Visage** | Rond et rieur : joues pleines, **fossettes** profondes des deux côtés, nez petit et légèrement épaté, lèvres charnues, **grain de beauté** au-dessus de la lèvre supérieure, à droite. Expression malicieuse permanente |
| **Yeux** | Grands, en amande arrondie, paupière double, cils longs. Iris **brun foncé** chaud et pétillant. Un clin d'œil facile |
| **Cheveux** | Noirs, **ondulés**, mi-longs (sous les épaules), avec des **mèches décolorées cuivre** sur le devant. Le plus souvent sous une **casquette retournée**, en queue basse ou en chignon flou |
| **Signes particuliers** | **Tatouage de soleil philippin** (8 rayons) sur l'épaule gauche · une dizaine de **bracelets** (perles, cordons, montres volées) aux deux poignets · dent légèrement de travers (canine gauche), visible quand elle rit · cicatrice en étoile au mollet droit (l'effondrement d'un tunnel, il y a 3 ans) · odeur d'huile de coco et de poussière de métro |
| **Gestuelle** | Ne tient pas en place, s'assoit sur les tables et les rambardes. Fait tourner un objet volé entre ses doigts. Parle avec les mains. Pose la tête sur l'épaule des gens sans prévenir. Se fige et respire vite dans les espaces clos (claustrophobie) |
| **Voix** | Mezzo chaude et pétillante, rire communicatif. Elle mélange coréen, anglais et cebuano (« *Ay, gwapo!* »), et accélère quand elle ment |
| **Style habituel** | Streetwear de récupération : **crop hoodie jaune moutarde**, débardeur, **cargo vert olive** aux poches pleines, baskets montantes, sac banane, casquette. En privé : un maillot de basket trop grand comme robe |
| **Palette (DA)** | Jaune moutarde, vert olive, cuivre, or (bijoux) |

- **Tenues** :
  - *base* : crop hoodie jaune moutarde, débardeur, pantalon cargo vert olive aux poches pleines, baskets montantes, multiples bracelets, sac banane ;
  - *combat* : **gants à griffes** rétractables, cordes et grappin, lampe frontale ;
  - *détente* : t-shirt de basket trop grand, short, cheveux en chignon flou ; elle cuisine de l'adobo pour tout le Refuge.
- **Personnalité** :
  - joyeuse, bavarde, taquine, d'une intelligence de rue redoutable ;
  - loyale à sa « famille » (ses Rats) avant tout ;
  - méfiante envers les puissants ; panique en espace clos depuis un effondrement passé ;
  - sur les axes : **Protéger +30, Lien +50**, envers les siens.
- **Aime / déteste** : le karaoké, les mangues séchées, les paris sur tout et n'importe quoi ; les patrons, les menteurs riches, les tunnels qui craquent.
- **Fin du Registre** : *J14, Aube, tunnels de l'ère coloniale sous Myeongdong. Ensevelie avec 11 de ses Rats lors d'un effondrement.*
  - **Cause profonde** : Mirae a foré sous Myeongdong pour poser des capteurs (et le Prophète a saboté les étais pour isoler la cathédrale avant le siège du J22).
  - **Réécriture** : il faut **étayer les tunnels** (matériaux, 2 phases de travail, Ancrage possible), ou empêcher l'expédition du J14, ou découvrir les foreuses de Mirae.
  - **Nouvelle Fin débloquée** : *J22, siège de Myeongdong, elle retourne chercher un enfant dans le Marché en feu*.
- **Secret lié au Registre** : les tunnels mènent à **« La Racine »**, une cavité sous Yongsan où la Tour plonge ses fondations… et où se trouve **la sonde du Projet ARCHE**. Maricel y est allée une fois et y a vu « une femme endormie dans le mur ». Ce lien avec l'Héritière n'est pas révélé au début.
- **Passé sombre** :
  - employée de maison à 20 ans chez un couple de Gangnam : **passeport confisqué**, salaire retenu, enfermée la nuit dans une pièce sans fenêtre (l'origine de sa claustrophobie), harcelée par le mari ;
  - la nuit où il a forcé sa porte, elle l'a **poignardé avec des ciseaux de cuisine** et s'est enfuie par la fenêtre. Elle ignore s'il a survécu : il est vivant, devenu vassal de Cheonma, et on peut le croiser ;
  - ensuite, la rue et le vol pour manger, jusqu'à ce que Grand-père Pigeon la recueille.
- **Statut & passé intime** : **célibataire**. Une seule relation, avec **Jun-ho**, un Rat qui l'a **vendue** à des recruteurs l'an dernier ; elle s'en est sortie seule. Expérience limitée, et une méfiance totale envers les hommes qui « promettent ».
- **Recrutement** :
  - *Loup / Mercenaire* : la voie naturelle. Échanges, vols en duo, paris ;
  - *Héros* : protéger les Rats et les tunnels ;
  - *Tyran* : prendre le contrôle du Marché Souterrain, ce qui ouvre un **Pacte de Vassalité**. Si l'Ambivalence chute, elle vole Elias jusqu'à l'os puis disparaît dans les tunnels.
- **Trahison** :
  - **seuil** : Loyauté < 35 ;
  - **déclencheur absolu** : Elias menace ou sacrifie ses Rats ;
  - **forme** : elle **vend des informations** sur Elias au plus offrant pour protéger sa famille (« Désolée, beau gosse. Ce n'est pas personnel ») ;
  - **signes** : elle fait des blagues forcées, des objets d'Elias disparaissent (encore plus que d'habitude), ses Rats l'évitent.
- **Dynamiques** :
  - **Serment** : ✓, la route du « soleil sous la ville », elle lui montre le ciel des toits ;
  - **Cour ouverte** : ✓✓, très ouverte et rassembleuse : bonus de Cohésion +10 quand elle est liée. Meilleure amie d'Aoi, complice de Xiaoyu ;
  - **Dévotion** : ✗ (la liberté est sa valeur cardinale) ;
  - **Pacte** : il s'obtient par la *Dette de vie* (Elias sauve ses Rats des tunnels, en échange de sa servitude) ou par le contrôle du Marché Souterrain. Ambivalence de départ **−10**. Ses scènes oscillent entre humour défensif et **sentiment d'être enfermée**, une angoisse liée à sa claustrophobie, qui fait partie de la tension dramatique. Destin probable : **Rupture par la fuite** (elle disparaît dans les tunnels avec la moitié de la Forteresse dans les poches). La Dévotion est impossible, car la liberté est sa valeur cardinale. Une version « **Pacte léger** » existe : si Elias lui laisse la clause de Résidence ouverte, l'Ambivalence monte deux fois plus vite.
- **Combat** : *Voleuse des Profondeurs*, à l'avant ou au milieu, mobile.
  - *Vol à la tire* : vole un objet ou un buff ennemi ;
  - *Grappin* : tire un ennemi de l'arrière vers l'avant ;
  - *Piège à rats* : immobilise une case ;
  - *Échange* : permute deux alliés gratuitement ;
  - **Ultime** : *Jackpot*, vol de masse de tous les buffs ennemis, redistribués aux alliés.
- **Notes 18+** : rieuse, spontanée, sans complexe. La légèreté cache une vraie peur de l'abandon. Scènes clés : les toits de Myeongdong la nuit (P2), sa cachette secrète au-dessus du Marché (P3).

---

### 12.9 DR. TRAN MINH-ANH (쩐민안) — « L'Œil de Mirae »
- **Âge / taille / poids** : 36 ans / **1m66 / 53 kg**. **Origine** : vietnamo-coréenne. Père coréen, mère vietnamienne, issue d'une famille multiculturelle de Busan.
- **Rôle** : **directrice scientifique de Mirae Dynamics** (laboratoire Sous-niveau 9). Spécialiste de l'interface neuronale, devenue la meilleure analyste mondiale du Système. Elle a travaillé chez Haesong Bio (Projet ARCHE) jusqu'à il y a 18 mois.
- **Archétype** : scientifique froide, génie obsessionnelle, éthique ambiguë.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m66 / 53 kg |
| **Morphologie** | Élancée et longiligne, un peu frêle : épaules fines, taille mince, hanches douces, poitrine moyenne, longues mains de pianiste. Une silhouette de quelqu'un qui oublie son corps, mais dont la combinaison ajustée souligne les lignes |
| **Peau** | Teint **olive clair** doré, hérité de sa mère vietnamienne, que le travail de nuit rend un peu terne. Cernes violacés permanents |
| **Visage** | Ovale fin, pommettes douces, nez délicat légèrement retroussé, lèvres pleines et naturellement foncées. Un visage beau et absent, dont l'expression reste neutre, comme suspendue dans un calcul |
| **Yeux** | Légèrement en amande, paupière simple. Iris **brun très sombre**, presque noir. Derrière des **lunettes rectangulaires fines** à monture noire. Le regard se perd dans le vide quand elle calcule, puis se focalise brutalement |
| **Cheveux** | **Noirs**, raides, **extrêmement longs**, en **tresse unique** qui descend jusqu'aux reins, tenue par un élastique de câble électrique. Défaite, c'est une cascade noire qui la couvre comme un manteau |
| **Signes particuliers** | **Implants cybernétiques** à la tempe droite : trois ports argentés et une ligne de LEDs **bleues** qui clignotent quand elle réfléchit, ou **rouges** quand elle est émue, ce qu'elle déteste car elles la trahissent · manucure noire écaillée · taches d'encre et de soudure sur les doigts · petite cicatrice d'opération derrière l'oreille droite · odeur de café et d'ozone |
| **Gestuelle** | Mordille la branche de ses lunettes. Parle en regardant sa tablette. Envahit l'espace personnel des autres sans s'en rendre compte (pour « observer »). Prend des notes pendant les moments intimes, ce qui donne un humour involontaire |
| **Voix** | Mezzo neutre et précise, débit rapide, vocabulaire technique, aucune intonation émotionnelle… jusqu'à ce qu'elle craque. Léger accent de Busan |
| **Style habituel** | **Longue blouse de laboratoire blanche** sur une **combinaison noire ajustée**, bottes de sécurité, tablette holographique au poignet. En privé : pull à col roulé noir trop grand, chaussettes dépareillées |
| **Palette (DA)** | Blanc clinique, noir, bleu néon (LEDs), argent |

- **Tenues** :
  - *base* : longue blouse de laboratoire blanche sur une combinaison noire ajustée, bottes de sécurité, tablette holographique au poignet ;
  - *combat* : la blouse se déploie en **essaim de drones**, avec une visière d'analyse ;
  - *détente* : pull à col roulé noir, café froid, quinze onglets ouverts.
- **Personnalité** :
  - brillante, distante, curieuse jusqu'à l'inconscience ;
  - aucun filtre social ; humour pince-sans-rire involontaire ;
  - voit les gens comme des énigmes : Elias est la plus belle qu'elle ait jamais rencontrée ;
  - en dessous, la culpabilité d'ARCHE et la peur de n'être « que son cerveau » ;
  - sur les axes : **Dominer +15, Solitude +40**.
- **Aime / déteste** : les problèmes insolubles, le café glacé vietnamien, les puzzles mécaniques ; l'incompétence, les métaphores, qu'on interrompe ses calculs.
- **Fin du Registre** : *J26, Nuit, laboratoire Sous-niveau 9. Désintégrée par la surcharge de la Machine d'Inversion, qu'elle teste sur elle-même faute de « cobaye volontaire ».*
  - **Cause profonde** : le PDG Jang exige une régression artificielle avant la Descente. Sans données sur un vrai régresseur, la machine est instable.
  - **Réécriture** :
    - **lui donner accès aux données du Registre**, au risque qu'elle comprenne trop ;
    - ou saboter la Machine et l'en extraire ;
    - ou lui prouver que la régression a un **coût humain** (lui révéler les morts répétées d'une héroïne).
  - **Nouvelle Fin débloquée** : *J30, l'étage 10 la « recrute » comme nouvelle administratrice de la Tour*.
- **Secret lié au Registre** : dès la boucle 2, ses capteurs détectent les **anomalies temporelles** d'Elias. Elle sait qu'il est un régresseur, et elle hésite entre l'**aider**, le **disséquer** ou **le livrer à Jang**. De plus, la Machine d'Inversion repose sur des schémas extraits… de la sonde ARCHE, c'est-à-dire de l'Héritière.
- **Passé sombre** :
  - enfant surdouée, harcelée à Busan comme « fille de mariage acheté » : son père a trouvé sa mère vietnamienne par une agence matrimoniale ;
  - chez Haesong Bio (Projet ARCHE), elle a dirigé les tests d'interface neuronale sur **14 « volontaires »**, des sans-abri payés 200 000 wons. **9 sont morts ou restés à l'état végétatif.** Elle a signé les rapports ;
  - elle s'est implanté elle-même ses ports neuronaux, sous anesthésie locale, devant un miroir.
- **Statut & passé intime** : **célibataire**. **Aucune expérience (vierge)** : elle considère le sexe comme « un protocole inefficace jamais testé ». Sa curiosité clinique cache une peur panique d'être touchée.
- **Recrutement** :
  - *Mercenaire* : un échange de données (des Souvenirs contre son aide technique) ;
  - *Héros* : l'arracher à Mirae et la confronter à l'éthique (une route proche de la rédemption) ;
  - *Tyran* : la financer, la protéger et lui donner des « sujets ». **Pacte de Vassalité** faustien, qu'elle peut même apprécier ;
  - *Loup* : complice de piratage à distance (romance par messages, puis en personne).
- **Trahison** :
  - **seuil** : Loyauté < 40 ;
  - **déclencheur absolu** : refuser **trois fois** l'accès au Registre alors qu'elle sait déjà, ou détruire ses recherches sans son accord ;
  - **forme** : elle implante un **traceur** dans Elias pendant un soin, et livre ses données de boucle à Jang ;
  - **signes** : des questions trop précises sur ses rêves, des seringues « vitamines », une LED qui clignote dans son labo quand il dort.
- **Dynamiques** :
  - **Serment** : ✓, la route « l'équation qui n'a qu'une solution ». Elle comprend enfin ce qui ne se calcule pas ;
  - **Cour ouverte** : ✓, indifférente à la jalousie (« la monogamie est une construction sociale statistiquement instable »). En conflit éthique avec Seo-Yeon, et fascinée par l'Héritière, ce qui est dangereux ;
  - **Dévotion** : ✗, mais une **curiosité mutuelle** : jeux d'expérimentation consentis, scientifiquement « documentés » ;
  - **Pacte** : il s'obtient par le *Mécénat* (financement, protection, « sujets » d'étude) ou par le *Secret* (ses recherches non éthiques). Ambivalence de départ **+0**. Elle signe presque avec intérêt (« Variable intéressante »). Ses scènes mettent en scène une scientifique qui documente sa propre soumission jusqu'à perdre le contrôle de ses données, et de ses LEDs, qui virent au rouge. Destin probable : **Dévotion** si Elias lui donne accès au Registre, **Couteau** (le traceur) s'il le lui refuse trois fois. Sous Masque, elle coopère parfaitement en accumulant des données pour le moment opportun.
- **Combat** : *Technomancienne*, en arrière.
  - *Scan* : révèle les faiblesses et les intentions de toute la grille (s'additionne au Pressentiment) ;
  - *Drone-Bouclier* ;
  - *Surcharge* : fait exploser un drone, avec des dégâts de zone ;
  - *Patch* : retire les malus ;
  - **Ultime** : *Algorithme d'Inversion*, qui inverse les PV de deux cibles, une fois par combat.
- **Notes 18+** : curieuse, méthodique, étonnamment audacieuse. Elle aborde l'intimité comme une expérience, et découvre qu'elle ne contrôle rien. Scènes clés : le labo la nuit, au milieu des serveurs (P3), « Protocole d'observation n°1 » (P2, humoristique).

---

### 12.10 L'HÉRITIÈRE — « HANEUL » (하늘, « le Ciel »)
- **Âge** : **apparence d'une femme d'environ 25 ans, adulte**. Son âge réel est inconnu (lore : elle existe depuis l'apparition de la Tour il y a 400 ans, et peut-être avant). **Taille / poids** : **1m69 / 54 kg**.
- **Origine** : inconnue. C'est une entité née de la Tour (ou prisonnière de celle-ci), à forme humaine. Elias la nomme « Haneul » parce qu'elle regarde toujours le ciel.
- **Rôle** : endormie à l'**étage 1**, derrière la porte sans serrure (et, en vérité, ancrée dans **La Racine** sous Yongsan). C'est la **clé de la Descente** et l'héroïne-pivot du jeu.
- **Archétype** : mystérieuse amnésique, clé du destin. Pour Elias, l'amour d'une autre vie.
- **Fiche physique** :

| Champ | Description |
|---|---|
| **Taille / poids** | 1m69 / 54 kg |
| **Morphologie** | Élancée et harmonieuse, d'une beauté presque irréelle : épaules fines, taille fine, hanches douces, poitrine moyenne, longues jambes. Ses proportions sont celles d'une jeune femme adulte, ses gestes ceux de quelqu'un qui réapprend la gravité (elle flotte légèrement quand elle oublie de se concentrer) |
| **Peau** | **Diaphane**, blanc nacré avec des reflets presque opalins sous la lumière. Des **glyphes dorés** apparaissent sur ses bras, sa nuque et son dos quand elle utilise ses pouvoirs ou ressent une émotion forte |
| **Visage** | Ovale parfait, traits délicats et sans âge, d'aucune origine identifiable (chacun y voit quelqu'un de familier). Nez fin, lèvres pâles légèrement rosées, expression d'étonnement doux |
| **Yeux** | Grands, en amande, cils **argentés**. Iris **or liquide**, avec le même **anneau d'horloge** que le Registre activé d'Elias, qui tourne lentement. Les pupilles se dilatent en spirale quand elle voit une Fin |
| **Cheveux** | **Blanc argenté** scintillant, très longs (jusqu'aux chevilles au réveil, puis coupés à mi-dos par Elias, une scène clé), raides et fluides comme de la soie. Ils **s'assombrissent** à mesure que sa mémoire revient : argent, gris perle, puis **noir** en fin de route |
| **Signes particuliers** | Glyphes du Registre · aucune empreinte digitale · une **cicatrice lumineuse** en forme de serrure entre les omoplates (la « porte sans serrure ») · elle ne projette d'ombre que lorsqu'elle est heureuse · sent la pluie sur la pierre chaude |
| **Gestuelle** | Regarde toujours le ciel. Penche la tête à 45° pour comprendre. Touche tout du bout des doigts (textures, visages). Se blottit dans le blouson d'Elias. Fredonne des mélodies qu'Aoi reconnaît |
| **Voix** | Soprano douce et légèrement réverbérée, comme si deux voix parlaient à l'unisson. Elle prend une profondeur ancienne et grave quand l'Administratrice affleure. Casting IA : deux pistes superposées (§18.3) |
| **Style habituel** | Le **blouson bomber d'Elias** sur des vêtements dépareillés (pull trop grand, jupe longue, bottes de tailles différentes), choisis au hasard dans les ruines. Sa forme éveillée : robe-armure d'obsidienne et d'or |
| **Palette (DA)** | Blanc nacré, argent, or, noir obsidienne, orange (la doublure du bomber d'Elias) |

- **Tenues** :
  - *réveil* : un simple drapé blanc de lin, puis le **blouson bomber d'Elias**, qu'elle refuse de rendre ;
  - *base* : vêtements de récupération choisis maladroitement (pull trop grand, jupe longue, bottes dépareillées). Running gag tendre ;
  - *éveil* : robe-armure d'obsidienne et d'or, une couronne de glyphes, des ailes de lumière fragmentée ;
  - *détente* : chemise d'Elias, assise sur le rebord d'une fenêtre à regarder le ciel.
- **Personnalité** :
  - curieuse comme une enfant découvrant le monde, mais avec une **maturité ancienne** qui affleure par éclairs ;
  - douce, étrange, parfois terrifiante (elle parle des morts au présent) ;
  - se souvient d'Elias **par fragments**, et c'est la seule ;
  - sur les axes : **neutre** au départ. Elle **absorbe l'alignement d'Elias** et le reflète.
- **Aime / déteste** : le ciel, la pluie, le goût du ramen instantané, entendre Elias raconter sa mère ; les cages, les prières des Élus, le son de l'horloge.
- **Fin du Registre** : *J30, 23h58, étage 10 — Le Seuil. Se dissout pour « refermer » la Tour, ou est consumée pour l'ouvrir entièrement (selon P).* Dans la première vie, elle est morte en donnant le Registre à Elias.
  - **Cause profonde** : la Tour exige une **Clé** : soit un sacrifice, soit un **remplaçant**.
  - **Réécriture** : c'est l'arc de la **fin vraie**. Il demande plusieurs boucles :
    - la vérité sur ARCHE (Hae-in, Minh-Anh) ;
    - La Racine (Maricel) ;
    - la technique de scellement Baek (Ryeon) ;
    - le Chant (Aoi) ;
    - une Pression ≤ 30 ;
    - et un Lien ≥ 60.
  - **Nouvelle Fin** : aucune. C'est la seule héroïne dont la réécriture complète **termine** le cycle.
- **Secret lié au Registre** : **le Registre est une partie d'elle**. Elle était l'administratrice de la Tour, chargée d'en tenir les « comptes » (les Fins). La sonde ARCHE l'a réveillée, ce qui a appelé la Tour sur Séoul. Elle a choisi Elias dans la première vie parce qu'il a été le seul à la porter **sans rien lui demander**. Chaque régression **consume** une part de sa mémoire : c'est le coût secret des boucles, révélé en Acte III de la boucle 4 et plus.
- **Passé sombre** :
  - elle se souvient de **toutes les morts** de la première vie : 9 millions de Fins comptabilisées, une par une ;
  - dans la Ligne Zéro, elle a laissé **Seo-Yeon** (la future Agatha) boucler **312 fois** sans intervenir, parce que la Loi de la Tour le lui interdisait. Elle porte cette culpabilité sans en connaître la source.
- **Statut & passé intime** : aucun lien dans cette vie (**vierge**). Un seul souvenir intime, fragmentaire : **une nuit avec Elias dans la première vie**, la veille du J30, sur le toit de l'étage 9. Elle ne sait pas si c'est un souvenir ou un rêve.
- **Recrutement** :
  - *Toutes voies* : la trouver à l'étage 1 (Souvenir n°4, dès le J5) ou la reprendre aux Élus (après le J20) ;
  - *Tyran* : il peut l'**utiliser comme arme** (ses pouvoirs alimentent un Sceau), ce qui l'efface, sans Pacte possible. Ou bien elle **choisit** de régner avec lui, ce qui donne la fin « Roi et Reine des Ruines », sombre ;
  - *Mercenaire* : la **vendre** (aux Élus, à Mirae ou à Haesong), ce qui mène à une fin tragique majeure, avec des regrets persistants (Échos) ;
  - *Héros / Loup* : la protéger, dans la route centrale.
- **Trahison** :
  - **seuil** : elle ne trahit jamais **volontairement** ;
  - **déclencheur** : **Corruption de la Tour**. Si le Chaos ≤ −70 ou la Corruption d'Elias ≥ 60, la Tour reprend le contrôle et elle devient le **boss final** de la boucle (« L'Administratrice ») ;
  - **signes** : ses cheveux redeviennent blancs, elle parle d'Elias à la troisième personne, des Fins apparaissent sur la peau des alliés.
- **Dynamiques** :
  - **Serment** : ✓, le **Lien d'âme**, une version unique du Serment qui débloque la fin vraie ;
  - **Cour ouverte** : ✓, elle ne comprend pas la jalousie (« tu as assez d'amour pour plusieurs fins ») ; c'est un pilier de Cohésion, sauf avec Minh-Anh ;
  - **Dévotion** : ✗ ;
  - **Pacte** : **impossible**. Le Système refuse tout contrat signé par une « coquille » (§11.4.5), et Haneul n'a pas encore d'identité stable. Sur la voie du Tyran, Elias peut **utiliser de force ses pouvoirs**, mais ce n'est pas un Pacte : c'est un **effacement**, où elle se vide de sa personnalité, sans aucune scène intime. La seule version sombre de sa route est *Le Roi et la Reine des Ruines* : elle **choisit librement** de régner avec Elias Tyran, en absorbant son alignement (ses cheveux deviennent noirs d'encre, ses glyphes rouges).
- **Combat** : *Clé du Seuil*, flexible.
  - *Repli spatial* : téléporte un allié ou un ennemi sur n'importe quelle case ;
  - *Arrêt du temps* : un ennemi saute son tour ;
  - *Écho* : copie la dernière compétence utilisée ;
  - **Ultime** : *Page Blanche*, qui annule le dernier tour ennemi en entier ;
  - **Synergie avec Elias** : *Réécriture Partagée*, une charge de Réécriture gratuite.
- **Notes 18+** : découverte, tendresse, émerveillement. Les scènes les plus « romantiques » au sens pur ; l'intimité est liée à la mémoire (chaque scène restaure un fragment de souvenir). Scènes clés : le toit sous la pluie (P2), la nuit avant le J30 (P3).

---

## 13. Matrice de cohésion, Fins liées, Constellations & Harem Absolu

### 13.1 Compatibilité entre héroïnes (Cour ouverte)
**Échelle** : ++ (+15 Cohésion), + (+5), 0 (neutre), − (−10), −− (−20).

| | Seo | Hae | Rye | Sim | Xia | Aoi | Nad | Mar | Min | Han |
|---|---|---|---|---|---|---|---|---|---|---|
| **Seo-Yeon** | — | − | + | ++ | 0 | ++ | 0 | + | −− | + |
| **Hae-in** | − | — | 0 | − | −− | 0 | 0 | − | + | 0 |
| **Ryeon** | + | 0 | — | ++ | − | + | + (rivale) | 0 | 0 | + |
| **Simone** | ++ | − | ++ | — | 0 | + | −− | 0 | − | + |
| **Xiaoyu** | 0 | −− | − | 0 | — | 0 | + | ++ | + | 0 |
| **Aoi** | ++ | 0 | + | + | 0 | — | 0 | ++ | − | ++ |
| **Nadia** | 0 | 0 | + | −− | + | 0 | — | + | 0 | 0 |
| **Maricel** | + | − | 0 | 0 | ++ | ++ | + | — | 0 | + |
| **Minh-Anh** | −− | + | 0 | − | + | − | 0 | 0 | — | −− |
| **Haneul** | + | 0 | + | + | 0 | ++ | 0 | + | −− | — |

**Événements de résolution** : chaque relation négative (−, −−) a un événement de réconciliation qui la fait passer à 0. Exemples :
- *Hae-in × Xiaoyu* : partie de mahjong à enjeu ;
- *Simone × Nadia* : la nuit du J24 ;
- *Seo-Yeon × Minh-Anh* : le sérum H-07 ;
- *Minh-Anh × Haneul* : « Je ne suis pas un sujet d'étude ».

### 13.2 Fins liées (Destins entrelacés)
Ces Fins sont couplées : en réécrire une peut provoquer ou avancer l'autre.

| Fins liées | Mécanique |
|---|---|
| **Nadia (J24) ↔ Simone (J24/J28)** | Au J24, une seule survit par défaut. Pour sauver les deux, il faut que Nadia renonce au contrat **et** que Simone suspende le contre-sniper. Cela demande une Confiance ≥ 60 avec les deux, et une scène à trois sur le toit |
| **Aoi (J9) ↔ Minh-Anh (J26)** | Saboter l'amplificateur au J9 prive la Machine de données : Minh-Anh teste sur elle-même plus tôt, au J22. À l'inverse, laisser le concert avoir lieu stabilise la Machine |
| **Seo-Yeon (J12) ↔ Hae-in (J21)** | Voler le sérum H-07 affaiblit Haesong, et le coup du J21 arrive au J18. Négocier le sérum avec Hae-in renforce la Confiance des deux |
| **Ryeon (J17) ↔ Xiaoyu (J19)** | Si la Maison Baek tombe, Cheonma se tourne vers les Ponts, et la mutinerie du J19 est financée deux fois. Sauver Ryeon fait reculer la mutinerie au J23 (plus de temps) |
| **Maricel (J14) ↔ Haneul (J30)** | Sans Maricel, La Racine reste inaccessible, et la fin vraie est verrouillée pour cette boucle |
| **Toutes ↔ Haneul** | Chaque Fin d'héroïne réécrite rend un **Fragment d'âme**, qui ralentit la perte de mémoire de Haneul |

### 13.3 Les Constellations : toutes les combinaisons, du Solo aux 10
**Principe** : le jeu n'impose jamais de nombre. La **Constellation** d'Elias, c'est l'ensemble des héroïnes liées à lui (Serment, Cour, Dévotion ou Pacte) et des alliées recrutées. Qu'elle soit vide, réduite à une seule héroïne ou à un trio, ou qu'elle les compte toutes, le jeu réagit de façon organique sur quatre plans : **combat, scènes, sous-routes et fins**.

#### 13.3.1 Le Solo : la Voie du Seul
- **Condition** : aucune héroïne liée (les alliées non romancées et les PNJ mercenaires peuvent remplir la grille).
- **Passifs « Dernier Debout »** :
  - +8 % à toutes les stats par case alliée vide ;
  - +1 charge de Réécriture ;
  - *Instinct du Porteur* : la première attaque mortelle de chaque combat est esquivée.
- **Contenu propre** :
  - des monologues du Registre (Elias parle à ses morts) ;
  - des rencontres furtives sans lendemain ;
  - la sous-route *Le Lecteur Seul* (Elias tente de tout porter sans personne) ;
  - les fins *L'Ombre au Sommet* et *Le Lecteur Seul*.
- **Solo et romance ne s'excluent pas complètement** : une héroïne peut rester « alliée sans lien », avec des scènes de tension non résolue.

#### 13.3.2 Les Duos
- **Elias + 1 héroïne** : la Synergie personnelle (§10.9), la route Serment, la fin personnelle.
- **Héroïne + héroïne (45 paires)** : chaque paire présente dans l'escouade, avec une Affinité de paire ≥ 40, débloque une **Technique de Paire**. Les paires négatives doivent d'abord passer leur Quête de Conciliation.
- **Exemples de Techniques de Paire** :
| Paire | Technique | Effet |
|---|---|---|
| Ryeon + Nadia | **Lame et Lunette** | Nadia marque la cible, et l'*Iai* de Ryeon devient un critique garanti qui ignore la ligne avant |
| Simone + Nadia | **Feu Croisé** | Une suppression couplée à un tir d'élite : la ligne ennemie perd son tour |
| Hae-in + Xiaoyu | **OPA Hostile** | Vole tous les buffs ennemis et les convertit en argent et en Mana |
| Seo-Yeon + Minh-Anh | **Sérum H-07** | Soin de groupe, purge totale et résurrection |
| Maricel + Xiaoyu | **Contrebande** | Vole un objet par ennemi, puis le retourne en poison |
| Minh-Anh + Haneul | **Équation du Seuil** | Révèle et annule la prochaine action du boss |
| Simone + Ryeon | **Avant-Garde** | Rempart et contre-attaque partagés pendant 2 tours |
| Aoi + Haneul | **Hymne du Seuil** | Arrêt du temps de zone pendant 1 tour |
| Hae-in + Simone | **Loi Martiale** | Les ennemis humains se rendent sous 30 % de PV |
| Seo-Yeon + Aoi | **Ballade du Triage** | Soin de zone sur la durée, et les alliés KO se relèvent à la fin du tour |
- **Côté narratif** : chaque paire a au moins **3 scènes de Paire** (rencontre, conflit ou complicité, intimité de Paire si les deux sont liées et acceptent le partage).
  - **15 paires de rang A** ont en plus une **sous-route** de 2 à 4 quêtes, par exemple *L'Arène des Deux Lames* (Ryeon × Nadia) ou *La Comptabilité des Morts* (Hae-in × Minh-Anh, ARCHE).
  - **Les 30 autres paires** ont leur jeu de scènes et leur Technique.

#### 13.3.3 Les Trios : Résonances et Trios Légendaires
- **Les tags de Résonance** : chaque héroïne porte 2 tags.
| Héroïne | Tags | | Héroïne | Tags |
|---|---|---|---|---|
| Seo-Yeon | Soin · Lumière | | Aoi | Chant · Lumière |
| Hae-in | Ordre · Or | | Nadia | Ombre · Glace |
| Ryeon | Lame · Acier | | Maricel | Ombre · Fluide |
| Simone | Acier · Feu | | Minh-Anh | Tech · Foudre |
| Xiaoyu | Poison · Fluide | | Haneul | Temps · Vide |
- **Règle systémique** : un trio dont les membres partagent un tag déclenche une **Résonance d'élément** (par exemple deux tags Ombre : invisibilité partagée au premier tour). Un trio qui couvre trois familles différentes (*Corps*, *Esprit*, *Ombre*, *Destin*) déclenche une **Résonance d'équilibre** (+15 % à tout). Ainsi, **les 120 trios possibles** ont tous un effet.
- **Les Trios Légendaires** (faits à la main : Ultime en cut-in à trois, sous-route dédiée, CG) :
| Trio | Membres | Thème | Ultime | Sous-route |
|---|---|---|---|---|
| **Les Trois Lames** | Ryeon, Simone, Nadia | Les guerrières | *Triple Exécution* | Conquérir l'Arène des Rangs (étage 8) avant son ouverture |
| **Les Reines** | Hae-in, Xiaoyu, Ryeon | Les trois héritières de Sceaux | *Décret des Sceaux* | Réunir 3 Sceaux par pacte (P −12) |
| **Les Invisibles** | Aoi, Maricel, Nadia | Les étrangères exploitées | *Ceux qu'on ne voit pas* | Faire tomber le PDG Jang et le marché des « sponsors » de Mirae |
| **Les Filles du Fleuve** | Xiaoyu, Maricel, Nadia | Contrebande et silence | *Courant Noir* | Prendre le contrôle du Han pendant la Guerre de l'Eau |
| **Le Laboratoire** | Minh-Anh, Seo-Yeon, Haneul | La science contre l'éthique | *Sérum du Ciel* | Le vaccin universel tiré du sang de Seo-Yeon et des glyphes de Haneul |
| **Les Sceptres** | Hae-in, Minh-Anh, Xiaoyu | Le capital et la technologie | *Monopole* | Un empire économique sur la Friche (favorise la voie Tyran) |
| **Les Gardiennes du Seuil** | Haneul, Ryeon, Aoi | Clé, sceau et chant | *Scellement* | Le rituel Baek de scellement : une voie alternative vers la fin vraie |
| **La Garde de Fer** | Simone, Ryeon, Seo-Yeon | Protéger les autres | *Bastion* | Tenir Myeongdong lors du siège du J22 sans aucune perte |
| **Les Trois Vérités** | Seo-Yeon, Hae-in, Haneul | Contre Agatha | *Page Retournée* | Démasquer le Prophète dès la boucle 2 |
- **Quatuors légendaires** :
  - **Les Quatre Fins** (Aoi, Seo-Yeon, Maricel, Ryeon) : les quatre Fins les plus précoces (J9, J12, J14, J17). Sous-route *Course contre la montre*, et l'Ultime *Quatre Aubes* ;
  - **Loin de chez soi** (Simone, Nadia, Maricel, Aoi) : le teaser des Tours des Origines (extension).

#### 13.3.4 À partir de 4 : l'Aura de Constellation
- **L'escouade de combat** reste à Elias plus 3 héroïnes actives et 2 réservistes. Les **Relais** (permuter un réserviste) déclenchent un mini-combo de paire avec la héroïne remplacée.
- **L'Aura de Constellation**, un passif global selon le nombre d'héroïnes liées :
| Héroïnes liées | Bonus |
|---|---|
| 4 | +5 % à toutes les stats de l'escouade |
| 6 | +1 charge de Réécriture, les Relais sont gratuits |
| 8 | Synergies −30 % de coût, Cohésion +10 au Refuge |
| 10 | **Formation des Dix** débloquée (§13.4) |
- **Le Poids du Destin** (contrepartie, §13.4.5) : chaque héroïne liée au-delà de la troisième ajoute **+2 de Pression** à la Tour.

#### 13.3.5 Scènes modulaires (la technique qui rend tout cela possible)
- **Les scènes de groupe sont écrites en modules** : un **noyau** (l'événement : dîner au Refuge, veillée d'armes, bain à la source chaude, Conseil de la Maison), puis des **répliques conditionnelles** selon *qui est présent* et *quelle relation lie chaque paire présente* (la matrice §13.1). N'importe quelle combinaison, de 2 à 10, produit une scène cohérente.
- **Intimité selon la composition** :
| Scène | Condition |
|---|---|
| Intimité à deux | Une héroïne liée |
| Intimité à trois | Deux héroïnes liées, Affinité de paire ≥ 60 (Cour), ou une clause commune (Pacte) |
| Scènes de groupe (4 et plus) | Cohésion ≥ 70 (Cour) ou une « Cour du Trône » (Tyran, au moins 3 vassales sous Pacte ou en Dévotion) |
- **Les fins de Constellation sont assemblées dynamiquement** :
  - un épilogue en cases webtoon, avec **une case par héroïne liée** et **une case par paire de rang A présente** ;
  - un **CG final** dédié pour chaque Trio ou Quatuor légendaire, et un CG générique « Maison de N » pour les autres compositions.
- **Volume de production** :
  - 45 paires × 3 scènes, soit environ 135 scènes de Paire ;
  - 15 sous-routes de rang A ;
  - 11 sous-routes légendaires (9 trios et 2 quatuors) ;
  - environ 40 scènes de groupe modulaires.

### 13.4 La Route du Harem Absolu (les 10 héroïnes)
**Oui : le Harem complet, avec les 10 héroïnes en même temps, est possible.** C'est la route la plus difficile du jeu, classée **Extrême**. Elle demande presque une maîtrise parfaite du calendrier, de la cohésion et du Registre.

#### 13.4.1 Conditions de déblocage (toutes dans la même boucle)
| # | Condition | Pourquoi c'est dur |
|---|---|---|
| 1 | **Les 10 héroïnes vivantes au J30** : les 10 Fins réécrites, y compris les **Fins liées** (Nadia **et** Simone au J24, Aoi **et** Minh-Anh) | Il faut des Souvenirs et des Ancrages accumulés : en pratique, à partir de la **boucle 6** |
| 2 | Les 10 au stade **« Liée »** (Cour ouverte, Dévotion ou Pacte stable) | 10 quêtes personnelles à terminer en 30 jours |
| 3 | Les **10 Quêtes de Conciliation** terminées (13.3.2) | Elles neutralisent toutes les relations négatives de la matrice |
| 4 | **Cohésion ≥ 80** à la **Veille des Dix** (J29) | Une seule jalousie mal gérée fait chuter la jauge |
| 5 | **Aucune héroïne « Négligée »** : au moins 1 phase de relation tous les 4 jours pour chacune | Cela représente environ 70 phases sur 120. Il faut optimiser avec les événements de groupe |
| 6 | **Le Prophète démasqué** (§16.3) | Il sème la discorde par des lettres anonymes (événement « Les Lettres du Corbeau ») |
| 7 | **Lien ≥ 60 avec Haneul** | Elle est la clé de voûte de la Maison : elle « voit » les liens entre les Fins de chacune |
| 8 | **Survivre à l'Épreuve des Dix** (§13.4.5) | La Tour tente de récolter les 10 Fins pendant la même nuit |

#### 13.4.2 Les 10 Quêtes de Conciliation
Une par paire négative de la matrice (§13.1) :
| Paire | Quête | Résumé |
|---|---|---|
| Hae-in × Xiaoyu (−−) | **Le Mahjong des Reines** | Une partie à enjeu total entre les deux reines. Elias doit faire en sorte que *personne* ne perde la face |
| Simone × Nadia (−−) | **Le Toit du J24** | La nuit du contrat : les réunir sur le toit et briser le cycle tireuse/cible |
| Seo-Yeon × Minh-Anh (−−) | **Sérum H-07** | Synthétiser le vaccin ensemble, l'éthique de l'une avec le génie de l'autre |
| Minh-Anh × Haneul (−−) | **Je ne suis pas un sujet** | Minh-Anh détruit elle-même ses données sur Haneul |
| Seo-Yeon × Hae-in (−) | **La Facture** | Hae-in finance l'hôpital du camp sans contrepartie, une première |
| Simone × Hae-in (−) | **Le Dossier Marcus** | La vérité sur la mort du fiancé de Simone (ARCHE) et le pardon, ou non |
| Hae-in × Maricel (−) | **Le Coffre du B6** | Partager le bunker IFC entre la Présidente et la Reine des Rats |
| Ryeon × Xiaoyu (−) | **La Dette des Baek** | Une vieille dette d'honneur entre la Maison Baek et Longwei, réglée en duel d'éventail contre sabre |
| Simone × Minh-Anh (−) | **Le Silo** | Désamorcer ensemble le Protocole Cendre |
| Aoi × Minh-Anh (−) | **L'Amplificateur** | Minh-Anh retourne son invention pour qu'Aoi chante *librement* |

#### 13.4.3 Mécaniques propres au Harem Absolu
- **Le Conseil de la Maison** (tous les 5 jours, en phase Nuit) : les héroïnes exposent leurs griefs, et Elias arbitre trois décisions. Chaque choix favorise certaines héroïnes et en froisse d'autres.
- **La hiérarchie de la Maison** : désigner une **Première** (Hae-in l'exige, Xiaoyu la conteste) ou instaurer le **Cercle**, sans hiérarchie (Maricel et Haneul le préfèrent). Le Cercle donne plus de Cohésion de base mais déclenche plus d'événements de rivalité.
- **Les Quartiers** : il faut agrandir le Refuge pour loger les 10 héroïnes (10 chambres plus une salle commune). C'est un chantier de ressources important pendant l'Acte II.
- **Les outils d'optimisation** :
  - *Nuits de la Maison* : comptent comme une phase de relation pour 4 héroïnes à la fois ;
  - *Missions en duo* : une héroïne accompagne Elias, et cela compte comme un rendez-vous ;
  - *Lettres* : 0 phase, petit bonus, au plus 2 par jour ;
  - *Ancrage « Échos affectifs complets »* : réservé à la fin de jeu, il conserve les Affinités entre boucles.

#### 13.4.4 Deux variantes (et leurs hybrides)
| Variante | Composition | Risque propre | Fin |
|---|---|---|---|
| **La Maison des Dix** (Lumière) | Les 10 en Cour ouverte | Les jalousies et les ultimatums | *La Maison des Dix* : la plus lumineuse du jeu |
| **Le Trône des Dix** (Ombre) | Au moins 6 en Dévotion, les autres en Pacte stable (Ambivalence ≥ 0). Haneul en *Reine des Ruines* | **La Nuit des Couteaux** : si la somme des Ambitions des héroïnes sous Pacte dépasse 150 au J29, une **conspiration coordonnée** éclate, menée par Hae-in ou Xiaoyu | *Le Trône des Dix* : un empire de domination absolue |
| **Hybride** | Un mélange de Cour, de Dévotion et de Pacte | Le cumul des deux risques | Une variante de la fin selon la majorité |

**Récompenses** :
- l'Ultime collective **Formation des Dix** (10 cases de cut-in, une frappe par héroïne) ;
- des scènes de groupe exclusives (CG « Portrait des Dix ») ;
- un bonus permanent de Domaine dans l'Ère des Strates (+10 % sur toutes les ressources, §15.6) ;
- le titre **« Celui que dix destins ont choisi »**.

#### 13.4.5 Règles du worldbuilding : le Poids du Destin et l'Épreuve des Dix
La route des 10 n'est pas une simple accumulation de jauges : **la Tour elle-même s'y oppose**, ce qui la rend cohérente avec le lore.
- **Le Poids du Destin** : pour le Système, chaque lien est un **contrat** qui attache la Fin d'une héroïne au Registre d'Elias (Loi des Contrats, §16.1).
  - Plus Elias porte de Fins, plus le destin « pèse » : **+2 de Pression par héroïne liée au-delà de 3**, soit +14 avec 10 héroïnes.
  - À partir de 8 liens, les **Exécuteurs du Système** apparaissent, quelle que soit la boucle : la Tour traite le Lecteur comme une anomalie.
- **L'Épreuve des Dix** : avec 10 liens au J30, la Tour tente de **récolter les 10 Fins en même temps**.
  - Pendant la Nuit du Déversement (§14.4), les 10 héroïnes sont menacées **simultanément**, dans 10 lieux différents, par leurs Fins « convergentes ».
  - Le joueur doit **répartir des paires de protection**, en utilisant les Techniques de Paire et les Fins liées. Elias ne peut être qu'à un seul endroit à la fois : il choisit qui il protège en personne, et fait confiance aux autres.
  - Chaque héroïne protégée par une **paire de rang A** ou un **Trio Légendaire** survit automatiquement. Les autres affrontent leur Fin en combat.
- **La récompense de lore, la Constellation du Lecteur** : si les 10 survivent, les 10 Fins tissées forment une **constellation dans le Registre**. Celle-ci peut réécrire la Règle du Seuil. Cela ouvre une **seconde voie vers la fin vraie** (*La Dernière Page — Version des Dix*), et la **Formation des Dix** devient une compétence d'âme permanente.
- **Difficulté retenue : Extrême.**
  - **Boucle 6 ou plus** recommandée ;
  - le Prophète démasqué ;
  - Cohésion ≥ 80 (Lumière) ou somme des Ambitions < 150 (Ombre) ;
  - P ≤ 45 *avant* le Poids du Destin.
  - **Pas de limite de temps réel** : le joueur peut y consacrer autant de boucles que nécessaire.

---

## 14. La Tour avant le Jour 30

### 14.1 Structure d'un étage
- **Chaque étage est une zone verticale** de 8 à 16 nœuds, avec sa Règle, son Gardien, ses PNJ de Tour (survivants d'autres mondes, marchands, Élus) et ses ressources propres.
- **Explorer coûte des phases** : 1 à 3 par visite selon l'étage. Les **portails de retour** sont gratuits une fois activés.
- **Premier Conquérant** : vaincre le Gardien en premier, dans n'importe quelle boucle, grave le nom d'Elias dans les Archives : −2 de Pression et un bonus de stats permanents.
- **Fragments de Strate** : des objets de lore qui racontent le monde dont proviennent les étages (§16.2).

### 14.2 Les 10 étages en détail
| Étage | Nœuds / phases | Règle | Gardien & mécanique de combat | Butin clé | Lien héroïne |
|---|---|---|---|---|---|
| **1 — Le Vestibule** | 8 nœuds / 1 phase | Les armes extérieures ne fonctionnent pas | **Le Portier aux Mille Clés** : 3 portes, il ment sur la troisième ; il faut deviner la vraie porte pour le rendre vulnérable | Armes de Tour T1, la **porte sans serrure** | **Haneul** (dès le J5 avec le Souvenir n°4) |
| **2 — La Cité Silencieuse** | 12 nœuds / 2 phases | Tout son au-dessus d'un murmure attire le Gardien | **La Mère Sourde** : chaque compétence « bruyante » la renforce ; combat de furtivité | Bottes d'Ombre, Fragment *Monde 2* | **Nadia** (bonus de Règle, car elle est silencieuse) |
| **3 — Le Marché des Âmes** | 14 nœuds / 2 phases | Tout s'achète, même les souvenirs et les années de vie | **Le Courtier** : on peut l'acheter, le combattre, ou lui vendre un Souvenir pour le faire fuir | Objets légendaires contre des années de vie | **Xiaoyu** et **Maricel** (marchandage) |
| **4 — Le Banquet** | 10 nœuds / 2 phases | On ne peut pas attaquer quelqu'un avec qui l'on a partagé un repas | **L'Hôte Affamé** : le battre par le poison, la ruse ou un convive sacrifié | Couverts de l'Hôte (immunité aux poisons) | **Hae-in** (étiquette, diplomatie) |
| **5 — Le Labyrinthe Inversé** | 16 nœuds / 3 phases | La gauche est la droite, les alliés apparaissent comme des ennemis | **Le Minotaure de Miroir** : la grille du joueur est inversée | **Ancre de retour** (Registre), Prisme d'Inversion | **Minh-Anh** (elle décode le motif) |
| **6 — La Forêt des Pendus** | 12 nœuds / 2 phases | Les morts de la boucle reviennent comme des spectres | **Le Bourreau Vert** : plus la boucle a fait de morts, plus il est fort | Corde du Bourreau (exécution instantanée) | **Seo-Yeon** (elle apaise les spectres) |
| **7 — Le Tribunal** | 8 nœuds / 1 phase | Les crimes commis en surface sont jugés | **Le Juge Sans Visage** : ses stats dépendent de l'alignement (le Héros est avantagé, le Tyran se défend par le Décret) | Marteau du Juge, Titre selon le verdict | **Simone** (témoin de moralité) |
| **8 — L'Arène des Rangs** | 6 nœuds / 1 phase | Seul le duel est autorisé | **Le Champion d'Hier** : un double d'Elias issu de sa première vie, qui copie sa classe | Lame d'Hier, et un Souvenir de la première vie | **Ryeon** (duels préparatoires) |
| **9 — Le Jardin des Fins** | 10 nœuds / 2 phases | Le Registre ne fonctionne pas, les Fins poussent comme des fleurs | **La Jardinière** : il faut cueillir la « bonne » Fin, et une fleur cueillie change la Fin d'un PNJ | Graines de Fin (réécriture hors Registre) | **Aoi** (son chant fait éclore les fleurs) |
| **10 — Le Seuil** | ? / 3 phases | Inconnue : elle se découvre en mourant | **???** : il dépend de P et de la boucle. C'est l'Administratrice, le Prophète ou la Tour elle-même | La clé de la Descente | **Haneul** (fin vraie) |

### 14.3 Préparer les 7 secteurs : le Plan de Défense
Le jeu avant le J30 est un **arbitrage permanent entre la Tour** (baisser P) **et la ville** (monter l'IR).
- **Investissements par secteur** : 4 jauges qui alimentent la Défense du secteur.
| Jauge | Comment l'augmenter | Défense |
|---|---|---|
| **Fortifications** | Ressources et phases de chantier, ou main-d'œuvre vassale (Tyran) | jusqu'à +30 |
| **Milice** | Recruter et former des éveillés (Ryeon, Simone) | jusqu'à +25 |
| **Vivres & eau** | Bunker B6, pompes du Han, marché | jusqu'à +20 |
| **Alliance** | Pactes avec le clan local, Sceau, Trêve | jusqu'à +25 |
- **Protectrices** : une héroïne affectée à un secteur ajoute +15 de Défense et un bonus unique (Simone à Yongsan : Marées −1 palier). En contrepartie, elle n'est plus disponible dans l'escouade.
- **Repères de répartition du temps** : 35 % Tour, 35 % ville, 30 % relations, pour viser P ≤ 30 et IR > 65. Le joueur peut faire mieux grâce aux Souvenirs.

### 14.4 La Nuit du Déversement (J30) : la mission finale jouable
Une séquence de **6 phases spéciales** qui condense tout le jeu :
1. **18h, l'Inspiration** : la Tour aspire l'air de la ville. Dernières affectations des Protectrices.
2. **19h–21h, les Fronts** : les combats de Marée T6 se résolvent secteur par secteur. Le joueur combat lui-même sur 2 fronts au choix ; les autres sont résolus par leur Défense.
3. **22h, la Trahison** : si une héroïne a une Loyauté sous son seuil ou un Pacte en Couteau, c'est maintenant.
4. **22h30, l'Ascension** : montée express de l'étage 1 au 10 par les portails activés (les étages non conquis imposent un combat).
5. **23h30, le Seuil** : le combat final de la boucle, contre le Gardien du Seuil.
6. **23h58, la Page** : la décision finale avec Haneul, puis la résolution P × IR, et l'Aube… ou la régression.

---

## 15. L'Après-Jour 30 — L'Ère des Strates

> Franchir le J30 n'est pas la fin : c'est la fin du **prologue**. La Tour ne descend pas une fois. Elle descend **tous les 30 jours**, strate après strate, jusqu'à son sommet.

### 15.1 Le Choix de l'Aube (régression après le J30)
- À l'aube du **J31**, le Registre propose : **« Graver l'Aube ? »**
  - **Oui** : le nouveau point de régression devient le **J31**. Le monde, les héroïnes vivantes et les relations sont **figés comme base**. Mourir ensuite ramène au J31, et non au J1.
  - **Non** : mourir ramène toujours au J1. Le joueur peut repartir chercher une meilleure issue (sauver plus d'héroïnes, préparer le Harem Absolu), mais il perd l'Ère des Strates en cours.
- **Ancres de Strate** : chaque Pulsation franchie (15.3) peut à son tour être gravée.
- **Coût** : après l'Aube, chaque régression coûte **1 Fragment d'âme**. Sans Fragment, la mort est définitive, ce qui donne la fin *La Dernière Page Blanche*. La mémoire de Haneul continue de s'éroder à chaque retour.

### 15.2 La Friche : Séoul transformée
Au J30, les 10 premiers étages **s'effondrent sur la ville**. Leurs Règles deviennent les **lois locales** des secteurs : la continuité de gameplay est directe.
| Secteur | Devient | Étage fusionné | Loi locale (Règle permanente) |
|---|---|---|---|
| Yongsan | **Le Pied de la Tour** | 1, 9 et 10 | Les Fins de chacun poussent en fleurs visibles par tous : le Registre devient public, une révolution sociale |
| Gangnam | **L'Arène Éternelle** | 8 | Tout conflit se règle en duel. Le rang du Système fait la loi |
| Yeouido | **Le Banquet Perpétuel** | 4 | Pas d'agression après un repas partagé : la zone diplomatique et commerciale de la Friche |
| Hongdae–Mapo | **Le Dédale Inversé** | 5 | Rues en miroir, gravité changeante : le terrain des contrebandiers et des chercheurs |
| Myeongdong | **Le Tribunal à Ciel Ouvert** | 7 | Tout crime est jugé par le Juge Sans Visage. L'alignement devient une citoyenneté |
| Ponts du Han | **Le Fleuve Silencieux** | 2 | Silence obligatoire sur l'eau. Le fleuve devient une autoroute furtive |
| Collines du Nord | **La Forêt des Pendus** | 6 | Les morts de la ville errent en spectres, à apaiser ou à exploiter |
| *(itinérant)* | **Le Marché des Âmes** | 3 | Il apparaît chaque semaine dans un secteur au hasard |

**Esthétique de friche SF/apocalyptique** :
- des **Îles Suspendues** (fragments d'étages en lévitation au-dessus de la ville, reliés par des chaînes de glyphes) ;
- une **Pluie de Cendre** dorée ;
- une **faune de Strate** mutante ;
- des gratte-ciel fendus et colonisés par la végétation de la Tour ;
- de **Nouvelles Cités** bâties dans les carcasses des étages tombés.
- À partir de la Strate 21–30, la **technologie de Strate** se répand : motos antigravité, exosquelettes, drones-reliques, réacteurs à glyphes.

**Selon l'issue du J30** : un J30 en « Aube Nouvelle » donne une Friche **habitable**, où les Lois sont utiles. Un J30 en « Survie dans les ruines » donne une Friche **hostile**, où les Lois sont mortelles et les secteurs sont perdus.

### 15.3 Le monde extérieur : la chute du Voile et la Pluie des Tours
- **J31** : le Voile tombe. Séoul découvre qu'au J30, **12 autres Tours** sont apparues sur Terre. C'est **la Pluie des Tours**.
- **Séoul est la seule ville qui a « préparé » sa première Descente** (grâce à la régression). Elle devient un **phare**, une puissance mondiale, et une cible.
- **Les 12 Tours, et les Tours des Origines** : chaque héroïne a une quête dans la ville de ses origines.
| Tour | Lien | Hook |
|---|---|---|
| **Osaka** | Aoi | Sa famille est vivante, et une autre idol « chante » pour cette Tour |
| **Shanghai** | Xiaoyu | Le clan Long d'origine, et son passé |
| **Almaty** | Nadia | Sa grand-mère, l'écharpe rouge, la neige |
| **Atlanta** | Simone | Sa famille, et la vérité sur ARCHE côté américain |
| **Cebu** | Maricel | Sa mère et ses frères, une ville sous l'eau (Strate 11–20) |
| **Hanoï** | Minh-Anh | La famille de sa mère, et une Tour qui calcule |
| **Paris** | **Elias** | **Son père, Julien Moreau, est le Lecteur de la Tour de Paris.** Da-bin, la fille de Hae-in, est coincée là-bas |
| **Lagos**, **Le Caire**, **São Paulo**, **Mumbai**, **Sydney** | — | Des Lecteurs rivaux ou alliés (Conclave, 15.5) |
- **Carte mondiale** (**extension, hors v1.0**) : débloquée avec les véhicules de Strate (l'**Arche**, vaisseau-relique de la Strate 41–50). Chaque Tour étrangère est une **zone d'expédition** avec ses propres secteurs, sur le modèle des couches 2 et 3.

### 15.4 Les Pulsations : la boucle de 30 jours étendue
- **Tous les 30 jours, la Tour « pulse »** : elle ouvre une nouvelle **Strate de 10 étages** et menace de la déverser sur Terre.
- **La mécanique des 30 jours se répète à plus grande échelle** : une Pression propre à la Strate, un IR à l'échelle du Domaine, des Ancres, des Fins nouvelles pour les héroïnes et les PNJ.

| Cycle | Jours | Strate ouverte | Statut |
|---|---|---|---|
| Prologue | J1–J30 | Étages 1–10 | Jeu principal |
| Cycle 2 | J31–J60 | **11–20** | Ère des Strates (jeu principal) |
| Cycle 3 | J61–J90 | **21–30** | Ère des Strates |
| Cycle 4 | J91–J120 | **31–40** | Ère des Strates |
| Cycle 5 | J121–J150 | **41–50** | Ère des Strates, avec le **Conclave des Lecteurs** à l'étage 50. **Fin du périmètre v1.0** |
| Cycles 6–10 | J151–J300 | **51–100** | **Extension** : endgame, le Sommet |

- **Rythme** : après le J30, les journées « calmes » peuvent être **condensées** (le Domaine tourne en automatique) pour se concentrer sur les expéditions, les Ancres et les relations.

### 15.5 Les Strates 11 à 100
> **v1.0** : Strates 11–50. **Extension** : Strates 51–100 et la carte mondiale.

Chaque Strate est le **vestige d'un monde que la Tour a déjà « archivé »** (§16.2).
| Étages | Strate | Univers | Règle de Strate | Gardien de Strate | Ce que sa Descente apporte au monde |
|---|---|---|---|---|---|
| 11–20 | **Les Royaumes Noyés** | Fantasy médiévale engloutie | L'eau monte à chaque tour de combat | **Le Roi Sous la Marée** (20) | Inondations partielles, le Han devient une lagune, ressource *Corail-Mana* |
| 21–30 | **Kaal, la Cité-Machine** | SF cybernétique | Le métal obéit au Système, les implants sont piratables | **ORAKEL, l'Intelligence Mère** (30), lié à Minh-Anh | **Technologie de Strate** : exos, drones, motos antigravité, réacteurs |
| 31–40 | **Le Désert des Dieux Morts** | Mythologie déchue | Prier rend des PV, mais augmente la Corruption | **Le Dernier Fidèle** (40) | *Os divins* (matériaux légendaires), mutations de la faune |
| 41–50 | **L'Empire Céleste de Varun** | Space-opera en ruine | Gravité variable, combat sur deux grilles (orbitale et sol) | **L'Empereur Varun, Celui qui a dit Non** (50), un ancien Lecteur qui a résisté 700 cycles | Armes à énergie, l'**Arche** (vaisseau mondial), Moteurs de Strate |
| 51–60 | **L'Océan de Verre** | Monde cristallisé, le temps figé | **La Réécriture est interdite** | **La Sirène Immobile** | Cristaux temporels (Ancrages supplémentaires) |
| 61–70 | **Le Jardin Carnivore** | Biosphère consciente | Chaque mort nourrit le terrain, qui attaque tout le monde | **La Reine-Racine** | Bio-armures vivantes |
| 71–80 | **La Nécropole des Régresseurs** | Les tombes des Lecteurs qui ont échoué | On affronte ses **propres doubles** des boucles passées | **Le Premier Lecteur** | Révélations sur Agatha et sur la Ligne Zéro (§16.3) |
| 81–90 | **La Bibliothèque des Fins** | L'Archive elle-même | Chaque combat est un récit : les choix de dialogue sont des attaques | **Le Bibliothécaire** | Accès au **Registre universel** |
| 91–99 | **Le Silence** | Le vide entre les mondes | Pas de son, et le HUD disparaît progressivement | **L'Écho** | — |
| 100 | **Le Bureau de l'Archiviste** | Le sommet | — | **L'Archiviste** | Le choix final (§17) |

### 15.6 Gameplay de l'Ère des Strates
- **Le Domaine** : le Refuge devient une **Cité-État** qui s'étend sur les secteurs de la Friche. C'est une couche de gestion légère :
  - **ressources** : Vivres, Énergie de Strate, Alliage, Influence, Population ;
  - **bâtiments** selon la voie : Cité-Sanctuaire, Empire-Forteresse, Réseau d'Ombres ou Port-Franc ;
  - **diplomatie** avec les anciens clans, devenus des **Cités-États rivales** (Cheonma tient l'Arène Éternelle, Haesong le Banquet…).
- **Les héroïnes, gouverneures et générales** :
| Héroïne | Rôle de Domaine | Bonus |
|---|---|---|
| Hae-in | Ministre de l'Économie | +30 % d'Influence et de commerce |
| Simone | Générale des armées | +25 % de Défense, Marées −1 palier |
| Minh-Anh | Directrice de la Recherche | Technologies de Strate −30 % de coût |
| Seo-Yeon | Ministre de la Santé | Population +20 %, épidémies évitées |
| Ryeon | Maîtresse d'armes | Formation des éveillés ×2 |
| Xiaoyu | Maîtresse du Fleuve | Commerce fluvial et contrebande +40 % |
| Maricel | Logistique et réseaux souterrains | Expéditions −1 jour, accès aux passages cachés |
| Aoi | Moral et culture | Révoltes −50 %, recrutement +20 % |
| Nadia | Renseignement | Révèle les plans des rivaux et des Lecteurs |
| Haneul | Résonance de Strate | Pression de Strate −15 |
- **Les Technologies de Strate** (4 branches) : **Hydromancie** (11–20), **Mécatronique** (21–30), **Théurgie** (31–40), **Astro-ingénierie** (41–50). Elles débloquent l'équipement, les véhicules et les bâtiments.
- **Les expéditions** : envoyer des escouades d'héroïnes sur des étages déjà conquis (ressources) pendant qu'Elias explore la frontière.
- **Le combat** : la grille 3×3 est conservée, avec les **classes T4** (§10.8.3), l'équipement de Strate, et des **combats de Strate** sur deux grilles contre les Gardiens géants.
- **Les relations continuent** : nouvelles tenues « Ère des Strates » (techwear, armures-reliques), nouvelles Fins à réécrire, et de nouvelles scènes, Pacte compris.

### 15.7 Nouvelles factions de l'Ère
| Faction | Nature | Rôle |
|---|---|---|
| **La Coalition Extérieure** | Forces de l'ONU et des grandes puissances, arrivées après la chute du Voile | Veulent contrôler Séoul et ses Lecteurs. Alliées ou envahisseuses |
| **Les Remontants** | Habitants survivants des Strates (natifs de mondes archivés) qui descendent avec chaque Pulsation | Réfugiés, mercenaires ou conquérants. Certains reconnaissent Haneul |
| **Les Archivistes** | Serviteurs de la Tour, administrateurs des Strates | Antagonistes de fin de jeu, gardiens des Lois |
| **Le Conclave des Lecteurs** | Les Lecteurs des 12 autres Tours (dont Julien Moreau) | Une alliance ou une guerre entre régresseurs, à l'étage 50 |
| **Le Nouveau Culte** | Les Élus réformés (selon le sort du Prophète) | Une religion d'État (Tyran) ou une secte résiduelle |

---

## 16. Lore profond & le Prophète

### 16.1 La Loi des Contrats du Système
- Le Système **enregistre** les promesses, les Sceaux et les Pactes : tout contrat a force de loi physique.
- **Trois axiomes** :
  1. *Nul contrat sans signature lucide* (d'où le refus des « coquilles »).
  2. *Nul contrat sans contrepartie* (d'où la clause de Protection du Pacte).
  3. *Nul contrat sans porte* (la clause de rupture, toujours présente, au prix fixé à la signature).
- C'est pourquoi le Système respecte même les contrats de domination : il ne juge pas, il **comptabilise**.

### 16.2 Cosmologie : la Tour est l'Archive
- **La Tour est l'Archive** : une structure qui voyage entre les mondes **qui l'appellent**. Le Projet ARCHE a envoyé une sonde dans La Racine, et la Tour a « répondu ».
- **Chaque monde visité reçoit 30 jours par Strate.** Un monde qui échoue est « archivé » : ses ruines, ses peuples et ses lois deviennent une **Strate** de la Tour. Les étages 11 à 100 sont des mondes morts.
- **Chaque monde a une Administratrice** (Haneul pour la Terre), qui tient le compte des Fins, et un **Lecteur** qu'elle choisit, à qui elle confie une part d'elle-même : le Registre.
- **Il y a 400 ans**, sous Joseon, la Tour est déjà apparue. Un Lecteur de l'époque et la lignée Baek l'ont **refermée** : c'est le scellement du sabre *Baekho*. Haneul s'est endormie dans La Racine, jusqu'à ce qu'ARCHE la réveille.
- **L'Archiviste** (étage 100) n'est pas un dieu : c'est **le premier Lecteur qui ait jamais « réussi »**. Il a choisi de devenir la Tour plutôt que de voir son monde archivé. La fin vraie interroge ce choix.

### 16.3 Le Prophète des Élus : un personnage connu, un twist lourd
**Identité : Mère Agatha Seo**, 67 ans, la douce dirigeante du Sanctuaire de Myeongdong, mentor de Seo-Yeon et garante de la Trêve.

**Vérité : Agatha est Park Seo-Yeon, venue d'une ligne temporelle effondrée.**
- **La Ligne Zéro**, avant la première vie d'Elias : Haneul avait choisi **Seo-Yeon** comme Lectrice, parce que c'était elle qui l'avait portée hors de l'étage 1.
- Seo-Yeon a vécu **312 boucles**. Dans beaucoup d'entre elles, Elias était à ses côtés, et elle l'a aimé. Il **mourait au J12 en la protégeant**, l'inverse exact de sa Fin actuelle.
- À la boucle 312, brisée, elle a **arraché une page du Registre** pour tenter une **Régression Profonde** : revenir *avant* la Tour pour empêcher ARCHE.
- Elle a été projetée **40 ans en arrière**, sans pouvoirs, avec seulement la **Page arrachée**.
- Elle a vécu ces 40 années :
  - elle est devenue religieuse et a fondé le Sanctuaire ;
  - elle a tenté d'empêcher le Projet ARCHE, en vain (Hae-in a signé quand même) ;
  - elle a regardé grandir **sa propre version jeune**, qu'elle a formée au bénévolat.
- Quand la Tour est apparue de nouveau, elle a conclu que le destin ne se réécrit pas. **La seule miséricorde serait la Page Finale** : laisser l'Archive prendre la Terre, où les morts « dorment en paix », sans plus aucune boucle.
- **Elle a fondé les Élus en secret** pour faire monter la Pression (les sacrifices) et capturer Haneul.
- **Elle a engagé Nadia** pour tuer Elias au J30 de sa première vie : *« Je t'ai tué pour t'épargner ce que je suis devenue. »*
- **La Page arrachée lui permet de se souvenir des boucles d'Elias.** À partir de la boucle 2, elle **régresse avec lui** : c'est un antagoniste qui apprend aussi.

**Révélation progressive au fil des boucles :**
| Niveau | Quand | Ce que le joueur découvre |
|---|---|---|
| 1 | Boucle 1 | Un Prophète masqué de blanc, à la voix altérée, qui orchestre les sacrifices |
| 2 | Boucle 2+ | Le Prophète **anticipe** Elias : *« Tu as encore choisi de la sauver. »* Il se souvient |
| 3 | Boucle 3+, quête **La Crypte** (Myeongdong) | Indices : des **lunettes rondes rafistolées au scotch** et un **bracelet tressé rouge** vieilli de 40 ans, identiques à ceux de Seo-Yeon. Un ordre secret : *« Ne touchez jamais à la médecin »*. Démasquage d'Agatha |
| 4 | Boucle 4+ | La **Page arrachée** : Agatha est une régresseuse |
| 5 | Lien fort avec Seo-Yeon ou Haneul | **Agatha est Seo-Yeon** : même immunité Souche Zéro, mêmes cicatrices aux mains. Haneul la reconnaît : *« Tu étais ma première Lectrice. »* |
| 6 | Confrontation finale | Sa motivation : elle a aimé Elias pendant 312 vies, et l'a tué pour le libérer |

**Mécaniques liées :**
- **Le paradoxe** : si la jeune Seo-Yeon meurt, Agatha **s'efface** peu à peu. C'est pourquoi le Prophète protège secrètement sa version jeune, tout en combattant Elias.
- **Les Lettres du Corbeau** : Agatha sème la jalousie dans la Cour (lettres anonymes, rumeurs). C'est le principal obstacle du Harem Absolu.
- **L'arc de Seo-Yeon** : *« Je ne deviendrai pas elle. »* La confrontation avec son futur soi est le climax de sa route.
- **L'issue de la confrontation** :
  - *Rédemption* : Agatha remet la Page. Elias gagne +1 Réécriture permanente et 1 emplacement d'Ancrage, et Seo-Yeon reçoit une « Lettre à moi-même » ;
  - *Exécution* : P −10, mais Seo-Yeon est traumatisée ;
  - *Alliance sombre* (Tyran) : les Élus deviennent la religion d'État de l'Empire ;
  - *Laisser faire* : P +20, mène vers une fin tragique.

### 16.4 Autres mystères
- **Le Champion d'Hier** (étage 8) : l'écho de la première vie d'Elias, sans Registre et sans espoir. Le vaincre donne un Souvenir de la première vie. L'épargner ouvre une fin cachée de la Strate 71–80.
- **Julien Moreau** (le père d'Elias) : Lecteur de la Tour de Paris, il n'a jamais su que son fils était devenu Lecteur à Séoul. Leur rencontre au Conclave (étage 50) est l'arc personnel post-J30 d'Elias.
- **Pourquoi Elias ?** Dans la première vie, il est le seul à avoir porté Haneul **sans rien lui demander**. Le Porteur porte, et c'est le sens caché de sa classe.

### 16.5 Collectibles de lore
- **Fragments de Strate** : un par étage, ils racontent le monde archivé.
- **Pages du Registre** : les Souvenirs, plus des pages « orphelines » écrites par les anciens Lecteurs.
- **Journal de Mère Agatha** : 12 pages cachées dans Séoul, qui ne deviennent lisibles qu'après la révélation de niveau 3.

---

## 17. Fins du jeu

| Catégorie | Fins |
|---|---|
| **Fins de voie** (×4, chacune avec des variantes selon P × IR) | *Le Refuge-Nation* (Héros) · *L'Empire des Ruines* (Tyran) · *L'Ombre au Sommet* (Loup) · *Le Roi des Contrats* (Mercenaire) |
| **Fins d'héroïne** (×10) | Une par Serment accompli : *La Main qui ne tremble pas*, *La Présidente sans Sceau*, *Le Lotus et le Tigre*, *Désobéissance*, *Le Pari du Dragon*, *Chanson pour une seule personne*, *Deux Loups*, *Le Soleil sous la Ville*, *L'Équation*, *Le Ciel* |
| **Fins de Dévotion / Pacte** | *Le Trône* (une héroïne en Dévotion devient Impératrice aux côtés d'Elias) · *La Laisse Brisée* (Rupture libératrice d'Aoi) · *Le Prix de la Porte* (une héroïne paie sa clause de rupture et revient libre) |
| **Fins de Constellation** (§13.3) | *Le Lecteur Seul* (Solo) · une fin par **Trio ou Quatuor légendaire** (*Les Trois Lames*, *Les Reines*, *Les Invisibles*…) · *La Maison de N* (épilogue dynamique pour toute autre composition) · *La Poupée* (Dévotion conditionnée d'Aoi, sombre) · *La Dernière Page — Version des Dix* (Constellation du Lecteur) |
| **Fins de Cour** | *La Maison* (Cour ouverte, Cohésion ≥ 70 et au moins 4 héroïnes) · *Le Roi et la Reine des Ruines* (Tyran avec Haneul qui choisit de régner, sombre) |
| **Fins du Harem Absolu** (§13.4) | *La Maison des Dix* (Lumière) · *Le Trône des Dix* (Ombre) · *La Nuit des Couteaux* (échec de la variante Ombre, tragique) |
| **Fins tragiques** | *Effacement* (P > 85) · *Couteau dans le dos* (trahison fatale) · *La Bête de la Tour* (Corruption 100) · *L'Administratrice* (Haneul corrompue) · *La Clé vendue* · *La Page Finale* (Agatha triomphe) · *La Dernière Page Blanche* (plus aucun Fragment d'âme après l'Aube) |
| **Fin du prologue** (J30) | *Aube Nouvelle* : la Tour contenue au J30, Haneul vivante. Elle **ouvre l'Ère des Strates** |
| **Fins de l'Ère des Strates** | *La Cité des Strates* (s'arrêter à l'étage 50 et bâtir une civilisation dans la Friche) · *Le Conclave* (unifier les 13 Lecteurs à l'étage 50) · *Le Fils de Paris* (fin personnelle Elias et Julien) |
| **Fins du Sommet** (étage 100) | *Le Nouvel Archiviste* : Elias et Haneul deviennent la Tour, gardiens bienveillants des mondes · *L'Archive Brisée* : toutes les Strates sont libérées, les mondes morts renaissent dans le chaos · *La Loi Réécrite* : la Terre est libre, et la Tour devient une ressource et un pont entre les mondes |
| **Fin vraie** | ***La Dernière Page*** : la Loi Réécrite, Haneul **humaine** et libre, Agatha rachetée, le Registre détruit volontairement. Conditions : la fin du prologue *Aube Nouvelle*, le Lien d'âme, au moins 6 Fins d'héroïnes réécrites dans la boucle gravée, l'étage 100 atteint, et la rédemption d'Agatha |

---

## 18. Direction artistique, voix & médias

### 18.1 Portraits animés : Live2D / Spine
- **Live2D** pour les **portraits de dialogue** (en buste et en mi-corps) d'Elias, des 10 héroïnes et des PNJ majeurs (Agatha, Cheon Mu-gyeong, Jang…).
  - **Animations idle** : respiration, clignement, physique des cheveux et des vêtements, balancement.
  - **Expressions** : 12 de base (neutre, joie, rire, colère, tristesse, larmes, gêne, surprise, peur, mépris, désir, épuisement), plus 3 signatures par personnage (exemples : les LEDs rouges de Minh-Anh, le sourire de scène figé d'Aoi, l'éventail fermé de Xiaoyu).
  - **Variantes de tenues** : base, combat, détente, voie et Ère des Strates. Les états changeants sont aussi gérés (cheveux de Haneul qui s'assombrissent, racine noire d'Aoi qui repousse, glyphe-sceau du Pacte).
  - **Lip-sync** sur la voix IA (§18.3).
- **Spine** pour les **sprites de combat** (en pied, proportions manhwa) et les **cut-ins** d'Ultime et de Synergie.

### 18.2 CG HD fixes
- **Format** : masters en 3840×2160, export runtime en 2560×1440 (PC) et 1920×1080 (mobile).
- **Variantes par calques** : expressions, Ressentiment ou Trouble (Pacte), tenues, éclairage.
- **Volume estimé :**
| Catégorie | Par héroïne | Total |
|---|---|---|
| Histoire (rencontre, Fin, réécriture, climax de route) | 4 | 40 |
| Romance et intimité (Serment, Cour) | 4 | 40 |
| Pacte (signature, P2, P3) | 3 | 27 (Haneul exclue) |
| Fin d'héroïne | 1 | 10 |
| Histoire principale et Elias | — | 40 |
| Harem Absolu et Ère des Strates | — | 40 |
| **Total** | | **≈ 200 CG**, plus leurs variantes |

### 18.3 Système de voix IA
- **Option globale `Voix : Activé / Désactivé`** dans le menu Options > Audio, activée par défaut. Désactivée, le jeu reste entièrement jouable en texte.
- **Sous-options** : volume des voix, activation par personnage, et **langue des voix : coréen ou japonais** (deux pistes générées). Les sous-titres sont en français.
- **Déclencheurs** (quand l'option est active) :
| Contexte | Doublage |
|---|---|
| **Apparition** d'un personnage principal dans une scène | Une réplique d'entrée vocalisée |
| **Scènes clés** (Ancres, révélations, Fins, réécritures, boss, Conseil de la Maison) | Intégralement doublées |
| **Scènes intimes et 18+** (Serment, Cour, Dévotion, Pacte) | Intégralement doublées, avec les ambiances |
| **Combat** | Barks de compétences, d'Ultimes, de KO et de Synergies |
| Dialogues courants | Texte seul, avec option de « grunts » (interjections courtes) |
- **Pipeline de production** (hors ligne, avant le build) :
  1. le script est exporté en CSV (`line_id`, personnage, texte, émotion, intensité, contexte) ;
  2. la génération se fait par lots via une API de synthèse vocale de haute qualité (type ElevenLabs), avec un **`voice_id` par personnage** conçu à partir de la ligne « Voix » de sa fiche physique (Haneul utilise **deux pistes superposées**) ;
  3. post-traitement : normalisation à −16 LUFS, découpe des silences, export en OGG Vorbis ;
  4. import dans Godot, puis lecture par `VoiceManager` à partir du `line_id` ;
  5. **une empreinte (hash) du texte** permet de régénérer automatiquement les lignes modifiées.
- **Volume estimé** : environ 6 000 répliques doublées (un quart du script) **par langue**, soit 1,2 à 2 Go en OGG pour les deux pistes.
- **Adaptation** : le script source est en français, puis traduit en coréen et en japonais pour la génération. Les honorifiques (*-ssi*, *-nim*, *-san*, *-sama*) sont conservés, et le registre de chaque personnage est fixé dans sa fiche (Ryeon en coréen archaïque honorifique, Aoi en dialecte du Kansai en japonais, accents gardés pour Simone, Nadia et Maricel).

### 18.4 Galerie : les « Mémoires du Registre »
- **Galerie de CG** et **relecture des scènes** (avec la voix), débloquées de façon permanente entre les boucles (MetaSave).
- **Codex des personnages** avec les fiches physiques complètes, les Fins découvertes et les dynamiques vécues.

### 18.5 Lecteur webtoon
- Scènes clés en **défilement vertical** : cases, bulles, SFX dessinés, transitions par « gouttières » noires ou blanches.
- **Affichage paysage exclusif** (PC et mobile) : la bande webtoon défile **verticalement au centre de l'écran**. Les côtés affichent l'arrière-plan flouté de la scène et les portraits Live2D des personnages qui parlent. Le défilement se fait au glissement ou à la molette, avec une option d'avance automatique.

### 18.6 Pipeline de génération visuelle par IA
**Choix validé** : génération par IA (Midjourney et Stable Diffusion), avec des modèles **LoRA** pour la cohérence des personnages.

| Étape | Outil | Détail |
|---|---|---|
| **1. Concepts** | Midjourney (`--cref` / `--sref` pour la cohérence) ou Stable Diffusion | Planches de recherche par personnage, à partir des fiches physiques (§10.3, §12) : visage, silhouette, tenues, palette. Une **planche de référence validée** par personnage (face, profil, 3/4, dos, en pied) |
| **2. Style global** | Un **LoRA de style « manhwa premium »** entraîné sur la direction artistique validée | Garantit l'unité visuelle (encrage, ombrage, rendu des yeux) sur tout le jeu |
| **3. LoRA de personnage** | Entraînement local (kohya_ss ou équivalent) sur un modèle de base SDXL orienté illustration (famille Illustrious ou Pony, par exemple) | 1 LoRA par personnage (Elias, les 10 héroïnes, les PNJ majeurs), 25 à 40 images curées par jeu de données. Un **mot-déclencheur** unique par personnage (`elias_kang`, `seoyeon_park`…). Des LoRA de **tenues** séparés (base, combat, détente, voie, Strates) |
| **4. Génération des CG** | Stable Diffusion en local (interface ComfyUI) | **ControlNet** (OpenPose, profondeur, lineart) pour imposer les poses et la composition ; **IP-Adapter** pour renforcer la ressemblance ; **régional prompting** ou masques pour les CG **à plusieurs personnages** (duos, trios, scènes des Dix), chaque zone recevant son propre LoRA |
| **5. Contenu 18+** | **Stable Diffusion en local uniquement** | Midjourney refuse le contenu explicite : toutes les CG intimes passent par le pipeline local |
| **6. Retouche** | Inpainting (mains, yeux, détails anatomiques et vestimentaires), retouche manuelle | Une **checklist de cohérence** par CG : cicatrices, tatouages, couleur des yeux, mèche argentée de Hae-in, ruban rouge de Ryeon, bracelets d'Aoi… |
| **7. Upscale** | Upscaler 4× (famille ESRGAN), puis passe de détail | Masters en 3840×2160 |
| **8. Live2D / Spine** | Génération en **pose neutre de face**, puis **découpage en calques** (cheveux avant et arrière, yeux, bouche, bras, vêtements), assisté par des outils de séparation de calques et complété à la main | Les calques sont ensuite riggés dans Live2D Cubism ou Spine. C'est l'étape la plus manuelle du pipeline |
| **9. Webtoon & dioramas** | Les mêmes LoRA, en cadrage de cases ; les dioramas sont générés en calques de profondeur pour la parallaxe | Variantes jour/nuit et intact/détruit par img2img contrôlé |

- **La bible de prompts** (`tools/art_pipeline/prompts/`) contient, par personnage, le mot-déclencheur, les tokens physiques, les négatifs, les poids de LoRA et les seeds de référence. Elle est **versionnée** pour pouvoir reproduire chaque CG.
- **Les états évolutifs** (cheveux de Haneul qui s'assombrissent, racine noire d'Aoi qui repousse, glyphe-sceau du Pacte) sont des **LoRA de variante** ou des tokens dédiés.

---

## 19. Architecture technique

### 19.1 Moteur : **Godot 4.x** (dernière version stable)
| Critère | Pourquoi Godot |
|---|---|
| **Licence** | MIT : gratuit, sans redevance, aucune restriction de contenu |
| **2D / 2.5D** | Excellent pipeline 2D (parallaxe, shaders, Tweens, UI) pour les dioramas, la carte, l'UI webtoon et le combat sur grille |
| **Multiplateforme** | Windows, macOS, Linux, Android et iOS depuis un seul projet |
| **Langage** | **GDScript**, préféré à C# pour des exports mobiles sans friction |

### 19.2 Une seule version, tout le contenu intégré
- **Un seul build**, sans packs séparés, sans paliers, et sans age gate de distribution : tout le contenu 18+ fait partie du jeu.
- **Préférences du joueur** (options, toutes activées par défaut) : masquer les scènes de Pacte P3, désactiver la voix, sauter les scènes déjà vues. Ce sont des réglages de confort, pas des versions.
- **Installation sur les plateformes, en usage personnel** :
| Plateforme | Méthode |
|---|---|
| **Windows / Linux / macOS** | Export direct d'un exécutable |
| **Android** | Export APK (ou AAB), installé en direct sur l'appareil (autoriser les sources inconnues) |
| **iOS** | Export d'un projet Xcode, puis installation sur l'appareil avec son propre identifiant Apple. Avec un identifiant **gratuit**, le profil doit être resigné tous les 7 jours ; un **compte développeur payant** donne un profil valable 1 an |

### 19.3 Structure du projet
```
manhwa-rpg/
├── project.godot
├── addons/
│   ├── dialogic/              # Narration (Dialogic 2)
│   ├── gd_cubism/             # Live2D (portraits)
│   └── spine_godot/           # Spine (combat, cut-ins)
├── core/                      # Autoloads (singletons)
│   ├── game_state.gd          # État global de la boucle en cours
│   ├── time_manager.gd        # Jours, phases, Fatigue, Ancres, Pulsations
│   ├── loop_manager.gd        # Régression, Échos, Souvenirs, Ancrages, Aube, Dette
│   ├── registre.gd            # Fins, Lecture, Pressentiment, Réécriture
│   ├── class_manager.gd       # Classes, sous-classes, Maîtrise, gravure, Dissonance
│   ├── tower_pressure.gd      # Pression P, IR, Nuit du Déversement
│   ├── alignment.gd           # Axes, réputations locales, témoins, rumeurs
│   ├── relations.gd           # Jauges, dynamiques, Pacte, Ambivalence, Cohésion, trahisons
│   ├── harem_house.gd         # Conseil de la Maison, Quartiers, Harem Absolu
│   ├── domain_manager.gd      # Ère des Strates : Domaine, technologies, expéditions
│   ├── voice_manager.gd       # Voix IA : On/Off, lecture par line_id, lip-sync
│   ├── preferences.gd         # Préférences de confort du joueur
│   └── save_manager.gd        # RunSave + MetaSave
├── data/
│   ├── characters/            # elias.json + 10 héroïnes + PNJ (cf. 19.5)
│   ├── classes/               # arbres, compétences, conditions
│   ├── sectors/  clans/  anchors/  fins/  floors/  strates/
│   ├── combat/                # skills/, enemies/, encounters/
│   └── localization/          # fr.csv (source), en.csv, ko.csv
├── narrative/                 # main/ heroines/ pacte/ harem/ strates/ prophete/
├── scenes/                    # world_map/ sector_map/ diorama/ webtoon_reader/ combat/ refuge/ domain/ registre_ui/ gallery/
├── assets/
│   ├── live2d/  spine/  cg/  dioramas/  webtoon/  ui/
│   ├── voice/<langue>/<personnage>/<line_id>.ogg
│   └── music/  sfx/
└── tools/
    ├── data_import/           # Tableurs → JSON + validation
    ├── voice_pipeline/        # Export du script → TTS → OGG → import
    ├── art_pipeline/          # Bible de prompts, LoRA (style, personnages, tenues), workflows ComfyUI
    └── build/                 # Export des 5 plateformes en une commande
```

### 19.4 Briques clés
- **Narration** : Dialogic 2 comme lecteur. Toute la logique d'état reste dans `GameState`. Chaque nœud narratif porte des tags : `heroine`, `dynamic` (serment, cour, devotion, pacte), `requires`, `effects`, `voice`.
- **Lecteur webtoon** (`ScrollContainer` vertical), **diorama 2.5D** (`Parallax2D` + `Camera2D`, hotspots `Area2D`) et **combat** (scène indépendante). Le combat est piloté par les données, avec des intentions déclarées avant le tour et une frise CTB.
- **Sauvegardes** :
  - **MetaSave** : Souvenirs, Échos, classes gravées, Ancrages, Codex, galerie, Dette, Aube gravée ;
  - **RunSave** : boucle en cours, 3 emplacements plus une sauvegarde automatique à chaque phase ;
  - JSON versionné, avec une somme de contrôle.
- **Mémoire sur mobile** : avec environ 200 CG et des modèles Live2D, chargement **à la demande** (CG en WebP, textures ASTC ou ETC2). Seuls les assets de la scène courante restent en mémoire.

### 19.5 Schéma de données d'un personnage (extrait)
```jsonc
// data/characters/seo_yeon.json
{
  "id": "seo_yeon",
  "name": { "fr": "Park Seo-Yeon", "ko": "박서연", "en": "Park Seo-yeon" },
  "age": 27,                        // OBLIGATOIRE, validé ≥ 18 par l'outil d'import
  "physique": {
    "height_cm": 163, "weight_kg": 52,
    "eyes": "brun chocolat", "hair": "châtain foncé, mi-longs, chignon défait",
    "body": "menue, taille fine", "skin": "claire rosée",
    "marks": ["lunettes rondes scotchées", "grain de beauté œil droit", "bracelet tressé rouge"],
    "palette": ["#9ccbe8", "#e8dcc4", "#f5f2ea", "#c0392b"]
  },
  "voice": { "voice_id": "tts_seo_yeon_v1", "timbre": "soprano légère, douce" },
  "origin": "KR", "sector": "yeouido", "affiliation": ["camp_yeouido", "sanctuaire"],
  "axes": { "protect_dominate": -70, "bond_solitude": 60 },
  "gauges_start": { "affinity": 10, "trust": 10, "fear": 0, "ambition": 0 },
  "traits": ["accepts_sharing_high_cohesion", "no_devotion"],
  "betrayal": { "threshold": 30, "absolute_triggers": ["kill_civilians_witnessed", "sold_to_clan"], "form": "poison_and_flee" },
  "fin": { "id": "fin_seo_yeon_01", "day": 12, "phase": "dusk", "node": "yeouido.hospital", "next_fin": "fin_seo_yeon_02" },
  "dynamics": {
    "oath": true, "open_court": "cohesion>=70", "devotion": false,
    "pacte": { "available": true, "leverage": ["dette_de_vie"], "ambivalence_start": -40, "likely_fate": ["rupture", "couteau"] }
  },
  "combat": { "class": "field_surgeon", "row": "back", "skills": ["triage", "adrenaline", "code_blue"] },
  "intimacy": {
    "temperament": "shy_opens_with_trust",
    "scenes": [
      { "id": "seo_p2_restroom", "tier": "P2", "dynamic": "serment|cour", "requires": { "affinity": 70, "trust": 60 }, "cg": "cg_seo_04", "voiced": true },
      { "id": "seo_p3_bunker",   "tier": "P3", "dynamic": "serment|cour", "requires": { "affinity": 85, "trust": 75 }, "cg": "cg_seo_06", "voiced": true },
      { "id": "seo_pacte_p2",    "tier": "P2", "dynamic": "pacte", "requires": { "pacte": true }, "variants": ["ressentiment", "trouble"], "cg": "cg_seo_pacte_02", "voiced": true }
    ]
  }
}
```
- **Validation à l'import** :
  - `age ≥ 18` obligatoire pour tout personnage qui a un bloc `intimacy` ;
  - toute scène intime porte `violence: none` ;
  - les scènes `dynamic: pacte` exigent un Pacte signé (jamais pour Haneul) ;
  - chaque `cg` et chaque ligne `voiced` doit exister dans les assets (rapport des manquants).

### 19.6 Budgets de performance
| | PC | Mobile |
|---|---|---|
| Résolution de référence | 1920×1080 (UI adaptative jusqu'en 4K) | 2400×1080, **paysage exclusif** (orientation verrouillée), UI adaptée aux écrans 20:9 et aux encoches |
| Textures de diorama | 4096 px max | 2048 px max, compression ASTC / ETC2 |
| Mémoire cible | < 2,5 Go | < 1 Go (streaming des CG et des voix) |
| Taille de l'installation | 6 à 8 Go (CG, voix, Live2D) | 3 à 4 Go |

---

## 20. Périmètre de la démo

| Élément | Contenu de la démo |
|---|---|
| Durée de jeu | 2 à 3 heures |
| Temps | **J1 à J7** (Acte I complet), avec **1 régression scénarisée** au J7 (mort contre le Portier) |
| Carte | **Yongsan** + **Yeouido** + l'**étage 1** de la Tour |
| Héroïnes | **Seo-Yeon** (route jusqu'au palier « Proche », **et** une branche Pacte via le camp vassal), **Haneul** (rencontre via le Souvenir n°4), **Hae-in** (premier contrat). **Nadia** en teaser |
| Classes | Vétéran-Recouvreur + Porteur, et le déblocage de *Gardien* ou de *Seigneur de Guerre* selon la voie. Démonstration de la gravure à la régression |
| Combat | 5 types d'ennemis, 1 boss à Règle (le Portier aux Mille Clés), grille 3×3, Pressentiment et Réécriture |
| Médias | Live2D pour Elias, Seo-Yeon, Haneul et Hae-in · 8 CG HD, dont 2 intimes (1 Serment, 1 Pacte) · voix IA sur les apparitions, les scènes clés et les scènes intimes, avec l'option On/Off |
| Objectif technique | Valider la chaîne complète : données → narration → carte → combat → classes → régression → voix → sauvegarde → export PC et Android |

---

## 21. Réponses validées & questions ouvertes

### 21.1 Réponses validées
| Question | Réponse | Section |
|---|---|---|
| Doublage | Voix IA haute qualité, avec une option globale **On/Off**. Déclenchées sur les apparitions, les scènes clés et les scènes intimes | §18.3 |
| Langue des voix | **Coréen et japonais** (deux pistes au choix), sous-titres en français | §18.3 |
| Format | **Jeu complet d'un seul bloc** | §0 |
| Visuels | **Live2D / Spine** + **CG HD fixes** | §18.1–18.2 |
| Production visuelle | **Génération IA** : Midjourney (concepts) et Stable Diffusion en local avec des **LoRA** de style, de personnage et de tenue | §18.6 |
| Le Prophète | **Mère Agatha**, qui est Seo-Yeon venue d'une ligne effondrée | §16.3 |
| Distribution | Projet personnel. Une seule version avec tout le contenu, sans autocensure | §0, §19.2 |
| Périmètre v1.0 | **Séoul + étages 1 à 50**. Carte mondiale et étages 51 à 100 en extension | §15 |
| Mobile | **Paysage exclusif** | §18.5, §19.6 |
| Combinaisons | Toutes les compositions, du Solo aux 10, avec synergies, scènes et sous-routes | §13.3 |
| Fin des 10 | Difficulté **Extrême**, règles du **Poids du Destin** et de l'**Épreuve des Dix** | §13.4.5 |

### 21.2 Nouvelles questions
1. **Modèle de base pour les LoRA** : préfères-tu un rendu manhwa « semi-réaliste » (proche de *Solo Leveling* ou *Omniscient Reader*) ou plus « anime » (proche de *Raising the Princess*) ? Ce choix détermine le modèle de base et le LoRA de style.
2. **Ordre de production** : faut-il commencer par la démo Acte I (§20) avec les 4 héroïnes de Yeouido et Yongsan, ou d'abord par les planches de référence des 11 personnages pour verrouiller le charadesign ?
3. **Écriture du script** : le jeu représente environ 25 000 répliques, avec des scènes modulaires. Écris-tu tout toi-même, ou veux-tu un pipeline d'écriture assisté (brouillons générés à partir des fiches, puis réécriture) ?
4. **Musique** : OST originale (générée par IA ou composée), ou musique libre de droits ?
