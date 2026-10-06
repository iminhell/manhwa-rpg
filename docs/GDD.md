# LA TOUR DU DERNIER JOUR — Game Design Document v0.2

> RPG narratif et tactique inspiré des manhwas/webtoons, à haute liberté de choix.
> **Statut** : pré-production. Le document de conception fait foi avant toute phase de code.
> Toutes les valeurs chiffrées sont des points de départ à équilibrer pendant le prototype.
> **Public** : 18+ (version adulte complète), avec des versions « Standard » pour les stores mobiles (voir §15).

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
10. [Fiche du protagoniste — Elias Kang](#10-fiche-du-protagoniste--elias-kang)
11. [Système de harem : règles communes](#11-système-de-harem--règles-communes)
12. [Les 10 héroïnes](#12-les-10-héroïnes)
13. [Matrice de cohésion & Fins liées](#13-matrice-de-cohésion--fins-liées)
14. [Fins du jeu](#14-fins-du-jeu)
15. [Architecture technique (Godot, multiplateforme, contenu 18+)](#15-architecture-technique)
16. [Périmètre de la démo](#16-périmètre-de-la-démo)
17. [Questions ouvertes](#17-questions-ouvertes)

---

## 0. Décisions validées

| Sujet | Décision |
|---|---|
| Univers | **Concept A — La Tour du Dernier Jour** (apocalypse, Système/Tour, régression), avec des factions-chaebols et une héroïne-pivot |
| Protagoniste | Homme métis, 1m84, imposé : **Elias Kang** (§10) |
| Casting romançable | **10 héroïnes** uniques, de profils, d'âges (22 à 41 ans) et d'origines variés (§12) |
| Plateformes | PC (Steam, Itch.io), Mobile (iOS, Android) |
| Contenu | Explicite 18+ dans la version adulte complète. Architecture par **paliers de contenu** (§15.4) |
| Ratio de jeu | **60 %** narration / choix / carte — **40 %** combat tactique au tour par tour (grilles 3×3) |
| Régression | Vraie boucle temporelle : mémoire, connaissances et compétences conservées à chaque mort ou échec (§4) |
| Moteur | **Godot 4.x** (GDScript), recommandation détaillée en §15 |

**Règles de design non négociables (éthique et conformité stores) :**
1. **Tous les personnages romançables sont des adultes.** Leur âge est inscrit dans les données, leur charadesign a des proportions adultes, et le jeu ne contient ni uniforme scolaire ni design ambigu.
2. **Le consentement conditionne toute scène intime.** La peur, la contrainte ou le chantage n'ouvrent jamais de scène romantique ou sexuelle. Ils produisent un **Masque** (§11.3), qui mène tôt ou tard à la trahison.
3. **Les rapports de domination entre adultes consentants existent** (la dynamique **Dévotion**, §11.3). Ils exigent une Affinité et une Confiance élevées, et l'héroïne doit les désirer explicitement.

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
| **Titres de Premier Conquérant** | Être le premier à vaincre un Gardien inscrit le nom d'Elias dans les Archives de la Tour, de façon permanente : bonus de stats et −2 de Pression par étage |
| **Ancrages** (3 emplacements, 5 en fin de jeu) | Des choix majeurs que le joueur « grave » pour qu'ils persistent. Exemples : *les tunnels de Myeongdong sont étayés*, *le Prophète des Élus est déjà démasqué*, *Haesong ignore l'existence du Projet ARCHE*. Graver un Ancrage coûte 1 Fragment d'âme, obtenu en réécrivant une Fin |
| **Codex des Fins** | Toutes les Fins découvertes, avec leurs causes profondes connues |

### 4.4 Échos affectifs
- **Si une héroïne a atteint le Serment ou la Dévotion dans une boucle passée** : elle démarre la boucle suivante avec **Affinité +15**, des **déjà-vu** (dialogues spéciaux, rêves partagés) et, après trois boucles de Serment, des souvenirs conscients (arc « Elle se souvient »).
- **Si Elias l'a trahie, tuée ou mise sous Masque** : elle démarre avec **Peur +10** et **Confiance −10**, et fait des cauchemars à son sujet. C'est la mémoire du corps.
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
| **Le Sanctuaire** | Myeongdong | Mère Agatha Seo (60 ans) | Soins, refuge, garante de la Trêve | Allié naturel du Héros. Garde une crypte et sa relique |
| **Les Rats du Han** | Ponts du Han, Myeongdong (sous-sol) | « Grand-père Pigeon », puis **Maricel** | Contrebande, information, tunnels | Allié naturel du Loup et du Mercenaire |
| **L'Unité 0** | Yongsan | **Cdt Simone Hayes** | Ordre militaire, quarantaine, canal radio vers l'extérieur | Tient le Protocole Cendre |
| **Les Élus** | Yongsan, étages 1 à 3 | **Le Prophète** (identité cachée) | Culte de la Tour, sacrifices (P +5) | Antagonistes. Veulent l'Héritière |
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
| « Protéger » contre un tribut | Dominer +10, ressources +++ | Camp vassal. Seo-Yeon sous **Masque**, révolte au J15 |
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
| **Classe Système visible** | **Porteur (F)**, le rang le plus méprisé |
| **Classe réelle (cachée)** | **Lecteur des Fins (EX)**, révélée à la fin de l'Acte I ou à la boucle 2 |

### 10.2 Background
- **Enfance à Itaewon (Yongsan)**. Un enfant métis dans un quartier de bases militaires, de bars et de regards. Il apprend tôt deux choses : frapper le premier, et se taire pour protéger sa mère. Elle lui coud ses vêtements et lui répète **« 살아남아 » (« survis »)**.
- **14 ans**. Sa mère meurt d'un cancer non soigné, faute d'argent. Son père ne vient pas à l'enterrement. Elias passe chez une tante, puis à la rue, puis dans les salles de boxe.
- **19–25 ans**. Recruté par une société militaire privée grâce à son passeport français et à sa carrure. Il en garde des réflexes, des cicatrices, et une mission au Sahel qu'il ne raconte jamais : il y a obéi à un ordre qu'il n'aurait pas dû suivre.
- **25–29 ans**. Retour à Séoul, endetté. Il « récupère » de l'argent pour Longwei, ce qui lui vaut une réputation de type calme et dangereux qui ne frappe que quand c'est nécessaire.
- **Première vie (avant la régression)** :
  - éveillé **Porteur (F)**, il survit par la ruse, sans rien sauver ni personne ;
  - au **J20**, il rencontre l'**Héritière** à l'étage 1 et décide pour la première fois de protéger quelqu'un ;
  - il la porte jusqu'au sommet de l'étage 10 ;
  - au **J30 à 23h58**, il est abattu d'une balle dans la nuque par une silhouette au fusil (Nadia, ce qu'il découvrira) ;
  - en mourant, l'Héritière pose la main sur ses yeux, et il se réveille au J1.
- **Ce qu'il ignore au départ** : pourquoi elle l'a choisi, qui a payé le tireur, et ce qu'est vraiment le Registre.

### 10.3 Charadesign
- **Silhouette** : grande, épaules larges, taille fine. Une musculature sèche de combattant, pas de bodybuilder. Il se tient légèrement voûté au repos, comme un fauve qui économise ses forces, et se redresse d'un coup en combat.
- **Peau** : brun clair, caramel chaud.
- **Visage** :
  - traits affûtés : mâchoire nette, pommettes hautes héritées de sa mère, nez droit, barbe de trois jours ;
  - regard **noisette ambré**, mi-clos, ironique.
- **Cheveux** : noirs, épais et bouclés, coupés court sur les côtés et plus longs au-dessus. Quelques mèches tombent sur le front.
- **Signes distinctifs** :
  - cicatrice verticale qui fend le sourcil gauche ;
  - brûlure sur l'avant-bras droit ;
  - impact de balle cicatrisé sur le flanc gauche ;
  - tatouage sur l'avant-bras intérieur gauche, **살아남아**, dans l'écriture de sa mère.
- **Registre activé** : les iris virent à **l'or** et un **anneau d'horloge** tourne autour des pupilles. Des glyphes dorés courent le long des veines du cou. C'est l'effet visuel signature.
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

- **Compétences de base** : *Combat rapproché (PMC) Niv.2*, *Armes à feu Niv.2* (inutilisables dans la Tour, règle de l'étage 1), *Intimidation Niv.1*, *Endurance du Porteur* (+50 % de capacité d'inventaire, la seule bonne surprise du rang F).

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

### 10.7 Profil mature (données 18+, version adulte uniquement)
Ces données ne sont chargées que si le palier de contenu « Adulte » est actif (§15.4).

| Champ | Valeur |
|---|---|
| Orientation | Hétérosexuel |
| Expérience | Adulte expérimenté, relations passées brèves. Aucune relation durable depuis la PMC |
| Tempérament intime, selon la voie | **Héros** : tendre, protecteur, attentif. **Tyran** : dominant, possessif, uniquement avec des partenaires qui recherchent cette dynamique (Dévotion, Cour). **Loup** : rare, intense, distant après coup, la vulnérabilité comme enjeu. **Mercenaire** : joueur, taquin, séduction par le défi |
| Évolution | Le tempérament se module par héroïne : chaque partenaire « révèle » une facette différente d'Elias |
| Limites de design | Consentement explicite et enthousiaste, toujours. Aucune scène sous Masque. Une scène peut être refusée par l'héroïne selon ses jauges, sans pénalité punitive |
| Paliers de scènes | P1 Romance (tous publics), P2 Intime (fondu au noir, suggestif), P3 Explicite (version adulte) |

---

## 11. Système de harem : règles communes

### 11.1 Les jauges
| Jauge | Plage | Augmente par | Effet |
|---|---|---|---|
| **Affinité** | 0–100 | Temps passé, cadeaux, choix qui correspondent à ses valeurs | Scènes personnelles, romance |
| **Confiance** | 0–100 | Promesses tenues, Fins réécrites pour elle, vérité dite | Stabilité, Synergies avancées |
| **Peur** | 0–100 | Menaces, démonstrations de force, punitions | Obéissance à court terme, nourrit l'Ambition cachée |
| **Ambition cachée** | 0–100 (cachée) | La Peur, la frustration, son agenda propre | Une Ambition au-dessus du seuil rend la trahison possible |

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

### 11.3 Les trois dynamiques (plus le Masque)
| Dynamique | Condition | Effet | Contenu intime |
|---|---|---|---|
| **Serment** (exclusif) | Affinité ≥ 80, Confiance ≥ 80, fin de la quête personnelle, aucune autre relation intime en cours | Synergie *Serment* (la plus puissante), fin dédiée, Échos affectifs maximaux | Oui (P1 à P3) |
| **Cour ouverte** (polyamour) | Affinité ≥ 60, Confiance ≥ 50, l'héroïne **accepte le partage** (trait propre), Cohésion de la Cour ≥ 50 | Synergies multiples, scènes de groupe à la Maison, fin « Maison » | Oui (P1 à P3, scènes de groupe si toutes les héroïnes impliquées y consentent) |
| **Dévotion** (domination consentie) | Affinité ≥ 70, Confiance ≥ 85, l'héroïne a le **trait « Dévotion »** et le désire, souvent sur la voie du Tyran | Synergie *Ordre absolu* sans coût d'Ambition. Elle choisit de servir, et peut reprendre ce choix | Oui (P1 à P3, dynamiques de pouvoir consenties) |
| **Masque** (soumission par la peur) | Peur ≥ 60 et Confiance < 40 | Obéissance totale, efficacité +20 %. **L'Ambition cachée monte chaque jour**, et la trahison est presque certaine | **Non.** Aucune scène intime. Ses dialogues sonnent faux, et *Lecture des Cœurs* révèle le Masque |

- **Sortir du Masque** : un arc de rédemption (excuses, libération, Fin réécrite) peut faire tomber le Masque. L'héroïne garde alors **Confiance plafonnée à 70** pour la boucle.
- **Verrou de design** : une héroïne qui a été sous Masque ne peut pas atteindre la Dévotion dans la même boucle.

### 11.4 Cohésion de la Cour
- La **Cohésion** (0–100) est une jauge commune aux héroïnes « liées » en Cour ouverte. Elle se calcule à partir de la matrice de compatibilité (§13.1), du temps partagé au Refuge, de l'équité d'attention et des événements de groupe.
- **Au-dessous de 30** : jalousies, ultimatums, départs ; une Ambition cachée peut être activée chez les héroïnes à fort ego.
- **Au-dessus de 70** : scènes de groupe, Synergies en trio, événement « Nuit de la Maison ».

### 11.5 Trahison : règles générales
- Chaque héroïne a un **seuil de trahison** (une valeur de Loyauté) et des **déclencheurs**.
- La trahison survient lors d'un **moment critique** (boss, siège, Sommet des Sceaux, J24, J28, J30) si Loyauté < seuil, ou immédiatement si un déclencheur absolu est touché.
- **Signes avant-coureurs** obligatoires (au moins 2, sur 2 jours différents), pour que la trahison reste juste et lisible.
- **Réponses possibles** : confronter, pardonner, exécuter, retourner (agent double), laisser faire pour remonter au commanditaire.

### 11.6 Calendrier relationnel
- **Rendez-vous** : 1 phase. Au plus 1 événement de relation majeur par jour et par héroïne.
- **Nuit au Refuge** : en phase Nuit, choisir avec qui passer la soirée (événements de quotidien, de confidence, intimes).
- **Cadeaux** : chaque héroïne a 3 cadeaux aimés, 3 détestés et 1 cadeau « clé », lié à son passé.

---

## 12. Les 10 héroïnes

> Format commun : identité → rôle → charadesign → personnalité → Fin du Registre → secret → recrutement → trahison → dynamiques → combat → notes 18+.
> **Tous les âges sont fixés dans les données et sont ceux de personnages adultes.**

### Vue d'ensemble
| # | Nom | Âge | Origine | Secteur / affiliation | Archétype | Fin |
|---|---|---|---|---|---|---|
| 1 | **Park Seo-Yeon** | 27 | Coréenne | Yeouido, Camp / Sanctuaire | Soignante idéaliste | J12 |
| 2 | **Yoon Hae-in** | 41 | Coréenne | Yeouido, Haesong Holdings | Reine de glace (chaebol) | J21 |
| 3 | **Baek Ryeon** | 23 | Coréenne | Collines du Nord, Maison Baek | Princesse-épéiste orgueilleuse | J17 |
| 4 | **Simone Hayes** | 38 | Afro-américaine | Yongsan, Unité 0 | Commandante de fer | J28 (ou J24) |
| 5 | **Long Xiaoyu** | 31 | Chinoise (Shanghai) | Ponts du Han, Longwei | Reine de la pègre, femme fatale | J19 |
| 6 | **Aoi Tsukishiro** | 22 | Japonaise (Osaka) | Hongdae, Mirae (agence) | Idol brisée | J9 |
| 7 | **Nadia Tsoi** | 34 | Koryo-saram (Kazakhstan) | Gangnam, contractuelle de Cheonma | Sniper mercenaire, loup solitaire | J24 |
| 8 | **Maricel Dizon** | 26 | Philippine | Myeongdong (sous-sol), Rats du Han | Voleuse solaire | J14 |
| 9 | **Dr. Tran Minh-Anh** | 36 | Vietnamo-coréenne | Hongdae, Mirae (labo) | Scientifique obsessionnelle | J26 |
| 10 | **L'Héritière (« Haneul »)** | apparence 25 ans, adulte | Inconnue (la Tour) | Tour, étage 1 | Mystérieuse amnésique, clé du destin | J30 |

---

### 12.1 PARK SEO-YEON (박서연) — « La Main qui ne tremble pas »
- **Âge / taille** : 27 ans / 1m63. **Origine** : coréenne, née à Daegu.
- **Rôle** : interne en médecine d'urgence à l'hôpital Sainte-Marie de Yeouido. Au J2, elle devient de fait la cheffe médicale du Camp de Yeouido. Elle est liée au Sanctuaire (Mère Agatha l'a formée au bénévolat).
- **Archétype** : soignante idéaliste, la « bonne personne » qui refuse de devenir autre chose.
- **Charadesign** :
  - cheveux châtain foncé mi-longs, souvent attachés en chignon défait avec un crayon ;
  - grands yeux bruns cernés ; fines lunettes rondes, rafistolées au scotch après le J1 ;
  - silhouette menue mais tenace, mains abîmées par le désinfectant.
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
- **Secret lié au Registre** : elle est **immunisée** contre la souche de la Tour (la « Souche Zéro »). Son sang permettrait un vaccin de masse. Haesong et Mirae la veulent vivante, les Élus la veulent sacrifiée.
- **Recrutement** :
  - *Héros* : défendre le camp au J4 et tenir jusqu'au J6 ;
  - *Mercenaire* : la payer en médicaments et lui garantir des soins pour le camp ;
  - *Tyran* : par la contrainte (camp vassal), ce qui donne un **Masque** ;
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
  - **Masque** : sous la peur, elle soigne mécaniquement et sabote en secret.
- **Combat** : *Chirurgienne de Terrain*, en arrière.
  - soins ciblés, *Triage* (soigne tout le groupe, mais celui qui a le plus de PV en perd) ;
  - *Adrénaline* (relève un allié KO une fois par combat) ;
  - **Ultime** : *Code Bleu*, résurrection de groupe avec 30 % de PV.
- **Notes 18+** : tempérament timide qui se libère avec la Confiance. Cherche la tendresse et le réconfort après les nuits de garde. Scènes clés : la salle de repos de l'hôpital (P2), le bunker B6 (P3).

---

### 12.2 YOON HAE-IN (윤해인) — « La Présidente »
- **Âge / taille** : 41 ans / 1m72. **Origine** : coréenne, issue de l'aristocratie financière de Séoul.
- **Rôle** : présidente de **Haesong Holdings**, porteuse du **Sceau de la Balance** et Seigneur de Yeouido.
- **Archétype** : reine de glace, dirigeante de chaebol, figure d'autorité mûre et redoutable.
- **Charadesign** :
  - longs cheveux noirs de jais en chignon strict, une mèche argentée unique à la tempe ;
  - yeux en amande, regard d'évaluation permanent ;
  - lèvres rouge sombre, posture parfaite ;
  - boucles d'oreilles en jade impérial, héritage de sa mère.
- **Tenues** :
  - *base* : tailleur-pantalon blanc haute couture, manteau camel jeté sur les épaules (elle ne met jamais les manches), talons aiguilles, montre en or ;
  - *combat* : version renforcée, avec un trench noir aux doublures runiques (contrats du Système) et des gants blancs ;
  - *détente* : robe de soie bordeaux, cheveux détachés, un verre de vin. Elle ne se montre ainsi qu'à ceux qu'elle respecte.
- **Personnalité** :
  - calculatrice, élégante, ironique, d'une politesse coupante ;
  - méprise la faiblesse, mais respecte profondément la compétence ;
  - solitude glaciale : veuve, et sa fille unique, Yoon Da-bin (19 ans), est coincée **hors du Voile** ;
  - sur les axes : **Dominer +35, Lien −10**.
- **Aime / déteste** : le thé vert de Jeju, les échecs, les gens qui tiennent parole ; la flatterie, l'amateurisme, qu'on la touche sans permission.
- **Fin du Registre** : *J21, Jour, salle du conseil de la tour Haesong. Exécutée par le vice-président Nam Gi-seok lors d'un coup d'État interne.*
  - **Cause profonde** : Nam a pactisé avec Mirae et Cheonma pour récupérer le Sceau et enterrer le Projet ARCHE.
  - **Réécriture** : il faut exposer Nam avant le J21 (preuves dans les serveurs de Mirae, ou témoignage de l'Agent Shin), ou être présent au conseil avec assez de force pour inverser le coup.
  - **Nouvelle Fin débloquée** : *J30, assassinée par le Prophète des Élus, qui a besoin du Sceau de la Balance*.
- **Secret lié au Registre** : elle a signé le **Projet ARCHE**. Haesong Bio a capté des signaux sous Yongsan et y a envoyé une sonde… qui a reçu une **réponse**. Elle croit que la Tour est de sa faute, et elle cherche à la fois à **racheter sa faute et à l'effacer**.
- **Recrutement** :
  - *Mercenaire* : lui vendre 3 Souvenirs exploitables (des prédictions de marché), puis prouver sa valeur au J13 ;
  - *Héros* : la sauver au J21, avec l'arc du rachat d'ARCHE ;
  - *Tyran* : la vaincre politiquement (lui prendre son Sceau ou la mettre en minorité au conseil). Elle s'allie alors par pragmatisme, et peut glisser vers la Cour ;
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
  - **Masque** : son Masque est parfait (invisible sans *Lecture des Cœurs* Niv.2) et sa trahison la plus coûteuse.
- **Combat** : *Souveraine*, en arrière.
  - *Clause* : lie un ennemi, qui subit des dégâts s'il attaque la cible désignée ;
  - *Liquidation* : exécute un ennemi sous 20 % de PV et rapporte de l'argent ;
  - *Ordre du Conseil* : buff d'initiative de groupe ;
  - **Ultime** : *Faillite*, qui retire tous les buffs ennemis et vole leur Mana.
- **Notes 18+** : mène, exigeante, magnétique. Fait payer chaque centimètre de vulnérabilité, puis l'offre entièrement. Scènes clés : son bureau au 50e étage la nuit, devant la ville en ruines (P3), un bain au penthouse (P2).

---

### 12.3 BAEK RYEON (백련) — « Le Lotus Blanc »
- **Âge / taille** : 23 ans / 1m68. **Origine** : coréenne, héritière de la lignée Baek (escrimeurs depuis l'ère Joseon).
- **Rôle** : héritière de la Maison Baek, épéiste de rang A, première Exécutrice du clan.
- **Archétype** : princesse guerrière orgueilleuse, tsundere au cœur noble.
- **Charadesign** :
  - très longs cheveux noirs en queue de cheval haute, nouée d'un **ruban rouge** (celui de sa mère) ;
  - yeux gris acier, sourcils fins et sévères ;
  - silhouette athlétique et élancée, postures d'escrime parfaites ;
  - une cicatrice fine sur la clavicule, qu'elle cache.
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
- **Recrutement** :
  - *Héros* : défendre le domaine au J16, puis la sauver au J17 ;
  - *Tyran* : la vaincre en **duel formel** (Honneur) ; elle devient votre épée par serment martial, et la Dévotion est possible plus tard ;
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
  - **Masque** : impossible ; elle préfère mourir. Une Peur ≥ 60 déclenche le duel.
- **Combat** : *Sabre du Tigre Blanc*, à l'avant.
  - *Iai* : premier coup garanti critique si elle agit en premier ;
  - *Garde du Lotus* : contre-attaque ;
  - *Danse des Pétales* : frappe toute la ligne avant ;
  - **Ultime** : *Tigre Blanc Céleste*, gros dégâts qui ignorent la défense, avec une cut-in de tigre spectral ;
  - **Synergie avec Elias** : *Double Croisement*.
- **Notes 18+** : inexpérimentée et terriblement gênée. Elle réfléchit trop, puis se jette à l'eau avec la même intensité qu'en duel. Scènes clés : la source chaude cachée (P2), la nuit après le J17 (P3).

---

### 12.4 SIMONE HAYES — « Commandante Zéro »
- **Âge / taille** : 38 ans / 1m78. **Origine** : afro-américaine, née à Atlanta, militaire de carrière.
- **Rôle** : major de l'US Army, officière de liaison des forces américaines en Corée au moment du J0. Elle a pris le commandement de l'**Unité 0** (des restes de forces coréennes et américaines) à Yongsan, et détient le **code du Protocole Cendre**.
- **Archétype** : commandante de fer, autorité militaire, devoir avant tout.
- **Charadesign** :
  - peau brun foncé, cheveux en tresses plaquées courtes avec un undercut sur un côté ;
  - mâchoire carrée, cicatrice en diagonale sur la mâchoire gauche ;
  - regard noir perçant ;
  - carrure puissante, épaules larges, musculature athlétique de militaire ;
  - plaques d'identification et alliance portées au cou (veuve, voir le secret).
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
- **Secret lié au Registre** : son mari, le capitaine Marcus Hayes, est mort dans un accident d'entraînement à Yongsan il y a 2 ans. En réalité, il est mort pendant la **mission d'escorte de la sonde du Projet ARCHE**. Elle l'ignore. Le découvrir la fait basculer contre Haesong.
- **Recrutement** :
  - *Héros* : défendre les réfugiés du Musée de la Guerre et partager ses informations sur la Tour (des Souvenirs) ;
  - *Mercenaire* : contrat de l'Unité 0 (missions dans la Tour) ;
  - *Tyran* : alliance de force à force si Elias possède un Sceau. Elle reste méfiante ;
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
  - **Masque** : elle ne porte pas de Masque, elle **obéit à la hiérarchie**. Sous la Peur, elle devient un adversaire froid et loyal à l'Unité 0.
- **Combat** : *Commandante*, au milieu.
  - *Tir de suppression* : retarde toute une ligne ennemie dans la frise ;
  - *À couvert !* : bouclier de groupe ;
  - *Ordre tactique* : fait rejouer immédiatement un allié ;
  - **Forme Exosquelette** : bascule en Rempart à l'avant pendant 3 tours ;
  - **Ultime** : *Frappe d'artillerie*, des dégâts de zone sur toute la grille ennemie, mais une case aléatoire du joueur est touchée.
- **Notes 18+** : assurée, directe, physique. Elle ne joue pas, elle prend ce qu'elle veut quand elle a décidé de vivre, puis se montre d'une douceur inattendue. Scènes clés : le bureau de commandement après le J24 (P3), le toit de la caserne (P2).

---

### 12.5 LONG XIAOYU (龙小雨) — « La Pluie du Dragon »
- **Âge / taille** : 31 ans / 1m70. **Origine** : chinoise, née à Shanghai, à Séoul depuis ses 16 ans.
- **Rôle** : héritière et dirigeante de fait du **Consortium Longwei**, Seigneur des Ponts du Han. Son père, le Vieux Long, est mourant.
- **Archétype** : reine de la pègre, femme fatale, joueuse.
- **Charadesign** :
  - cheveux noirs coupés en **carré net**, une frange droite et une mèche teinte en **rouge** ;
  - yeux de chat, un grain de beauté sous l'œil gauche, lèvres carmin ;
  - silhouette élancée ;
  - grand **tatouage de dragon** de l'épaule à la hanche (dos), visible dans ses tenues dos nu.
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
- **Recrutement** :
  - *Mercenaire* : la voie royale, par des contrats successifs. Trois contrats honorés donnent une alliée ;
  - *Tyran* : la vaincre **à son propre jeu** (pari, duel, OPA sur les ponts). Elle respecte la force et devient une partenaire de pouvoir ;
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
  - **Masque** : par défaut, elle en porte toujours un à moitié. Sous la Peur, elle sourit et prépare la vente de sa tête.
- **Combat** : *Éventail de Jade*, au milieu.
  - *Mille Aiguilles* : poisons cumulatifs ;
  - *Pas du Dragon* : esquive, et échange de place avec un ennemi ;
  - *Pari* : 50 % de chances de doubler son tour, sinon de le perdre ;
  - **Ultime** : *Pluie du Dragon Noir*, qui fait exploser tous les poisons actifs.
- **Notes 18+** : séductrice qui mène le jeu… jusqu'à ce qu'on la batte, ce qui révèle sa part de Dévotion. Joue avec les règles et les rôles. Scènes clés : la suite de la barge-casino (P3), la partie de mahjong « strip » (P2, humoristique).

---

### 12.6 AOI TSUKISHIRO (月代葵) — « L'Idol des Ruines »
- **Âge / taille** : 22 ans / 1m60. **Origine** : japonaise, née à Osaka. Stagiaire, puis débutante, dans l'agence K-pop de Mirae Dynamics depuis ses 18 ans.
- **Rôle** : idol bloquée à Hongdae, éveillée en classe ***Diva*** (chant amplifié par le Système). Mirae l'utilise comme « voix de l'espoir » pour **calmer et contrôler les foules**.
- **Archétype** : idol brisée, rayon de soleil de façade, dépression cachée.
- **Charadesign** :
  - cheveux **bicolores**, noir dessus et rose pastel dessous, en twin-tails basses ou détachés ;
  - grands yeux noisette, maquillage de scène qui coule après le J1 ;
  - silhouette fine et tonique de danseuse ;
  - **pansements** aux doigts (cicatrices de répétitions, et d'automutilation passée, abordées avec soin narratif).
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
- **Recrutement** :
  - *Héros* : la sauver au J9, puis l'aider à rompre son contrat ;
  - *Loup* : l'enlever discrètement à Mirae, dans un arc « cavale » romantique ;
  - *Mercenaire* : la « racheter » à Mirae. Elle vous suit, mais se sent possédée (Affinité lente) ;
  - *Tyran* : l'utiliser comme voix de propagande, ce qui donne un **Masque** et une dépression aggravée.
- **Trahison** :
  - **seuil** : Loyauté < 35 ;
  - **déclencheur absolu** : Elias la force à chanter pour contrôler des gens ;
  - **forme** : on la fait chanter (chantage de Mirae sur sa famille à Osaka, via le canal militaire) : elle livre la position du Refuge à Mirae, puis s'effondre de remords ;
  - **signes** : elle chante faux, sort la nuit, reçoit des « messages » qu'elle cache.
- **Dynamiques** :
  - **Serment** : ✓, la route de la « chanson pour une seule personne », sa libération ;
  - **Cour ouverte** : ✓, elle apprécie la « famille » et adore Maricel et Seo-Yeon. Cohésion facile ;
  - **Dévotion** : ✗ — **verrou narratif volontaire**. Elle a été contrôlée toute sa vie : sa bonne route consiste à **reconquérir son autonomie**. L'arc *« Je choisis »* est central ;
  - **Masque** : elle a l'expérience des Masques (le métier d'idol), et le sien est quasi parfait. Sous la Peur, elle s'éteint.
- **Combat** : *Diva*, en arrière.
  - *Encore !* : buff d'attaque de groupe ;
  - *Ballade* : soin sur la durée ;
  - *Fausse Note* : charme un ennemi, qui attaque ses alliés pendant 1 tour ;
  - **Ultime** : *Dernier Rappel*, la scène s'illumine, tous les alliés rejouent et les ennemis sont étourdis ;
  - **Synergie Aoi + Héritière** : *Hymne du Seuil*.
- **Notes 18+** : affectueuse, curieuse, joueuse. Découvre ce qu'elle veut *elle* ; le consentement est un thème explicite de sa route. Scènes clés : le studio d'enregistrement abandonné (P2), la nuit après la rupture de contrat (P3).

---

### 12.7 NADIA TSOI (Надя Цой / 최나디아) — « Le Reflet Blanc »
- **Âge / taille** : 34 ans / 1m76. **Origine** : **Koryo-saram**, une Coréenne d'Asie centrale née à Almaty (Kazakhstan). Ancienne tireuse d'élite de l'armée kazakhe, puis mercenaire internationale.
- **Rôle** : contractuelle de **Cheonma** (Exécutrice n°3), basée à Gangnam. Elle travaille pour qui paie. C'est la tireuse qui a tué Elias dans sa première vie.
- **Archétype** : sniper mercenaire, louve solitaire, cynique au cœur gelé.
- **Charadesign** :
  - cheveux **blanc platine** courts, undercut et mèche longue sur l'œil droit (le « reflet blanc » du Souvenir n°5) ;
  - yeux **gris pâle**, presque translucides ;
  - pommettes hautes, traits mêlant l'Asie centrale et la Corée ;
  - grande, sèche, nerveuse ;
  - une cigarette éteinte en permanence au coin des lèvres (elle a arrêté, en théorie).
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
- **Recrutement** :
  - *Loup* : la voie royale. Elle reconnaît un semblable : survivre ensemble lors d'une nuit de Marée (2 personnes contre la nuée) ;
  - *Mercenaire* : la payer plus cher que Cheonma ;
  - *Tyran* : l'acheter, puis la garder par la force. Masque, et elle tirera au pire moment ;
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
  - **Masque** : sous la Peur, elle attend son heure. C'est la trahison la plus létale.
- **Combat** : *Fantôme de Steppe*, en arrière.
  - *Tir d'élite* : ignore la ligne avant et frappe n'importe quelle case ;
  - *Marquage* : tous les alliés font +30 % de dégâts à la cible ;
  - *Repositionnement* : invisible pendant 1 tour ;
  - **Ultime** : *Balle de 23h58*, élimination instantanée d'un ennemi non-boss, ou 60 % des PV d'un boss.
- **Notes 18+** : brusque, intense, peu de mots ; la vulnérabilité post-intimité est le vrai enjeu. Elle ne reste jamais jusqu'au matin… jusqu'au jour où elle reste. Scènes clés : le toit de sa planque sous la neige de cendres (P3), « le matin où elle est restée » (P2).

---

### 12.8 MARICEL « CEL » DIZON — « La Reine des Rats »
- **Âge / taille** : 26 ans / 1m57. **Origine** : philippine, née à Cebu. Arrivée à Séoul à 20 ans comme employée de maison, elle a fui un employeur abusif et vit depuis dans l'économie informelle.
- **Rôle** : cheffe des équipes de récupération des **Rats du Han**. Elle gère le **Marché Souterrain** de Myeongdong. Héritière désignée de « Grand-père Pigeon », elle connaît **chaque tunnel** de la ville.
- **Archétype** : voleuse solaire, débrouillarde, cœur sur la main et doigts dans votre poche.
- **Charadesign** :
  - peau dorée, cheveux noirs ondulés mi-longs avec des mèches **décolorées cuivre**, sous une casquette retournée ;
  - grands yeux rieurs, fossettes, grain de beauté au-dessus de la lèvre ;
  - petite et vive ; un **tatouage de soleil** philippin sur l'épaule.
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
- **Recrutement** :
  - *Loup / Mercenaire* : la voie naturelle. Échanges, vols en duo, paris ;
  - *Héros* : protéger les Rats et les tunnels ;
  - *Tyran* : prendre le contrôle du Marché Souterrain, ce qui donne un **Masque**. Elle vole Elias jusqu'à l'os puis disparaît dans les tunnels.
- **Trahison** :
  - **seuil** : Loyauté < 35 ;
  - **déclencheur absolu** : Elias menace ou sacrifie ses Rats ;
  - **forme** : elle **vend des informations** sur Elias au plus offrant pour protéger sa famille (« Désolée, beau gosse. Ce n'est pas personnel ») ;
  - **signes** : elle fait des blagues forcées, des objets d'Elias disparaissent (encore plus que d'habitude), ses Rats l'évitent.
- **Dynamiques** :
  - **Serment** : ✓, la route du « soleil sous la ville », elle lui montre le ciel des toits ;
  - **Cour ouverte** : ✓✓, très ouverte et rassembleuse : bonus de Cohésion +10 quand elle est liée. Meilleure amie d'Aoi, complice de Xiaoyu ;
  - **Dévotion** : ✗ (la liberté est sa valeur cardinale) ;
  - **Masque** : elle ne fait pas semblant longtemps, elle vole et fuit.
- **Combat** : *Voleuse des Profondeurs*, à l'avant ou au milieu, mobile.
  - *Vol à la tire* : vole un objet ou un buff ennemi ;
  - *Grappin* : tire un ennemi de l'arrière vers l'avant ;
  - *Piège à rats* : immobilise une case ;
  - *Échange* : permute deux alliés gratuitement ;
  - **Ultime** : *Jackpot*, vol de masse de tous les buffs ennemis, redistribués aux alliés.
- **Notes 18+** : rieuse, spontanée, sans complexe. La légèreté cache une vraie peur de l'abandon. Scènes clés : les toits de Myeongdong la nuit (P2), sa cachette secrète au-dessus du Marché (P3).

---

### 12.9 DR. TRAN MINH-ANH (쩐민안) — « L'Œil de Mirae »
- **Âge / taille** : 36 ans / 1m66. **Origine** : vietnamo-coréenne. Père coréen, mère vietnamienne, issue d'une famille multiculturelle de Busan.
- **Rôle** : **directrice scientifique de Mirae Dynamics** (laboratoire Sous-niveau 9). Spécialiste de l'interface neuronale, devenue la meilleure analyste mondiale du Système. Elle a travaillé chez Haesong Bio (Projet ARCHE) jusqu'à il y a 18 mois.
- **Archétype** : scientifique froide, génie obsessionnelle, éthique ambiguë.
- **Charadesign** :
  - très longs cheveux noirs en **tresse unique** qui descend jusqu'aux reins ;
  - lunettes rectangulaires fines, des **implants cybernétiques** discrets à la tempe droite (des ports et des LEDs bleues) ;
  - yeux sombres, toujours un peu dans le vague (elle calcule) ;
  - silhouette élancée, cernes ; manucure noire écaillée.
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
- **Recrutement** :
  - *Mercenaire* : un échange de données (des Souvenirs contre son aide technique) ;
  - *Héros* : l'arracher à Mirae et la confronter à l'éthique (une route proche de la rédemption) ;
  - *Tyran* : la financer, la protéger et lui donner des « sujets ». Pacte faustien, et elle peut même apprécier ;
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
  - **Masque** : sous la Peur, elle coopère parfaitement en accumulant des données pour le moment opportun.
- **Combat** : *Technomancienne*, en arrière.
  - *Scan* : révèle les faiblesses et les intentions de toute la grille (s'additionne au Pressentiment) ;
  - *Drone-Bouclier* ;
  - *Surcharge* : fait exploser un drone, avec des dégâts de zone ;
  - *Patch* : retire les malus ;
  - **Ultime** : *Algorithme d'Inversion*, qui inverse les PV de deux cibles, une fois par combat.
- **Notes 18+** : curieuse, méthodique, étonnamment audacieuse. Elle aborde l'intimité comme une expérience, et découvre qu'elle ne contrôle rien. Scènes clés : le labo la nuit, au milieu des serveurs (P3), « Protocole d'observation n°1 » (P2, humoristique).

---

### 12.10 L'HÉRITIÈRE — « HANEUL » (하늘, « le Ciel »)
- **Âge** : **apparence d'une femme d'environ 25 ans, adulte**. Son âge réel est inconnu (lore : elle existe depuis l'apparition de la Tour il y a 400 ans, et peut-être avant). **Taille** : 1m69.
- **Origine** : inconnue. C'est une entité née de la Tour (ou prisonnière de celle-ci), à forme humaine. Elias la nomme « Haneul » parce qu'elle regarde toujours le ciel.
- **Rôle** : endormie à l'**étage 1**, derrière la porte sans serrure (et, en vérité, ancrée dans **La Racine** sous Yongsan). C'est la **clé de la Descente** et l'héroïne-pivot du jeu.
- **Archétype** : mystérieuse amnésique, clé du destin. Pour Elias, l'amour d'une autre vie.
- **Charadesign** :
  - longs cheveux **blanc argenté** qui s'assombrissent à mesure que sa mémoire revient (jusqu'au noir, en fin de route) ;
  - yeux **dorés**, avec le même anneau d'horloge que le Registre activé d'Elias ;
  - teint diaphane, des **glyphes** lumineux qui apparaissent sur sa peau quand elle utilise ses pouvoirs ;
  - silhouette adulte et élancée, gestes lents, comme si elle réapprenait la gravité.
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
- **Recrutement** :
  - *Toutes voies* : la trouver à l'étage 1 (Souvenir n°4, dès le J5) ou la reprendre aux Élus (après le J20) ;
  - *Tyran* : il peut l'**utiliser comme arme** (ses pouvoirs alimentent un Sceau), sous Masque, ce qui donne la fin « Roi et Reine des Ruines », sombre ;
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
  - **Masque** : possible seulement par l'usage forcé de ses pouvoirs (Tyran). Ce n'est pas un vrai Masque, c'est un **effacement** : elle se vide de sa personnalité.
- **Combat** : *Clé du Seuil*, flexible.
  - *Repli spatial* : téléporte un allié ou un ennemi sur n'importe quelle case ;
  - *Arrêt du temps* : un ennemi saute son tour ;
  - *Écho* : copie la dernière compétence utilisée ;
  - **Ultime** : *Page Blanche*, qui annule le dernier tour ennemi en entier ;
  - **Synergie avec Elias** : *Réécriture Partagée*, une charge de Réécriture gratuite.
- **Notes 18+** : découverte, tendresse, émerveillement. Les scènes les plus « romantiques » au sens pur ; l'intimité est liée à la mémoire (chaque scène restaure un fragment de souvenir). Scènes clés : le toit sous la pluie (P2), la nuit avant le J30 (P3).

---

## 13. Matrice de cohésion & Fins liées

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

---

## 14. Fins du jeu

| Catégorie | Fins |
|---|---|
| **Fins de voie** (×4, chacune avec des variantes selon P × IR) | *Le Refuge-Nation* (Héros) · *L'Empire des Ruines* (Tyran) · *L'Ombre au Sommet* (Loup) · *Le Roi des Contrats* (Mercenaire) |
| **Fins d'héroïne** (×10) | Une par Serment accompli : *La Main qui ne tremble pas*, *La Présidente sans Sceau*, *Le Lotus et le Tigre*, *Désobéissance*, *Le Pari du Dragon*, *Chanson pour une seule personne*, *Deux Loups*, *Le Soleil sous la Ville*, *L'Équation*, *Le Ciel* |
| **Fins de Cour** (×2) | *La Maison* (Cour ouverte, Cohésion ≥ 70 et au moins 4 héroïnes) · *Le Roi et la Reine des Ruines* (Tyran + Dévotion de Xiaoyu ou Ryeon, ou Haneul sous effacement, sombre) |
| **Fins tragiques** | *Effacement* (P > 85) · *Couteau dans le dos* (trahison fatale) · *La Bête de la Tour* (Corruption 100) · *L'Administratrice* (Haneul corrompue) · *La Clé vendue* |
| **Fin vraie** | *Aube Nouvelle — La Dernière Page* : la Tour refermée, Haneul libre et humaine, le Registre détruit. Il faut une boucle ≥ 4, le Lien d'âme, P ≤ 30, IR > 65 et au moins 6 Fins d'héroïnes réécrites dans la même boucle |

---

## 15. Architecture technique

### 15.1 Moteur recommandé : **Godot 4.x** (dernière version stable, 4.4 ou plus)
| Critère | Pourquoi Godot |
|---|---|
| **Licence** | MIT : aucune redevance, aucun écran de démarrage imposé, et aucune politique de contenu du moteur ne restreint le contenu adulte |
| **2D / 2.5D** | Pipeline 2D natif excellent (parallaxe, shaders, Tweens, UI) : idéal pour les dioramas, la carte, l'UI webtoon et le combat sur grille |
| **Multiplateforme** | Export Windows, macOS, Linux, Android et iOS depuis le même projet. Petits binaires (environ 40 à 80 Mo plus les assets) |
| **Packs de ressources** | Les fichiers `.pck` se chargent à l'exécution (`ProjectSettings.load_resource_pack`), ce qui est la clé de la gestion du contenu 18+ (§15.4) |
| **Langage** | **GDScript**, recommandé plutôt que C#. Le support C# sur iOS reste moins mûr dans Godot 4 : GDScript garantit des exports mobiles sans friction |
| **Alternatives écartées** | *Unity* : coût et historique de licence, poids. *Ren'Py* : excellent pour le visual novel, faible pour le combat tactique, et l'export iOS n'est pas natif. *Unreal* : surdimensionné pour du 2.5D illustré |

### 15.2 Structure du projet
```
manhwa-rpg/
├── project.godot
├── addons/
│   ├── dialogic/              # Narration (Dialogic 2) — ou moteur maison, cf. 15.3
│   ├── godotsteam/            # Steamworks (DLC, succès, cloud) — build PC Steam uniquement
│   └── live2d_or_spine/       # Animation des portraits (à valider au prototype)
├── core/                      # Autoloads (singletons)
│   ├── game_state.gd          # État global de la boucle en cours
│   ├── time_manager.gd        # Jours, phases, Fatigue, Ancres
│   ├── loop_manager.gd        # Régression, Échos, Souvenirs, Ancrages, Dette
│   ├── registre.gd            # Fins, Lecture, Pressentiment, Réécriture
│   ├── tower_pressure.gd      # Pression P, IR, résolution J30
│   ├── alignment.gd           # Axes, réputations locales, témoins, rumeurs
│   ├── relations.gd           # Jauges des héroïnes, dynamiques, Cohésion, trahisons
│   ├── content_manager.gd     # Paliers de contenu, chargement des packs, age gate
│   ├── save_manager.gd        # RunSave + MetaSave, cloud
│   └── platform.gd            # Abstraction Steam / Itch / iOS / Android
├── data/                      # 100 % data-driven (éditable par les game designers)
│   ├── characters/            # elias.json, seo_yeon.json, ... (cf. 15.5)
│   ├── sectors/               # yongsan.json (nœuds, chemins, variantes)
│   ├── clans/                 # cheonma.json, ...
│   ├── anchors/               # calendrier des 30 jours
│   ├── fins/                  # Fins du Registre (conditions, causes, réécritures)
│   ├── combat/                # skills/, enemies/, encounters/
│   └── localization/          # fr.csv, en.csv, ko.csv
├── narrative/                 # Timelines de dialogue (Dialogic ou format maison)
│   ├── main/  heroines/  sectors/  tower/
├── scenes/
│   ├── world_map/  sector_map/  diorama/  webtoon_reader/
│   ├── combat/  refuge/  registre_ui/  menus/
├── assets_base/               # Assets Standard (tous publics) → base.pck
├── content_mature/            # Assets Mature (PC) → mature.pck
├── content_adult/             # Assets Adulte (explicite) → adult.pck  ⚠ jamais dans les builds mobiles store
└── tools/
    ├── export_presets.cfg
    ├── ci/                    # Scripts de build et vérification de contenu
    └── data_import/           # Import tableurs → JSON
```

### 15.3 Briques clés
- **Narration** : **Dialogic 2** (GDScript, multiplateforme, conditions et variables) pour le prototype.
  - Toute la logique d'état reste dans `GameState`. Dialogic n'est qu'un lecteur.
  - Si la complexité d'embranchement explose, migrer vers un **format maison en JSON** ou vers **Ink** (via un portage GDScript), à évaluer au prototype.
  - Chaque nœud narratif porte des tags : `rating` (standard / mature / adult), `heroine`, `requires`, `effects`.
- **Lecteur webtoon** : une scène `ScrollContainer` verticale avec des cases (images + bulles en texte localisable), des effets (tremblement, SFX dessinés) et des déclencheurs de choix inline.
- **Diorama 2.5D** : des nœuds `Parallax2D` et `Camera2D` avec des Tweens, des hotspots en `Area2D` ou boutons, et des variantes de calques activées par l'état du monde.
- **Combat** : une scène indépendante pilotée par les données. Les compétences sont des `Resource` ; l'IA déclare ses intentions avant le tour (indispensable pour le Pressentiment) ; la frise CTB est un tri sur une valeur de délai ; les cut-ins sont des scènes d'animation.
- **Animation des personnages** :
  - **Live2D** (via l'extension communautaire GDCubism) pour des portraits « vivants » façon visual novel ;
  - ou **Spine** (runtime officiel spine-godot) pour les cut-ins et le combat.
  - ⚠ **À valider au prototype** : le support iOS et Android de l'extension choisie, ainsi que le coût de licence (Live2D et Spine sont payants au-delà de certains seuils).
- **Sauvegardes** :
  - **MetaSave** : persistant entre boucles (Souvenirs, Échos, Ancrages, Codex, Dette, paliers de contenu débloqués) ;
  - **RunSave** : boucle en cours, avec 3 emplacements et une sauvegarde automatique à chaque phase ;
  - format JSON versionné dans `user://`, avec une signature (somme de contrôle) contre la corruption ;
  - cloud : Steam Cloud, iCloud et Google Play Games Saved Games, via des plugins.
  - **Les sauvegardes ne contiennent que des drapeaux, jamais d'assets**, pour rester compatibles entre plateformes et paliers.
- **Localisation** : français (langue source), anglais, coréen. `TranslationServer` avec CSV ou PO. Les polices doivent couvrir le hangeul, le japonais et le chinois (Noto CJK en sous-ensemble).

### 15.4 Gestion du contenu 18+ : les paliers de contenu
**Trois paliers, définis dans les données et non dans le code :**

| Palier | Contenu | Où |
|---|---|---|
| **Standard** | Romance, baisers, fan-service suggestif sans nudité explicite, fondu au noir sur les scènes P2 et P3 | Partout, y compris l'App Store et le Play Store |
| **Mature** | Nudité artistique non explicite, scènes P2 complètes, violence graphique | PC (Steam base, Itch), Android hors Play Store |
| **Adulte** | Scènes P3 explicites, profils 18+ des personnages (§10.7) | PC uniquement via un pack séparé, et Android en distribution directe (APK) |

**Principe de séparation physique** :
1. Chaque scène ou image sensible est déclarée avec ses **variantes** : `scene_id` → `{ standard: …, mature: …, adult: … }`. Le `ContentManager` choisit la variante la plus élevée **autorisée et disponible**, sinon il se replie sur le palier inférieur (fondu au noir, plan alternatif).
2. **Les assets Mature et Adulte vivent dans des packs séparés** : `mature.pck` et `adult.pck`. Ils ne font **jamais** partie du binaire principal.
3. **Exports mobiles « store »** : les presets d'export excluent `content_mature/**` et `content_adult/**` (filtres d'exclusion). Le code vérifie aussi `OS.has_feature("ios")` et une feature tag `store_build` : **aucun chargement de pack n'est possible**, même si un fichier était injecté.
4. **Garde-fou en intégration continue** : après chaque export mobile, un script liste le contenu du `.pck` et **fait échouer le build** si un chemin `content_adult/` ou `content_mature/` est présent, ou si un tag `rating: adult` apparaît dans les données embarquées. Apple et Google peuvent analyser les binaires : il ne doit littéralement rien y avoir.
5. **Steam** :
   - le jeu de base contient les paliers Standard et Mature, avec un questionnaire de contenu mature rempli honnêtement ;
   - le palier Adulte est un **DLC gratuit « Adult Content Pack »** marqué « Adult Only Sexual Content » ;
   - détection via GodotSteam (`isDLCInstalled`), et le pack est chargé au démarrage.
6. **Itch.io** : un build complet avec le pack Adulte, page marquée NSFW et accès aux adultes uniquement.
7. **Android hors store** : un APK complet en distribution directe (site officiel, Itch.io), avec age gate. Android autorise l'installation de sources inconnues, et c'est à l'utilisateur de l'activer.
8. **iOS** :
   - **uniquement le palier Standard**. Les règles de l'App Store interdisent le contenu sexuel explicite, et il est interdit de débloquer après installation du contenu qui violerait ces règles ;
   - les marketplaces alternatives de l'UE (DMA) restent soumises à la notarisation d'Apple : **à vérifier juridiquement** avant d'envisager une version Mature sur iOS.
9. **Age gate** : au premier lancement d'un build contenant du Mature ou de l'Adulte, une confirmation d'âge et un choix de palier (modifiable dans les options, protégeable par code). En distribution directe, prévoir une **vérification d'âge renforcée** selon les juridictions (Royaume-Uni avec l'Online Safety Act, plusieurs États américains, Allemagne).
10. **Cross-save** : une sauvegarde issue d'un PC Adulte se charge sur mobile Standard. Les scènes vues sont marquées par leur `scene_id`, et l'affichage se replie automatiquement.

**Points de vigilance commerciaux et juridiques (à revérifier avant le lancement) :**
- **Processeurs de paiement** : en 2025, Steam a durci ses règles sur le contenu adulte sous la pression des processeurs de paiement, et Itch.io a désindexé puis partiellement restauré le contenu NSFW. Il faut suivre ces politiques et prévoir un plan B de distribution, par exemple un site propre avec un processeur compatible adulte.
- **Corée du Sud** : la classification du GRAC est stricte sur le contenu sexuel. La version adulte peut être refusée ou filtrée sur le marché coréen, où se déroule pourtant l'histoire. Prévoir une version Standard ou Mature pour la Corée.
- **Allemagne** (USK / JMStV), **Australie** (Classification Board) : risques de refus de classification pour le contenu explicite. Le géoblocage du DLC Adulte est possible sur Steam.
- **Direction artistique conforme** : des proportions adultes pour toutes les héroïnes, aucun uniforme scolaire, les âges inscrits dans les données et affichés dans les fiches. Ce sont des critères examinés par Steam et par de nombreux régulateurs.

### 15.5 Schéma de données d'un personnage (extrait)
```jsonc
// data/characters/seo_yeon.json
{
  "id": "seo_yeon",
  "name": { "fr": "Park Seo-Yeon", "ko": "박서연", "en": "Park Seo-yeon" },
  "age": 27,                        // OBLIGATOIRE, validé ≥ 18 par l'outil d'import
  "height_cm": 163,
  "origin": "KR",
  "sector": "yeouido",
  "affiliation": ["camp_yeouido", "sanctuaire"],
  "archetype": "healer_idealist",
  "axes": { "protect_dominate": -70, "bond_solitude": 60 },
  "gauges_start": { "affinity": 10, "trust": 10, "fear": 0, "ambition": 0 },
  "traits": ["accepts_sharing_high_cohesion", "no_devotion"],
  "betrayal": {
    "threshold": 30,
    "absolute_triggers": ["kill_civilians_witnessed", "sold_to_clan"],
    "form": "poison_and_flee",
    "omens": ["avoids_gaze", "med_supplies_missing", "whispers_agatha"]
  },
  "fin": {
    "id": "fin_seo_yeon_01",
    "day": 12, "phase": "dusk", "node": "yeouido.hospital",
    "cause_known_levels": ["date_place", "bitten_protecting_children", "camp_rationing", "serum_h07"],
    "rewrite_conditions": { "all": ["camp_secured", "has_item:serum_h07"] },
    "next_fin": "fin_seo_yeon_02"
  },
  "linked_fins": [{ "with": "hae_in", "rule": "steal_serum_advances_coup_to_d18" }],
  "dynamics": { "oath": true, "open_court": "cohesion>=70", "devotion": false, "mask": "sabotage" },
  "combat": { "class": "field_surgeon", "row": "back", "skills": ["triage", "adrenaline", "code_blue"] },
  "outfits": { "base": "...", "combat": "...", "casual": "..." },
  "intimacy": {
    "rating_gate": "adult",          // ce bloc n'est chargé que si le palier Adulte est actif
    "temperament": "shy_opens_with_trust",
    "scenes": [
      { "id": "seo_p2_restroom", "tier": "P2", "requires": { "affinity": 70, "trust": 60 } },
      { "id": "seo_p3_bunker",   "tier": "P3", "requires": { "affinity": 85, "trust": 75 }, "consent_check": true }
    ]
  }
}
```
- **Validation à l'import (outil `tools/data_import`)** :
  - `age ≥ 18` obligatoire pour tout personnage qui a un bloc `intimacy` ;
  - toute scène P2 ou P3 doit avoir un `consent_check` et des `requires` incluant la Confiance ;
  - aucune scène intime ne peut être déclenchée si `dynamic == "mask"`.

### 15.6 Budgets de performance
| | PC | Mobile |
|---|---|---|
| Résolution de référence | 1920×1080 (UI adaptative jusqu'en 4K) | 1080×2400 (portrait pour le webtoon, paysage pour la carte et le combat) |
| Textures de diorama | 4096 px max | 2048 px max, compression ASTC (iOS) / ETC2 (Android) |
| Mémoire cible | < 2 Go | < 900 Mo (appareils milieu de gamme 2022+) |
| Taille de l'installation | 3 à 5 Go (avec voix éventuelles) | < 1,5 Go initial, le reste en téléchargement d'assets par secteur |

### 15.7 Intégration continue et builds
- **GitHub Actions** avec une image Docker Godot headless (de type `godot-ci`) : exports Windows, Linux, macOS et Android à chaque tag.
- **iOS** : un runner macOS avec Xcode, et la signature via les secrets du dépôt.
- **Étapes** :
  1. validation des données (âges, conditions, références croisées des Fins) ;
  2. tests unitaires de la logique (Pression, Loyauté, régression) avec GUT ou gdUnit4 ;
  3. export ;
  4. **audit de contenu des packs mobiles**, bloquant ;
  5. envoi sur Steam (`steamcmd`), Itch (`butler`), TestFlight et Play Console (piste interne).

---

## 16. Périmètre de la démo

| Élément | Contenu de la démo |
|---|---|
| Durée de jeu | 2 à 3 heures (première boucle courte) |
| Temps | **J1 à J7** (Acte I complet), avec **1 régression scénarisée** au J7 (mort contre le Portier) pour enseigner la boucle |
| Carte | **Yongsan** (réveil, Porte) + **Yeouido** (camp, IFC, hôpital) + l'**étage 1** de la Tour. Les autres secteurs sont visibles mais verrouillés |
| Héroïnes | **Seo-Yeon** (route jusqu'au palier « Proche »), **Haneul** (rencontre via le Souvenir n°4), **Hae-in** (rencontre et premier contrat). **Nadia** en teaser (le reflet blanc) |
| Voies | Héros et Mercenaire complètes sur l'Acte I ; Tyran jusqu'au camp vassal (Masque de Seo-Yeon) ; Loup partielle |
| Combat | 5 types d'ennemis, 1 boss à Règle (le Portier aux Mille Clés), grille 3×3 complète, Pressentiment et Réécriture (après la régression) |
| Ratio | Environ 60 % de narration et d'exploration, 40 % de combat, mesuré par la télémétrie |
| Contenu | Standard sur toutes les plateformes. Une scène P2 en palier Mature/Adulte pour tester le pipeline de packs |
| Objectif technique | Valider la chaîne complète : données → narration → carte → combat → régression → sauvegarde → export des 4 plateformes avec l'audit de contenu |

---

## 17. Questions ouvertes

1. **Voix** : doublage partiel (coréen ou japonais pour l'authenticité manhwa, ou anglais), uniquement des « barks » de combat, ou pas de voix ?
2. **Modèle économique** : premium (achat unique sur PC, démo gratuite) ou épisodique (par Acte) ? Sur mobile : premium, ou free-to-start avec achat de déblocage complet ?
3. **Animation des portraits** : Live2D (portraits très vivants, coût plus élevé) ou illustrations statiques avec variantes d'expression et effets de shader (plus économique) ?
4. **Ton de la version Standard** : le fondu au noir doit-il rester très suggestif, ou être pleinement « tous publics 12+ » pour viser un public plus large sur mobile ?
5. **Antagoniste principal** : le Prophète des Élus doit-il être un personnage déjà connu (twist : Mère Agatha ? le PDG Jang ? Cheon Tae-ju ?) ou une figure nouvelle ?
