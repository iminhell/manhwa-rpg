# Game Design Document — v0.1 (Concept)

> RPG narratif et tactique inspiré des manhwas/webtoons, à haute liberté de choix.
> Statut : document de concept, avant prototype. Toutes les valeurs chiffrées sont des points de départ à équilibrer.

---

## 1. Trois concepts d'univers

### Concept A — « LA TOUR DU DERNIER JOUR » (Apocalypse + Système/Tour + Régression)

- **Pitch** : Une tour noire perce le ciel de Séoul. Un « Système » s'impose à l'humanité : grimper ou mourir. Chaque nuit, des monstres descendent des étages. Le joueur est un **Régresseur** : il est déjà mort au 30e jour et s'est réveillé au jour 1 avec un fragment du futur, le **Registre des Fins**, qui lui montre comment chaque PNJ important va mourir.
- **Ce que ça permet** : les 4 voies tiennent naturellement. Bâtir un refuge (Héros), tenir un secteur par la force (Tyran), grimper seul en furtivité (Loup), vendre ses connaissances du futur au plus offrant (Mercenaire/Voleur).
- **Atouts** : mélange Système/Tour, survie, action shonen et thriller. La régression reprend directement le moteur de *Raising the Princess After Her Death* : connaître un destin et le réécrire.
- **Risque** : genre très fréquenté (*Solo Leveling*, *Omniscient Reader*, *Return of the Disaster-Class Hero*). Il faut une identité forte, qui viendra du Registre et des Règles d'étage.

### Concept B — « NEO-HANSEONG 2099 » (Cyber-thriller de factions)

- **Pitch** : Une mégapole verticale gouvernée par 5 conglomérats-clans (chaebols cybernétiques). Le joueur est un **Fantôme**, un agent effacé des registres, porteur d'un implant prédictif illégal (**Oracle**) qui calcule les probabilités de mort et de trahison autour de lui.
- **Ce que ça permet** : guerre de factions, infiltration, chantage. Les voies deviennent Justicier, Parrain, Fantôme et Fixer (mercenaire).
- **Atouts** : thriller, intrigues de cour corporatistes, romances à double jeu (espionnes, héritières).
- **Risque** : moins d'exploration « aventure » et de combat shonen spectaculaire. L'esthétique cyberpunk est déjà très vue en Occident.

### Concept C — « LE TRÔNE DES CENDRES » (Dark Fantasy / Régence nécromantique)

- **Pitch** : Un empire est tombé en une nuit. Le joueur, un mage maudit, ressuscite la dernière princesse : elle n'a que 100 jours de « vie empruntée ». Il doit choisir : restaurer l'empire, s'en emparer, fuir avec elle, ou la vendre aux royaumes vainqueurs.
- **Ce que ça permet** : relations très fortes et compte à rebours dramatique. C'est le concept le plus proche de *Raising the Princess After Her Death*.
- **Atouts** : romance tragique, cour impériale, monstres de dark fantasy.
- **Risque** : l'histoire tourne autour d'un seul PNJ central, ce qui limite la sandbox et la variété des voies.

### Choix recommandé : **Concept A**, avec deux greffes

C'est le concept qui sert le mieux les 5 piliers :
- La **Tour** donne une carte naturelle à plusieurs couches (ville en ruines ↔ étages).
- L'**apocalypse** rend crédibles les 4 voies morales sans les forcer.
- La **régression + le Registre des Fins** reprennent le cœur de *Raising the Princess* et généralisent la mécanique à tous les PNJ.

Les greffes :
- **Du concept B**, des factions humaines rivales en surface : le thriller vient des humains, pas seulement des monstres.
- **Du concept C**, un « PNJ-pivot » avec un compte à rebours personnel (l'Héritière de la Tour, voir §4.5), pour donner un fil émotionnel fort sans enfermer le joueur.

---

## 2. Univers retenu — LA TOUR DU DERNIER JOUR

### 2.1 Prémisse
- **Jour 0** : la Tour apparaît au-dessus de Yongsan. Le Système attribue à chaque survivant une **Classe** et des **Quêtes**.
- **Jour 30** : la **Grande Descente**. Les 10 premiers étages se déversent sur la ville. Dans la première vie du héros, tout le monde y est mort.
- Le héros se réveille au jour 1 avec :
  - des **souvenirs fragmentaires** (révélés progressivement) ;
  - le **Registre des Fins**, une interface que lui seul voit.

### 2.2 Factions de surface (exemples)
| Faction | Idéologie | Territoire | Ce qu'elle offre / exige |
|---|---|---|---|
| **Le Sanctuaire de Myeongdong** | Protéger les faibles, foi dans le Système | Église et galeries souterraines | Soins, réputation morale. Exige le partage des ressources |
| **La Guilde Cheonma** | La force fait le droit, hiérarchie stricte | Tours de Gangnam | Équipement, esclaves-ouvriers. Exige l'allégeance |
| **Les Rats du Han** | Contrebande, information | Ponts et égouts | Marché noir, rumeurs. Exige des faveurs |
| **L'Unité 0 (militaires)** | Ordre martial, quarantaine | Base de Yongsan | Armes à feu modifiées. Exige l'obéissance, et cache un secret sur la Tour |
| **Les Élus** | Culte qui vénère la Tour | Étages 1 à 3 | Pouvoirs interdits. Exige des sacrifices |

### 2.3 Les « Règles d'étage »
Chaque étage de la Tour a une **Règle** imposée par le Système, qui change la façon de jouer :
- *Étage 2 — « La Cité Silencieuse »* : tout son au-dessus d'un murmure attire le Gardien. Infiltration obligatoire.
- *Étage 4 — « Le Banquet »* : on ne peut pas attaquer un être avec qui l'on a partagé un repas. Diplomatie, empoisonnement, trahison.
- *Étage 7 — « Le Tribunal »* : les crimes commis en surface sont jugés ici. L'alignement du joueur a des conséquences mécaniques directes.

---

## 3. Carte du monde & navigation

Principe : **trois couches emboîtées**. Chaque couche est riche en décisions, aucune n'est un couloir vide.

```
COUCHE 1 — CARTE STRATÉGIQUE (Séoul + Tour)
   │  choix de destination, gestion du temps, contrôle des factions
   ▼
COUCHE 2 — CARTE DE SECTEUR (graphe de Points d'Intérêt)
   │  déplacement nœud à nœud, brouillard, rencontres, nœuds cachés
   ▼
COUCHE 3 — SCÈNE (diorama 2.5D illustré + hotspots)
      dialogues, fouille, combat, scènes clés en « scroll webtoon »
```

### 3.1 Couche 1 — Carte stratégique
- **Visuel** : carte illustrée de Séoul en ruines, vue du dessus, avec la Tour au centre en vue latérale. Cliquer sur la Tour fait pivoter la caméra vers la colonne des étages.
- **7 secteurs de surface** (Gangnam, Myeongdong, Yeouido, Hongdae, les Ponts du Han, Yongsan, les Collines du Nord), plus **les étages** de la Tour, débloqués au fil de l'ascension.
- **Informations affichées** :
  - couleur de la faction qui contrôle le secteur ;
  - niveau de danger (★ à ★★★★★) ;
  - icônes de rumeurs (quêtes, PNJ du Registre en danger, trésors) ;
  - **marqueurs de Fin**, l'innovation clé : une icône de crâne avec un compte à rebours au-dessus du secteur où un PNJ important va mourir.
- **Coût du temps** : se déplacer entre secteurs coûte des **phases de journée**. Une journée = 4 phases (Aube, Jour, Crépuscule, Nuit). La nuit, les monstres descendent : danger ×2, mais certains PNJ et marchés n'existent que la nuit.
- **Le calendrier de 30 jours** est la ressource principale. Le joueur ne peut pas tout faire en une vie : c'est ce qui donne du poids aux choix et de la valeur à la rejouabilité.

### 3.2 Couche 2 — Carte de secteur
- **Graphe de 10 à 18 nœuds** (Points d'Intérêt) reliés par des chemins, sur une illustration du secteur.
- **Types de nœuds** :
  - 🏚️ **Lieu** : bâtiment, ruelle, station de métro, toit.
  - ⚔️ **Menace** : nid de monstres, barrage d'une faction.
  - 💬 **PNJ** : personnage, marchand, camp de survivants.
  - 🔒 **Caché** : n'apparaît qu'avec une compétence (Perception, Crochetage), une réputation, un souvenir du Registre (« Je me souviens qu'il y avait un bunker sous ce parking… ») ou à une certaine phase de la journée.
  - 🏠 **Refuge** : nœud que le joueur peut revendiquer et développer.
- **Déplacement** : passer d'un nœud à l'autre coûte du **Temps local**, une fraction de phase. Les chemins ont des propriétés :
  - *bruyant* : risque de rencontre ;
  - *exposé* : témoins possibles, voir §4.3 ;
  - *bloqué* : il faut le dégager, le contourner ou payer.
- **Brouillard de guerre** : il se dissipe par l'exploration, les éclaireurs (alliés envoyés en mission) ou les informations achetées.
- **État persistant** : les nœuds changent selon les actions du joueur et des factions. Un camp ignoré peut tomber, être absorbé par la Guilde, ou devenir un repaire de pillards.

### 3.3 Couche 3 — Scène
- **Vue** : diorama 2.5D semi-fixe. Une illustration en couches avec parallaxe et un léger mouvement de caméra (pan/zoom), à la manière d'une case de manhwa animée. Pas de déplacement libre : des **hotspots** cliquables (objets, portes, PNJ, indices).
- **Scènes clés en « scroll webtoon »** : pour les moments forts (révélations, combats de boss, romances, morts), l'écran bascule en lecture verticale avec des cases, des bulles et des effets sonores dessinés. C'est la **signature visuelle** du jeu.
- **Actions contextuelles** selon la voie et les compétences : `Fouiller`, `Intimider`, `Voler`, `Soigner`, `Exécuter`, `Recruter`, `Espionner`…

### 3.4 Pourquoi ce système fonctionne
- **Exploration vaste, sans monde 3D vide** : chaque clic mène à une décision ou à un contenu.
- **Production réaliste** : un secteur, c'est 1 illustration de graphe + 10 à 18 dioramas réutilisables avec des variantes (jour/nuit, intact/détruit, contrôle de faction).
- **Contrôle total du rythme narratif** par le temps et les marqueurs de Fin.

---

## 4. Système d'Alignement & Conséquences

### 4.1 Pas une jauge unique : deux axes et une réputation locale

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

- **Axe Protéger ↔ Dominer** (−100 à +100) : comment le joueur traite les plus faibles que lui.
- **Axe Lien ↔ Solitude** (−100 à +100) : à quel point il s'entoure et s'engage.
- **Troisième axe caché, Ordre ↔ Chaos du Destin** : combien de Fins il a réécrites. Plus il en réécrit, plus le futur devient imprévisible : le Registre perd en fiabilité, des événements inédits apparaissent, et le Système finit par le remarquer (arc de fin cachée).

Les voies ne sont pas des classes choisies au départ. Ce sont des **zones émergentes** sur cette carte, et les hybrides sont valides : un « Robin des Bois » est un Loup protecteur, un « Roi-Mercenaire » est un Tyran transactionnel.

### 4.2 Les actes, pas les dialogues
- Les points d'alignement viennent surtout des **actes** : partager ou rançonner des vivres, épargner ou exécuter, recruter ou abandonner. Les simples répliques de dialogue comptent peu.
- Chaque acte a une **intensité** :
  - *mineur* (±2), par exemple prendre la ration d'un inconnu ;
  - *majeur* (±10), par exemple livrer un camp à la Guilde ;
  - *de bascule* (±25, déclenche un événement), par exemple exécuter un ennemi qui s'est rendu devant témoins.

### 4.3 Réputation locale & témoins
- **Pas de karma global omniscient.** Chaque faction et chaque secteur a sa propre **Réputation** (Crainte / Respect / Haine / Inconnu).
- Un acte n'affecte la réputation que s'il y a des **témoins**, ou si la rumeur se propage. Une rumeur se répand de secteur en secteur, un nœud par jour.
- Conséquences pour le gameplay :
  - le **Loup solitaire et le Voleur** jouent sur la discrétion : éliminer les témoins, porter un masque, opérer la nuit ;
  - un joueur peut être **un saint à Myeongdong et un boucher redouté à Gangnam**. C'est volontaire : on peut mener une double vie, au risque d'être démasqué, ce qui déclenche un événement thriller.

### 4.4 Titres du Système (récompenses de voie)
Franchir un seuil fait apparaître une notification du Système et offre un **Titre**. Le joueur peut l'accepter ou le refuser. Chaque Titre débloque des compétences :

| Seuil atteint | Titre proposé | Débloque |
|---|---|---|
| Protéger ≥ 40, Lien ≥ 40 | **Bouclier des Sans-Voix** | Aura de protection, recrutement de civils, Refuge niveau 2 |
| Dominer ≥ 40, Lien ≥ 40 | **Seigneur de Guerre** | Commandement par la peur, impôt sur les secteurs, exécutions spectaculaires (bonus de Peur) |
| Solitude ≥ 50 | **Ombre Sans Nom** | Furtivité avancée, assassinat hors combat, accès à des nœuds cachés |
| Dominer ≥ 20, Solitude ≥ 30 | **Chacal** | Contrats, vol à la tire, revente au marché noir, double jeu entre factions |
| Ordre/Chaos ≤ −60 | **Anomalie** | Compétences de manipulation du temps, mais le Système envoie des Exécuteurs |

### 4.5 Changer de voie : inertie et coût
- **Inertie** : plus on est loin sur un axe, plus il coûte cher d'en revenir. Les points de retour sont divisés par 2 au-delà de ±50.
- **La mémoire des PNJ est permanente** dans une même vie. Un Tyran repenti ne retrouvera jamais la confiance de ceux qu'il a brisés. D'autres PNJ, en revanche, ne s'intéressent à lui que *parce qu'il* a été un monstre (anti-héroïnes, mercenaires).
- **Arcs de bascule** : changer de voie déclenche une quête spécifique.
  - *Rédemption* (Tyran → Héros) : libérer ses propres prisonniers, affronter un ancien lieutenant devenu chef rebelle.
  - *Chute* (Héros → Tyran) : un PNJ protégé meurt par la faute de la faction X, et la vengeance est proposée.
  - *Retrait* (→ Loup) : abandonner le Refuge, avec une scène d'adieu ou une fuite nocturne.
- **Le Refuge reflète la voie** :
  - Héros : **Sanctuaire** (civils, école, infirmerie) ;
  - Tyran : **Forteresse** (prisonniers-ouvriers, arène, trésor) ;
  - Loup : réseau de **planques** dispersées ;
  - Mercenaire : **Comptoir** (marché, informateurs).

### 4.6 Exemple de situation à embranchements
> **Le Camp de Yeouido** (jour 4) : 40 survivants, des vivres pour 3 jours, une nuée de monstres attendue au jour 6 (visible dans le Registre).

| Choix | Effet immédiat | Conséquence à moyen terme |
|---|---|---|
| Les défendre et organiser le camp | Protéger +10, Lien +10, coûte 2 jours | Le camp devient un avant-poste du Refuge. La médecin **Seo-Yeon** devient recrutable |
| Les « protéger » contre un tribut | Dominer +10, Lien +5, ressources +++ | Le camp devient vassal. Seo-Yeon reste par peur (Peur +), une révolte est possible au jour 15 |
| Voler leurs vivres la nuit et partir | Dominer +5, Solitude +10 | Le camp meurt au jour 6, Seo-Yeon disparaît du Registre. Si un témoin survit, la rumeur atteint le Sanctuaire |
| Vendre la position du camp à la Guilde | Dominer +10, Solitude +5, argent +++ | La Guilde vous fait confiance. Seo-Yeon devient esclave de la Guilde et peut être libérée plus tard (sous-route) |
| Les ignorer | Rien | Le Registre affiche la Fin. Elle se produira, et le joueur peut revenir trop tard |

### 4.7 Régression : ce qui persiste et ce qui s'efface
- **Mort, ou fin du jour 30 sans victoire** : retour au jour 1.
- **Ce qui est perdu** : les relations, le Refuge, la réputation, l'inventaire.
- **Ce qui est conservé** :
  - les **Souvenirs** (pages du Registre, codes, emplacements de nœuds cachés) ;
  - une partie des niveaux de Classe (les **Échos**) ;
  - les **Ancrages** : quelques choix majeurs qui marquent le monde de façon permanente, d'une vie à l'autre.
- **Échos des PNJ** : un compagnon très proche dans une vie précédente peut avoir des **déjà-vu** (dialogues spéciaux). Le joueur peut alors raccourcir ou dérailler sa route : « Pourquoi ai-je l'impression de vous avoir déjà fait confiance… et de l'avoir regretté ? »
- **Option de difficulté « Une seule vie »** : pas de régression, chaque mort est une fin, pour les joueurs qui veulent des conséquences absolues.

---

## 5. Moteur de combat

### 5.1 Format : tactique au tour par tour avec mise en scène shonen
- **Terrain** : deux grilles de 3×3 qui se font face. La position compte (avant, milieu, arrière ; couverture ; ligne de vue). Des **éléments de décor interactifs** dépendent de la scène : voitures à faire exploser, plafond à effondrer, civils à protéger.
- **Initiative** : une **frise temporelle** de type CTB (*Conditional Turn-Based*) visible en haut de l'écran. Les actions lourdes retardent le prochain tour de leur auteur.
- **Ressources** :
  - **PV** et **Mana du Système** ;
  - une **Jauge d'Éveil** qui se remplit en subissant des coups et en protégeant des alliés. Pleine, elle déclenche une **Ultime** avec une **cut-in en cases manhwa**.

### 5.2 Le Registre en combat : la prédiction
- **Intentions visibles** : le joueur voit l'action prévue de chaque ennemi au tour suivant, comme dans *Into the Breach*. C'est l'avantage du Régresseur.
- **« Réécriture »** (1 à 3 charges par combat, selon le niveau de Chaos) : annuler un événement qui vient de se produire, par exemple la mort d'un allié ou un coup critique subi, et rejouer le tour. Chaque utilisation fait monter le Chaos du Destin.
- **Boss à Règles** : certains boss ne peuvent être battus qu'en découvrant leur règle cachée, souvent lors d'une vie précédente.

### 5.3 Résolution hors combat
Chaque rencontre propose, selon la voie et les stats :
- **Intimider** : Peur contre Volonté ennemie. L'ennemi fuit ou se rend, ce qui ouvre une décision d'épargner ou d'exécuter.
- **Négocier / Soudoyer** : Charisme ou Argent.
- **Assassiner avant le combat** : furtivité, ce qui supprime aussi les témoins.
- **Fuir** : coûte du temps et parfois un allié qui se sacrifie si sa Loyauté est très haute.

### 5.4 Progression
- **Stats du Système** : FOR, AGI, PER (perception), VOL (volonté), CHA (charisme), plus **Corruption** (cachée, augmentée par les pouvoirs interdits des Élus).
- **Classe de départ** (choix parmi 4) + **Titres de voie** (§4.4) + **compétences de Synergie** avec les compagnons (§6.4).

---

## 6. Compagnons, romance & loyauté

### 6.1 Trois jauges par compagnon au lieu d'une
| Jauge | Augmente par | Effet |
|---|---|---|
| **Affinité** | Cadeaux, temps passé, choix qui correspondent aux valeurs du compagnon | Débloque les scènes personnelles et la romance |
| **Confiance** | Promesses tenues, Fins réécrites pour lui, vérité dite | Stabilise la loyauté, débloque les Synergies avancées |
| **Peur** | Menaces, démonstrations de force, punitions | Obéissance immédiate et forte efficacité à court terme, mais nourrit l'**Ambition cachée** |

**Loyauté effective** = f(Affinité, Confiance, Peur, compatibilité de valeurs). Le joueur ne voit qu'une estimation, sauf s'il investit dans la compétence *Lecture des Cœurs*.

### 6.2 Valeurs et compatibilité
- Chaque compagnon a sa propre **position sur les deux axes**. Une paladine idéaliste est dégoûtée par les exécutions. Une assassine cynique méprise la charité « naïve ».
- Agir contre les valeurs d'un compagnon fait baisser son Affinité. Agir *avec* elles déclenche des **scènes d'approbation**.
- Certains compagnons **évoluent** selon l'influence du joueur : la paladine peut se durcir, l'assassine s'adoucir. Ce sont des sous-routes de personnage.

### 6.3 Trahison
- Chaque compagnon a un **Secret** (allégeance cachée, vengeance, dette) et un **seuil de trahison**.
- **Déclencheurs** : Loyauté sous le seuil à un **moment critique** (boss, siège du Refuge, choix de faction), ou acte du joueur qui touche directement son Secret.
- **Signes avant-coureurs** obligatoires, pour que la trahison soit juste et lisible : dialogues évasifs, absences la nuit, objets disparus. Le Registre peut aussi afficher : *« Mourra de la main de [nom effacé] »*.
- **Réponses possibles** : confronter, pardonner, exécuter, retourner (agent double), ou simplement **laisser faire** pour remonter jusqu'au commanditaire.

### 6.4 Synergies de lien (combat)
- Avec une Confiance ou une Affinité élevée, deux personnages débloquent une **attaque combinée** avec cut-in à deux.
- **Serment** (route exclusive) : la synergie la plus puissante du jeu, en contrepartie de l'exclusivité romantique.
- Une synergie fondée sur la Peur existe aussi (*« Ordre absolu »*). Elle est puissante, mais chaque utilisation augmente l'Ambition cachée.

### 6.5 Romance : routes et structure
- **Tous les personnages romançables sont des adultes**, et leur âge est explicite dans la fiche personnage.
- **Route exclusive (Serment)** : relation unique, scénario plus profond, bonus de Serment, fin dédiée.
- **Route polyamoureuse (Cour ouverte)** : plusieurs relations en parallèle. Il faut gérer la **Cohésion** du groupe : matrice de compatibilité entre compagnons, jalousies, événements de groupe. Bien gérée, elle débloque des scènes collectives et une fin « Maison » ; mal gérée, elle provoque des départs et des rivalités, voire des trahisons.
- **Règle de design : la peur ne remplace jamais le consentement.** Sur la voie du Tyran, le joueur peut constituer une **Cour** de vassaux et de lieutenants soumis par la peur, avec des scènes de pouvoir, d'allégeance et de tension. Mais les scènes romantiques et intimes exigent toujours une Affinité et une Confiance réelles. Un personnage qui « joue le jeu » par peur porte un **Masque** (variable cachée), et c'est lui qui, plus tard, plante le couteau.
  - *Narrativement*, c'est plus fort : le pouvoir absolu isole, ce qui est le thème classique des routes « Tyran » en manhwa.
  - *Commercialement*, c'est nécessaire : Steam, et plus encore les stores mobiles, restreignent fortement les contenus sexuels non consentis.
  - Un Tyran peut quand même être aimé : par une anti-héroïne qui partage sa vision, par un compagnon qu'il a vraiment sauvé, par une rivale qui respecte sa force. C'est même une sous-route riche (« Le Roi et la Reine des Ruines »).
- **Contenu ecchi/fan-service** : il est lié aux paliers de relation et à des événements de détente au Refuge (bains, fêtes, récupération après un combat), avec un **réglage de contenu** (Off / Suggestif / Complet) dans les options.

### 6.6 Le Registre appliqué aux compagnons (mécanique *Raising the Princess*)
Chaque compagnon majeur a une **Fin funeste** inscrite dans le Registre :
> **Seo-Yeon** — *Jour 12, Crépuscule. Hôpital de Yeouido. Mordue en protégeant des enfants. Se transforme.*

- La Fin est révélée **partiellement**, puis complétée au fil des vies ou des indices.
- La **réécrire** demande de comprendre sa *cause profonde*, pas seulement d'être présent : il faut un vaccin de l'étage 3, convaincre les enfants de partir la veille, ou gagner sa confiance pour qu'elle accepte de ne pas y aller.
- Une Fin réécrite déverrouille la **sous-route personnelle** du compagnon et souvent une **nouvelle Fin**, plus lointaine et plus dangereuse. Le destin résiste.
- **PNJ-pivot, « l'Héritière de la Tour »** : une jeune femme adulte, amnésique, retrouvée au 1er étage. Son compte à rebours est caché dès le départ et lié à la Grande Descente. Selon les choix du joueur, elle devient la clé de la fin vraie, une arme du Tyran, une compagne de route du Loup, ou une marchandise du Mercenaire.

---

## 7. Fins (structure)
- **Fins de voie** (4) : le Refuge-Nation, l'Empire des Ruines, l'Ombre au Sommet, le Roi des Contrats.
- **Fins de compagnon** : une par route romantique, plus la fin « Maison » (Cour ouverte réussie).
- **Fins tragiques** : Grande Descente non empêchée, trahison fatale, Corruption totale.
- **Fin vraie** (cachée) : comprendre l'origine de la Tour et du Registre. Elle demande plusieurs vies et un niveau de Chaos du Destin élevé.

---

## 8. Proposition de périmètre pour la démo / le prototype
- **1 secteur** (Yeouido) + **l'étage 1** de la Tour.
- **7 jours de jeu** au lieu de 30, avec **1 régression** scénarisée pour enseigner la mécanique.
- **3 compagnons** couvrant des valeurs opposées : une médecin idéaliste, une mercenaire cynique, un rival ambitieux.
- **2 voies jouables à fond** (Héros et Tyran) ; Loup et Mercenaire en version partielle.
- **4 types de combats** + 1 boss à Règle.
- **3 mini-fins** de démo.

## 9. Questions ouvertes (pour affiner la démo)
1. **Plateforme, moteur et équipe** : PC (Steam) ou mobile ? Unity, Godot, ou un moteur de visual novel étendu (Ren'Py + modules) ? Équipe solo ou plusieurs personnes, et quel budget d'illustration ?
2. **Niveau de contenu adulte** : fan-service suggestif (version tous stores) ou contenu explicite 18+ (patch séparé ou version Steam adulte) ?
3. **Équilibre combat / narration** : quel ratio visé (30/70, 50/50…) ? Tour par tour pur, ou hybride avec des phases d'action en temps réel ?
4. **Régression** : boucle roguelite narrative à chaque mort, ou prédiction sans boucle, où la mort est une fin ?
5. **Protagoniste** : homme fixe, ou choix du genre avec des romances adaptées (harem inversé possible) ?
