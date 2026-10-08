# GALERIE — inventaire des scènes

> Fichier **généré** par `tools/build_gallery_doc.py` depuis `data/world/gallery.json`.
> Pour ajouter ou modifier une scène, éditer le JSON puis relancer le script (le validateur vérifie le catalogue).

Catalogue de la galerie. Onglets « histoire » (CG clés) et « intime » (scènes intimes). Une entrée se débloque dès qu'un de ses blocs « unlock » commence (SaveManager.meta.scenes) ; « Revoir » rejoue « scene » sans toucher à la partie. status : ecrite (scène complète jusqu'au palier P3), amorce (début jouable, texte à compléter), prevue (emplacement réservé, « setup » dit ce qui manque). Les nuits de Pacte sont des rapports de force, sans intimité. Validé par tools/validate_data.py.

## Bilan

| Onglet | Catégorie | Écrites | Amorces | Prévues |
|---|---|---|---|---|
| Histoire / CG clés | CG clés | 17 | 0 | 0 |
| Histoire / CG clés | Soirées au Refuge | 7 | 0 | 0 |
| Scènes intimes | Solo | 42 | 8 | 23 |
| Scènes intimes | Duos | 0 | 10 | 35 |
| Scènes intimes | Trios | 1 | 9 | 0 |
| Scènes intimes | Quatuors | 1 | 2 | 0 |
| Scènes intimes | Constellations (5 à 9) | 1 | 2 | 2 |
| Scènes intimes | Harem | 1 | 0 | 3 |
| **Total** | | **70** | **31** | **63** |

Par voie : Histoire 17 · Refuge 7 · Affinités (Lien) 22 · Échos 10 · Tyran (Ombre) 11 · Tyran (Pacte) 6 · Dévotion 6 · Mercenaire 11 · Loup 10 · Groupe 64

## Histoire / CG clés

### CG clés (17)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| La première mort<br>`prologue_j1:first_life` | Histoire | Haneul (l'Héritière) | écrite | Prologue : la première vie d'Elias. |
| L'éveil du Registre<br>`prologue_j1:wake` | Histoire | — | écrite | Prologue : l'éveil du Registre. |
| La porte sans serrure<br>`act1_haneul:rencontre` | Histoire | Haneul (l'Héritière) | écrite | Acte I, étage 1 de la Tour : ouvrir la porte sans serrure avant que Haneul soit capturée. |
| Le tribut<br>`act1_camp:tribut` | Histoire | Park Seo-Yeon | écrite | Jour 4 au camp de Yeouido : exiger un tribut et l'obéissance de Seo-Yeon. |
| Le soir au camp<br>`act1_camp:seo_soir` | Histoire | Park Seo-Yeon | écrite | Jour 3 au soir, avec Seo-Yeon dans le groupe. |
| La barge de Longwei<br>`act1_world:xiaoyu_barge` | Histoire | Long Xiaoyu | écrite | Acte I : monter à bord de la barge de Xiaoyu (Ponts du Han). |
| Le studio<br>`act2_aoi:studio2` | Histoire | Aoi Tsukishiro | écrite | Jours 8-9 : rendre visite à Aoi au studio de Hongdae avant le concert. |
| Le contrat de Xiaoyu<br>`act3_xiaoyu:contrat` | Histoire | Long Xiaoyu | écrite | Acte III : Xiaoyu a survécu à la mutinerie ; la retrouver à sa barge à partir du jour 20. |
| Le Corbeau<br>`act4_world:corbeau` | Histoire | Park Seo-Yeon | écrite | À partir du jour 27, au moins trois liens forts dans le groupe, le Prophète encore masqué. |
| La veille<br>`act4_world:veille` | Histoire | Haneul (l'Héritière), Park Seo-Yeon, Yoon Hae-in, Baek Ryeon, Simone Hayes, Long Xiaoyu, Aoi Tsukishiro, Nadia Tsoi, Maricel Dizon, Dr. Tran Minh-Anh | écrite | Jour 29 au soir, au moins quatre liens forts dans le groupe. |
| Le toit de la Lotte<br>`act4_nadia:toit` | Histoire | Nadia Tsoi | écrite | Jour 24 après-midi : honorer le rendez-vous de Nadia sur le toit de la Lotte. |
| La machine d'inversion<br>`act4_minh_anh:machine` | Histoire | Dr. Tran Minh-Anh | écrite | Jour 26 au soir : être présent quand Minh-Anh lance la machine. |
| Le dernier exode<br>`act4_world:exode` | Histoire | — | écrite | Jour 27 : mener l'exode en journée. |
| Le Protocole Cendre<br>`act4_world:cendre` | Histoire | Simone Hayes | écrite | Jour 28 au matin : être là quand le Protocole Cendre est déclenché. |
| La Nuit du Déversement<br>`act4_finale:debut` | Histoire | — | écrite | Jour 30 : la Nuit du Déversement commence. |
| L'Épreuve des Dix<br>`act4_finale:epreuve_dix` | Histoire | Haneul (l'Héritière), Park Seo-Yeon, Yoon Hae-in, Baek Ryeon, Simone Hayes, Long Xiaoyu, Aoi Tsukishiro, Nadia Tsoi, Maricel Dizon, Dr. Tran Minh-Anh | écrite | Nuit du Déversement : affronter l'Épreuve avec dix liens forts. |
| La page de Haneul<br>`act4_finale:page` | Histoire | Haneul (l'Héritière) | écrite | Nuit du Déversement : atteindre le Seuil et la dernière page de Haneul. |

### Soirées au Refuge (7)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Leçon d'anatomie<br>`refuge_groupe:lecon_anatomie` | Refuge | Park Seo-Yeon, Haneul (l'Héritière) | écrite | Refuge : Seo-Yeon et Haneul dans le groupe, Affinité ≥ 15 pour les deux. |
| Karaoké à deux voix<br>`refuge_groupe:deux_voix` | Refuge | Aoi Tsukishiro, Maricel Dizon | écrite | Refuge : Aoi et Maricel dans le groupe, Affinité ≥ 15 pour les deux. |
| Deux lames sur le toit<br>`refuge_groupe:deux_lames` | Refuge | Baek Ryeon, Nadia Tsoi | écrite | Refuge : Ryeon et Nadia dans le groupe, Affinité ≥ 15 pour les deux. |
| Le Mahjong des Reines<br>`refuge_groupe:mahjong_reines` | Refuge | Yoon Hae-in, Long Xiaoyu | écrite | Refuge : Hae-in et Xiaoyu dans le groupe, Affinité ≥ 10 pour les deux. |
| Sérum H-07<br>`refuge_groupe:serum` | Refuge | Park Seo-Yeon, Dr. Tran Minh-Anh | écrite | Refuge : Seo-Yeon et Minh-Anh dans le groupe, Affinité ≥ 10 pour les deux. |
| Je ne suis pas un sujet<br>`refuge_groupe:sujet` | Refuge | Haneul (l'Héritière), Dr. Tran Minh-Anh | écrite | Refuge : Haneul et Minh-Anh dans le groupe, Affinité de Minh-Anh ≥ 10. |
| Le Silo<br>`refuge_groupe:silo` | Refuge | Simone Hayes, Dr. Tran Minh-Anh | écrite | Refuge : Simone et Minh-Anh dans le groupe, Affinité ≥ 10 pour les deux. |

## Scènes intimes

### Solo (73)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Nuit de Lien — Seo-Yeon<br>`refuge:seo_intime` | Affinités (Lien) | Park Seo-Yeon | écrite | Affinité de Seo-Yeon ≥ 25, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Haneul<br>`refuge:haneul_intime` | Affinités (Lien) | Haneul (l'Héritière) | écrite | Affinité de Haneul ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Aoi<br>`refuge:aoi_intime` | Affinités (Lien) | Aoi Tsukishiro | écrite | Affinité de Aoi ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Maricel<br>`refuge:maricel_intime` | Affinités (Lien) | Maricel Dizon | écrite | Affinité de Maricel ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Ryeon<br>`refuge:ryeon_intime` | Affinités (Lien) | Baek Ryeon | écrite | Affinité de Ryeon ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Xiaoyu<br>`refuge:xiaoyu_intime` | Affinités (Lien) | Long Xiaoyu | écrite | Affinité de Xiaoyu ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Hae-in<br>`refuge:haein_intime` | Affinités (Lien) | Yoon Hae-in | écrite | Affinité de Hae-in ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Nadia<br>`refuge:nadia_intime` | Affinités (Lien) | Nadia Tsoi | écrite | Affinité de Nadia ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Simone<br>`refuge:simone_intime` | Affinités (Lien) | Simone Hayes | écrite | Affinité de Simone ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Nuit de Lien — Minh-Anh<br>`refuge:minh_anh_intime` | Affinités (Lien) | Dr. Tran Minh-Anh | écrite | Affinité de Minh-Anh ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit ; ni sur la pente du Tyran (Protéger > −15) ni en Mercenaire. |
| Le Penthouse — Hae-in<br>`act1_haein:penthouse_go` | Affinités (Lien) | Yoon Hae-in | écrite | Acte I : livrer l'archive à Hae-in, puis, le jour 6 au crépuscule, monter dans sa voiture. |
| Seconde nuit — Seo-Yeon<br>`refuge:seo_nuit2` | Affinités (Lien) | Park Seo-Yeon | amorce | Après la Nuit de Lien avec Seo-Yeon, se reposer encore deux fois avec elle (3 repos en tout). Variante si Haneul l'a marquée. |
| Seconde nuit — Haneul<br>— | Affinités (Lien) | Haneul (l'Héritière) | **prévue** | Après la Nuit de Lien avec Haneul, se reposer encore deux fois avec elle. |
| Seconde nuit — Aoi<br>— | Affinités (Lien) | Aoi Tsukishiro | **prévue** | Après la Nuit de Lien avec Aoi, se reposer encore deux fois avec elle. |
| Seconde nuit — Maricel<br>— | Affinités (Lien) | Maricel Dizon | **prévue** | Après la Nuit de Lien avec Maricel, se reposer encore deux fois avec elle. |
| Seconde nuit — Ryeon<br>— | Affinités (Lien) | Baek Ryeon | **prévue** | Après la Nuit de Lien avec Ryeon, se reposer encore deux fois avec elle. |
| Seconde nuit — Xiaoyu<br>— | Affinités (Lien) | Long Xiaoyu | **prévue** | Après la Nuit de Lien avec Xiaoyu, se reposer encore deux fois avec elle. |
| Seconde nuit — Hae-in<br>— | Affinités (Lien) | Yoon Hae-in | **prévue** | Après la Nuit de Lien avec Hae-in, se reposer encore deux fois avec elle. |
| Seconde nuit — Nadia<br>— | Affinités (Lien) | Nadia Tsoi | **prévue** | Après la Nuit de Lien avec Nadia, se reposer encore deux fois avec elle. |
| Seconde nuit — Simone<br>— | Affinités (Lien) | Simone Hayes | **prévue** | Après la Nuit de Lien avec Simone, se reposer encore deux fois avec elle. |
| Seconde nuit — Minh-Anh<br>— | Affinités (Lien) | Dr. Tran Minh-Anh | **prévue** | Après la Nuit de Lien avec Minh-Anh, se reposer encore deux fois avec elle. |
| Écho — Seo-Yeon<br>`refuge:seo_yeon_echo` | Échos | Park Seo-Yeon | amorce | Récurrence 2 ou plus : Seo-Yeon est morte dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Haneul<br>`refuge:haneul_echo` | Échos | Haneul (l'Héritière) | amorce | Récurrence 2 ou plus : Haneul a été capturée dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Aoi<br>`refuge:aoi_echo` | Échos | Aoi Tsukishiro | amorce | Récurrence 2 ou plus : tu as sauvé Aoi dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Maricel<br>`refuge:maricel_echo` | Échos | Maricel Dizon | amorce | Récurrence 2 ou plus : Maricel est morte dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Ryeon<br>`refuge:ryeon_echo` | Échos | Baek Ryeon | amorce | Récurrence 2 ou plus : Ryeon est morte dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Xiaoyu<br>`refuge:xiaoyu_echo` | Échos | Long Xiaoyu | amorce | Récurrence 2 ou plus : tu as sauvé Xiaoyu dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Hae-in<br>`refuge:hae_in_echo` | Échos | Yoon Hae-in | amorce | Récurrence 2 ou plus : tu as sauvé Hae-in dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Nadia<br>— | Échos | Nadia Tsoi | **prévue** | Récurrence 2 ou plus : l'avoir sauvée (ou croisée dans la lunette, pour Nadia) dans une boucle précédente, puis se reposer avec elle. |
| Écho — Simone<br>— | Échos | Simone Hayes | **prévue** | Récurrence 2 ou plus : l'avoir sauvée (ou croisée dans la lunette, pour Nadia) dans une boucle précédente, puis se reposer avec elle. |
| Écho — Minh-Anh<br>— | Échos | Dr. Tran Minh-Anh | **prévue** | Récurrence 2 ou plus : l'avoir sauvée (ou croisée dans la lunette, pour Nadia) dans une boucle précédente, puis se reposer avec elle. |
| Nuit d'Ombre — Seo-Yeon<br>`refuge:seo_ombre` | Tyran (Ombre) | Park Seo-Yeon | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Seo-Yeon ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Haneul<br>`refuge:haneul_ombre` | Tyran (Ombre) | Haneul (l'Héritière) | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Haneul ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Aoi<br>`refuge:aoi_ombre` | Tyran (Ombre) | Aoi Tsukishiro | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Aoi ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Maricel<br>`refuge:maricel_ombre` | Tyran (Ombre) | Maricel Dizon | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Maricel ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Ryeon<br>`refuge:ryeon_ombre` | Tyran (Ombre) | Baek Ryeon | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Ryeon ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Xiaoyu<br>`refuge:xiaoyu_ombre` | Tyran (Ombre) | Long Xiaoyu | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Xiaoyu ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Hae-in<br>`refuge:haein_ombre` | Tyran (Ombre) | Yoon Hae-in | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Hae-in ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Nadia<br>`refuge:nadia_ombre` | Tyran (Ombre) | Nadia Tsoi | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Nadia ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Simone<br>`refuge:simone_ombre` | Tyran (Ombre) | Simone Hayes | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Simone ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Nuit d'Ombre — Minh-Anh<br>`refuge:minh_anh_ombre` | Tyran (Ombre) | Dr. Tran Minh-Anh | écrite | Sur la pente du Tyran (Protéger ≤ −15), mais sans contrat forcé : Affinité de Minh-Anh ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. Elle vient d'elle-même, avec ses règles. |
| Contrat de nuit — Seo-Yeon<br>`refuge:seo_merc` | Mercenaire | Park Seo-Yeon | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Seo-Yeon ≥ 25, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Haneul<br>`refuge:haneul_merc` | Mercenaire | Haneul (l'Héritière) | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Haneul ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Aoi<br>`refuge:aoi_merc` | Mercenaire | Aoi Tsukishiro | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Aoi ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Maricel<br>`refuge:maricel_merc` | Mercenaire | Maricel Dizon | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Maricel ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Ryeon<br>`refuge:ryeon_merc` | Mercenaire | Baek Ryeon | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Ryeon ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Xiaoyu<br>`refuge:xiaoyu_merc` | Mercenaire | Long Xiaoyu | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Xiaoyu ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Hae-in<br>`refuge:haein_merc` | Mercenaire | Yoon Hae-in | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Hae-in ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Nadia<br>`refuge:nadia_merc` | Mercenaire | Nadia Tsoi | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Nadia ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Simone<br>`refuge:simone_merc` | Mercenaire | Simone Hayes | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Simone ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Contrat de nuit — Minh-Anh<br>`refuge:minh_anh_merc` | Mercenaire | Dr. Tran Minh-Anh | écrite | Voie du Mercenaire (400 ₩ en poche, ni Héros, ni Tyran, ni Loup) : Affinité de Minh-Anh ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit de Pacte — Seo-Yeon<br>`refuge:seo_pacte` | Tyran (Pacte) | Park Seo-Yeon | écrite | Forcer le contrat avec Seo-Yeon — Jour 4 au camp de Yeouido, exiger un tribut et l'obéissance de Seo-Yeon (ou, à l'Acte II, la racheter avec son collier). Puis l'appeler au Refuge. Rapport de force, sans intimité. |
| Nuit de Pacte — Xiaoyu<br>`refuge:xiaoyu_pacte` | Tyran (Pacte) | Long Xiaoyu | écrite | Forcer le contrat avec Xiaoyu — Acte III, pendant la mutinerie : jouer son Sceau et elle-même au mahjong. Puis l'appeler au Refuge. Rapport de force, sans intimité. |
| Nuit de Pacte — Hae-in<br>`refuge:haein_pacte` | Tyran (Pacte) | Yoon Hae-in | écrite | Forcer le contrat avec Hae-in — Acte III : prendre le Sceau de la Balance « et toi avec ». Puis l'appeler au Refuge. Rapport de force, sans intimité. |
| Nuit de Pacte — Simone<br>`refuge:simone_pacte` | Tyran (Pacte) | Simone Hayes | écrite | Forcer le contrat avec Simone — Jour 28, Protocole Cendre : prendre le code de force (Protéger ≤ −15). Puis l'appeler au Refuge. Rapport de force, sans intimité. |
| Nuit de Pacte — Nadia<br>`refuge:nadia_pacte` | Tyran (Pacte) | Nadia Tsoi | écrite | Forcer le contrat avec Nadia — Jour 24 sur le toit de la Lotte : racheter son contrat à vie (300 ₩, Protéger ≤ −10). Puis l'appeler au Refuge. Rapport de force, sans intimité. |
| Nuit de Pacte — Aoi<br>`refuge:aoi_dominee` | Tyran (Pacte) | Aoi Tsukishiro | écrite | Forcer le contrat avec Aoi — Acte II, au studio : la racheter à Mirae pour qu'elle chante pour toi. Puis l'appeler au Refuge. Rapport de force, sans intimité. |
| Dévotion — Seo-Yeon<br>`refuge:seo_devotion` | Dévotion | Park Seo-Yeon | écrite | Sous Pacte avec Seo-Yeon, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Xiaoyu<br>`refuge:xiaoyu_devotion` | Dévotion | Long Xiaoyu | écrite | Sous Pacte avec Xiaoyu, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Hae-in<br>`refuge:haein_devotion` | Dévotion | Yoon Hae-in | écrite | Sous Pacte avec Hae-in, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Simone<br>`refuge:simone_devotion` | Dévotion | Simone Hayes | écrite | Sous Pacte avec Simone, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Nadia<br>`refuge:nadia_devotion` | Dévotion | Nadia Tsoi | écrite | Sous Pacte avec Nadia, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Aoi<br>— | Dévotion | Aoi Tsukishiro | **prévue** | Après l'avoir rachetée à Mirae, lui rendre sa voix jusqu'à ce qu'elle choisisse de chanter pour toi. |
| Nuit du Loup — Seo-Yeon<br>— | Loup | Park Seo-Yeon | **prévue** | Voie du Loup (Lien ≤ −20) : Seo-Yeon trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Haneul<br>— | Loup | Haneul (l'Héritière) | **prévue** | Voie du Loup (Lien ≤ −20) : Haneul trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Aoi<br>— | Loup | Aoi Tsukishiro | **prévue** | Voie du Loup (Lien ≤ −20) : Aoi trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Maricel<br>— | Loup | Maricel Dizon | **prévue** | Voie du Loup (Lien ≤ −20) : Maricel trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Ryeon<br>— | Loup | Baek Ryeon | **prévue** | Voie du Loup (Lien ≤ −20) : Ryeon trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Xiaoyu<br>— | Loup | Long Xiaoyu | **prévue** | Voie du Loup (Lien ≤ −20) : Xiaoyu trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Hae-in<br>— | Loup | Yoon Hae-in | **prévue** | Voie du Loup (Lien ≤ −20) : Hae-in trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Nadia<br>— | Loup | Nadia Tsoi | **prévue** | Voie du Loup (Lien ≤ −20) : Nadia trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Simone<br>— | Loup | Simone Hayes | **prévue** | Voie du Loup (Lien ≤ −20) : Simone trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |
| Nuit du Loup — Minh-Anh<br>— | Loup | Dr. Tran Minh-Anh | **prévue** | Voie du Loup (Lien ≤ −20) : Minh-Anh trouve la faille dans ta solitude. Affinité ≥ 20, Dortoir. |

### Duos (45)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Lame et Lunette : Ryeon et Nadia<br>`refuge_groupe:paire_ryeon_nadia` | Groupe | Baek Ryeon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Feu Croisé : Simone et Nadia<br>`refuge_groupe:paire_simone_nadia` | Groupe | Simone Hayes, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| OPA Hostile : Hae-in et Xiaoyu<br>`refuge_groupe:paire_hae_in_xiaoyu` | Groupe | Yoon Hae-in, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Sérum H-07 : Seo-Yeon et Minh-Anh<br>`refuge_groupe:paire_seo_yeon_minh_anh` | Groupe | Park Seo-Yeon, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Contrebande : Maricel et Xiaoyu<br>`refuge_groupe:paire_maricel_xiaoyu` | Groupe | Maricel Dizon, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Équation du Seuil : Minh-Anh et Haneul<br>`refuge_groupe:paire_minh_anh_haneul` | Groupe | Dr. Tran Minh-Anh, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Minh-Anh et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Avant-Garde : Simone et Ryeon<br>`refuge_groupe:paire_simone_ryeon` | Groupe | Simone Hayes, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Hymne du Seuil : Aoi et Haneul<br>`refuge_groupe:paire_aoi_haneul` | Groupe | Aoi Tsukishiro, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Loi Martiale : Hae-in et Simone<br>`refuge_groupe:paire_hae_in_simone` | Groupe | Yoon Hae-in, Simone Hayes | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Ballade du Triage : Seo-Yeon et Aoi<br>`refuge_groupe:paire_seo_yeon_aoi` | Groupe | Park Seo-Yeon, Aoi Tsukishiro | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Aoi, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Seo-Yeon et Haneul<br>— | Groupe | Park Seo-Yeon, Haneul (l'Héritière) | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Seo-Yeon et Maricel<br>— | Groupe | Park Seo-Yeon, Maricel Dizon | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Maricel, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Seo-Yeon et Ryeon<br>— | Groupe | Park Seo-Yeon, Baek Ryeon | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Seo-Yeon et Xiaoyu<br>— | Groupe | Park Seo-Yeon, Long Xiaoyu | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Seo-Yeon et Hae-in<br>— | Groupe | Park Seo-Yeon, Yoon Hae-in | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Seo-Yeon et Nadia<br>— | Groupe | Park Seo-Yeon, Nadia Tsoi | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Seo-Yeon et Simone<br>— | Groupe | Park Seo-Yeon, Simone Hayes | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Haneul et Maricel<br>— | Groupe | Haneul (l'Héritière), Maricel Dizon | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Maricel, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Haneul et Ryeon<br>— | Groupe | Haneul (l'Héritière), Baek Ryeon | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Haneul et Xiaoyu<br>— | Groupe | Haneul (l'Héritière), Long Xiaoyu | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Haneul et Hae-in<br>— | Groupe | Haneul (l'Héritière), Yoon Hae-in | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Haneul et Nadia<br>— | Groupe | Haneul (l'Héritière), Nadia Tsoi | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Haneul et Simone<br>— | Groupe | Haneul (l'Héritière), Simone Hayes | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Aoi et Maricel<br>— | Groupe | Aoi Tsukishiro, Maricel Dizon | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Maricel, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Aoi et Ryeon<br>— | Groupe | Aoi Tsukishiro, Baek Ryeon | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Aoi et Xiaoyu<br>— | Groupe | Aoi Tsukishiro, Long Xiaoyu | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Aoi et Hae-in<br>— | Groupe | Aoi Tsukishiro, Yoon Hae-in | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Aoi et Nadia<br>— | Groupe | Aoi Tsukishiro, Nadia Tsoi | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Aoi et Simone<br>— | Groupe | Aoi Tsukishiro, Simone Hayes | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Aoi et Minh-Anh<br>— | Groupe | Aoi Tsukishiro, Dr. Tran Minh-Anh | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Maricel et Ryeon<br>— | Groupe | Maricel Dizon, Baek Ryeon | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Maricel et Hae-in<br>— | Groupe | Maricel Dizon, Yoon Hae-in | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Maricel et Nadia<br>— | Groupe | Maricel Dizon, Nadia Tsoi | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Maricel et Simone<br>— | Groupe | Maricel Dizon, Simone Hayes | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Maricel et Minh-Anh<br>— | Groupe | Maricel Dizon, Dr. Tran Minh-Anh | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Ryeon et Xiaoyu<br>— | Groupe | Baek Ryeon, Long Xiaoyu | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Ryeon et Hae-in<br>— | Groupe | Baek Ryeon, Yoon Hae-in | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Ryeon et Minh-Anh<br>— | Groupe | Baek Ryeon, Dr. Tran Minh-Anh | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Xiaoyu et Nadia<br>— | Groupe | Long Xiaoyu, Nadia Tsoi | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Xiaoyu et Simone<br>— | Groupe | Long Xiaoyu, Simone Hayes | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Xiaoyu et Minh-Anh<br>— | Groupe | Long Xiaoyu, Dr. Tran Minh-Anh | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Hae-in et Nadia<br>— | Groupe | Yoon Hae-in, Nadia Tsoi | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Hae-in et Minh-Anh<br>— | Groupe | Yoon Hae-in, Dr. Tran Minh-Anh | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Nadia et Minh-Anh<br>— | Groupe | Nadia Tsoi, Dr. Tran Minh-Anh | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Nadia et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Simone et Minh-Anh<br>— | Groupe | Simone Hayes, Dr. Tran Minh-Anh | **prévue** | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |

### Trios (10)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| La Nuit des Trois : Seo-Yeon, Aoi et Maricel<br>`refuge_groupe:nuit_des_trois` | Groupe | Park Seo-Yeon, Aoi Tsukishiro, Maricel Dizon | écrite | Affinité ≥ 20 avec Seo-Yeon, Aoi et Maricel, les trois dans le groupe, Dortoir construit. |
| Les Trois Lames<br>`refuge_groupe:trio_trois_lames` | Groupe | Baek Ryeon, Simone Hayes, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon, Simone et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Les Reines<br>`refuge_groupe:trio_reines` | Groupe | Yoon Hae-in, Long Xiaoyu, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in, Xiaoyu et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Les Invisibles<br>`refuge_groupe:trio_invisibles` | Groupe | Aoi Tsukishiro, Maricel Dizon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi, Maricel et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Les Filles du Fleuve<br>`refuge_groupe:trio_filles_fleuve` | Groupe | Long Xiaoyu, Maricel Dizon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu, Maricel et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Le Laboratoire<br>`refuge_groupe:trio_laboratoire` | Groupe | Dr. Tran Minh-Anh, Park Seo-Yeon, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Minh-Anh, Seo-Yeon et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Les Sceptres<br>`refuge_groupe:trio_sceptres` | Groupe | Yoon Hae-in, Dr. Tran Minh-Anh, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in, Minh-Anh et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Les Gardiennes du Seuil<br>`refuge_groupe:trio_gardiennes` | Groupe | Haneul (l'Héritière), Baek Ryeon, Aoi Tsukishiro | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul, Ryeon et Aoi, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| La Garde de Fer<br>`refuge_groupe:trio_garde_fer` | Groupe | Simone Hayes, Baek Ryeon, Park Seo-Yeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone, Ryeon et Seo-Yeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |
| Les Trois Vérités<br>`refuge_groupe:trio_trois_verites` | Groupe | Park Seo-Yeon, Yoon Hae-in, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon, Hae-in et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge — seulement à partir de la deuxième récurrence. |

### Quatuors (3)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Les Reines et les Lames<br>`refuge_groupe:reines_lames` | Groupe | Yoon Hae-in, Long Xiaoyu, Baek Ryeon, Simone Hayes | écrite | Affinité ≥ 20 avec Hae-in, Xiaoyu, Ryeon et Simone, toutes dans le groupe, et avoir réconcilié les Reines au Mahjong (scène du Refuge). |
| Les Quatre Fins<br>`refuge_groupe:quatuor_quatre_fins` | Groupe | Aoi Tsukishiro, Park Seo-Yeon, Maricel Dizon, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi, Seo-Yeon, Maricel et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge, à partir du jour 18. |
| Loin de chez soi<br>`refuge_groupe:quatuor_loin_de_chez_soi` | Groupe | Simone Hayes, Nadia Tsoi, Maricel Dizon, Aoi Tsukishiro | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone, Nadia, Maricel et Aoi, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. |

### Constellations (5 à 9) (5)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| La Constellation de cinq<br>`refuge_groupe:constellation_cinq` | Groupe | — | amorce | Cinq héroïnes du groupe à Affinité ≥ 50, Dortoir construit. |
| La Nuit de la Maison (six)<br>`refuge_groupe:nuit_maison` | Groupe | — | écrite | Six héroïnes du groupe à Affinité ≥ 30, Dortoir construit. |
| La Constellation de sept<br>— | Groupe | — | **prévue** | Sept héroïnes du groupe à Affinité ≥ 55, Dortoir construit. |
| La Constellation de huit<br>`refuge_groupe:constellation_huit` | Groupe | — | amorce | Huit héroïnes du groupe à Affinité ≥ 60, Dortoir construit. |
| La Constellation de neuf<br>— | Groupe | — | **prévue** | Neuf héroïnes du groupe à Affinité ≥ 65, Dortoir construit. |

### Harem (4)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Le Portrait des Dix<br>`refuge_groupe:portrait_dix` | Groupe | — | écrite | Les dix héroïnes dans le groupe, toutes à Affinité ≥ 30. |
| L'Aube des Dix<br>— | Affinités (Lien) | — | **prévue** | Atteindre la Fin de l'Aube avec les dix héroïnes dans le groupe (Épreuve des Dix réussie). |
| Le Contrat collectif<br>— | Mercenaire | — | **prévue** | Voie du Mercenaire avec au moins six nuits de contrat déjà conclues. |
| La Cour de l'Ombre<br>— | Tyran (Ombre) | — | **prévue** | Sur la pente du Tyran sans aucun contrat forcé : six nuits d'Ombre consenties. |

## À mettre en place (63 emplacements prévus)

Chaque emplacement est déjà visible dans la galerie (« En préparation », avec son indice). Pour le rendre jouable : écrire la scène, ajouter son déclencheur, puis passer l'entrée en « amorce » ou « ecrite » avec `scene` et `unlock`.

- **Seconde nuit — Haneul** (`haneul_nuit2`) — Bloc refuge:haneul_nuit2 à écrire, aiguillage « flag('haneul_nuit') and v('repos.haneul') >= 3 » dans refuge:haneul.
- **Seconde nuit — Aoi** (`aoi_nuit2`) — Bloc refuge:aoi_nuit2 à écrire, aiguillage « flag('aoi_nuit') and v('repos.aoi') >= 3 » dans refuge:aoi.
- **Seconde nuit — Maricel** (`maricel_nuit2`) — Bloc refuge:maricel_nuit2 à écrire, aiguillage « flag('maricel_nuit') and v('repos.maricel') >= 3 » dans refuge:maricel.
- **Seconde nuit — Ryeon** (`ryeon_nuit2`) — Bloc refuge:ryeon_nuit2 à écrire, aiguillage « flag('ryeon_nuit') and v('repos.ryeon') >= 3 » dans refuge:ryeon.
- **Seconde nuit — Xiaoyu** (`xiaoyu_nuit2`) — Bloc refuge:xiaoyu_nuit2 à écrire, aiguillage « flag('xiaoyu_nuit') and v('repos.xiaoyu') >= 3 » dans refuge:xiaoyu.
- **Seconde nuit — Hae-in** (`haein_nuit2`) — Bloc refuge:haein_nuit2 à écrire, aiguillage « flag('haein_nuit') and v('repos.hae_in') >= 3 » dans refuge:hae_in.
- **Seconde nuit — Nadia** (`nadia_nuit2`) — Bloc refuge:nadia_nuit2 à écrire, aiguillage « flag('nadia_nuit') and v('repos.nadia') >= 3 » dans refuge:nadia.
- **Seconde nuit — Simone** (`simone_nuit2`) — Bloc refuge:simone_nuit2 à écrire, aiguillage « flag('simone_nuit') and v('repos.simone') >= 3 » dans refuge:simone.
- **Seconde nuit — Minh-Anh** (`minh_anh_nuit2`) — Bloc refuge:minh_anh_nuit2 à écrire, aiguillage « flag('minh_anh_nuit') and v('repos.minh_anh') >= 3 » dans refuge:minh_anh.
- **Écho — Nadia** (`nadia_echo`) — Bloc refuge:nadia_echo à écrire, aiguillage « loop() >= 2 and flag('echo.nadia_tir') » dans refuge:nadia.
- **Écho — Simone** (`simone_echo`) — Bloc refuge:simone_echo à écrire, aiguillage « loop() >= 2 and flag('echo.simone_sauvee') » dans refuge:simone.
- **Écho — Minh-Anh** (`minh_anh_echo`) — Bloc refuge:minh_anh_echo à écrire, aiguillage « loop() >= 2 and flag('echo.minh_anh_sauvee') » dans refuge:minh_anh.
- **Dévotion — Aoi** (`aoi_devotion`) — Variables ambivalence.aoi à introduire dans act2_aoi:studio_tyran, blocs refuge:aoi_devotion / aoi_devotion_nuit, CG cg_aoi_devotion (RunPod).
- **Nuit du Loup — Seo-Yeon** (`seo_loup`) — Bloc refuge:seo_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_seo_loup.
- **Nuit du Loup — Haneul** (`haneul_loup`) — Bloc refuge:haneul_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_haneul_loup.
- **Nuit du Loup — Aoi** (`aoi_loup`) — Bloc refuge:aoi_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_aoi_loup.
- **Nuit du Loup — Maricel** (`maricel_loup`) — Bloc refuge:maricel_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_maricel_loup.
- **Nuit du Loup — Ryeon** (`ryeon_loup`) — Bloc refuge:ryeon_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_ryeon_loup.
- **Nuit du Loup — Xiaoyu** (`xiaoyu_loup`) — Bloc refuge:xiaoyu_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_xiaoyu_loup.
- **Nuit du Loup — Hae-in** (`haein_loup`) — Bloc refuge:haein_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_haein_loup.
- **Nuit du Loup — Nadia** (`nadia_loup`) — Bloc refuge:nadia_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_nadia_loup.
- **Nuit du Loup — Simone** (`simone_loup`) — Bloc refuge:simone_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_simone_loup.
- **Nuit du Loup — Minh-Anh** (`minh_anh_loup`) — Bloc refuge:minh_anh_loup à écrire (aiguillage « voie() == 'loup' » avant la Nuit de Lien), CG cg_minh_anh_loup.
- **Seo-Yeon et Haneul** (`paire_seo_yeon_haneul`) — Bloc refuge_groupe:paire_seo_yeon_haneul à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Seo-Yeon et Maricel** (`paire_seo_yeon_maricel`) — Bloc refuge_groupe:paire_seo_yeon_maricel à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Seo-Yeon et Ryeon** (`paire_seo_yeon_ryeon`) — Bloc refuge_groupe:paire_seo_yeon_ryeon à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Seo-Yeon et Xiaoyu** (`paire_seo_yeon_xiaoyu`) — Bloc refuge_groupe:paire_seo_yeon_xiaoyu à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Seo-Yeon et Hae-in** (`paire_seo_yeon_hae_in`) — Bloc refuge_groupe:paire_seo_yeon_hae_in à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Seo-Yeon et Nadia** (`paire_seo_yeon_nadia`) — Bloc refuge_groupe:paire_seo_yeon_nadia à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Seo-Yeon et Simone** (`paire_seo_yeon_simone`) — Bloc refuge_groupe:paire_seo_yeon_simone à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Haneul et Maricel** (`paire_haneul_maricel`) — Bloc refuge_groupe:paire_haneul_maricel à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Haneul et Ryeon** (`paire_haneul_ryeon`) — Bloc refuge_groupe:paire_haneul_ryeon à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Haneul et Xiaoyu** (`paire_haneul_xiaoyu`) — Bloc refuge_groupe:paire_haneul_xiaoyu à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Haneul et Hae-in** (`paire_haneul_hae_in`) — Bloc refuge_groupe:paire_haneul_hae_in à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Haneul et Nadia** (`paire_haneul_nadia`) — Bloc refuge_groupe:paire_haneul_nadia à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Haneul et Simone** (`paire_haneul_simone`) — Bloc refuge_groupe:paire_haneul_simone à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Aoi et Maricel** (`paire_aoi_maricel`) — Bloc refuge_groupe:paire_aoi_maricel à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Aoi et Ryeon** (`paire_aoi_ryeon`) — Bloc refuge_groupe:paire_aoi_ryeon à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Aoi et Xiaoyu** (`paire_aoi_xiaoyu`) — Bloc refuge_groupe:paire_aoi_xiaoyu à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Aoi et Hae-in** (`paire_aoi_hae_in`) — Bloc refuge_groupe:paire_aoi_hae_in à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Aoi et Nadia** (`paire_aoi_nadia`) — Bloc refuge_groupe:paire_aoi_nadia à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Aoi et Simone** (`paire_aoi_simone`) — Bloc refuge_groupe:paire_aoi_simone à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Aoi et Minh-Anh** (`paire_aoi_minh_anh`) — Bloc refuge_groupe:paire_aoi_minh_anh à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Maricel et Ryeon** (`paire_maricel_ryeon`) — Bloc refuge_groupe:paire_maricel_ryeon à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Maricel et Hae-in** (`paire_maricel_hae_in`) — Bloc refuge_groupe:paire_maricel_hae_in à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Maricel et Nadia** (`paire_maricel_nadia`) — Bloc refuge_groupe:paire_maricel_nadia à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Maricel et Simone** (`paire_maricel_simone`) — Bloc refuge_groupe:paire_maricel_simone à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Maricel et Minh-Anh** (`paire_maricel_minh_anh`) — Bloc refuge_groupe:paire_maricel_minh_anh à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Ryeon et Xiaoyu** (`paire_ryeon_xiaoyu`) — Bloc refuge_groupe:paire_ryeon_xiaoyu à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Ryeon et Hae-in** (`paire_ryeon_hae_in`) — Bloc refuge_groupe:paire_ryeon_hae_in à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Ryeon et Minh-Anh** (`paire_ryeon_minh_anh`) — Bloc refuge_groupe:paire_ryeon_minh_anh à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Xiaoyu et Nadia** (`paire_xiaoyu_nadia`) — Bloc refuge_groupe:paire_xiaoyu_nadia à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Xiaoyu et Simone** (`paire_xiaoyu_simone`) — Bloc refuge_groupe:paire_xiaoyu_simone à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Xiaoyu et Minh-Anh** (`paire_xiaoyu_minh_anh`) — Bloc refuge_groupe:paire_xiaoyu_minh_anh à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Hae-in et Nadia** (`paire_hae_in_nadia`) — Bloc refuge_groupe:paire_hae_in_nadia à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Hae-in et Minh-Anh** (`paire_hae_in_minh_anh`) — Bloc refuge_groupe:paire_hae_in_minh_anh à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Nadia et Minh-Anh** (`paire_nadia_minh_anh`) — Bloc refuge_groupe:paire_nadia_minh_anh à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **Simone et Minh-Anh** (`paire_simone_minh_anh`) — Bloc refuge_groupe:paire_simone_minh_anh à écrire + entrée data/world/group_scenes.json (même déclencheur que les autres paires).
- **La Constellation de sept** (`constellation_sept`) — Bloc refuge_groupe:constellation_sept + entrée group_scenes « bonds(55) >= 7 and flag('refuge.dortoir') ».
- **La Constellation de neuf** (`constellation_neuf`) — Bloc refuge_groupe:constellation_neuf + entrée group_scenes « bonds(65) >= 9 and flag('refuge.dortoir') ».
- **L'Aube des Dix** (`harem_aube`) — Bloc act4_finale:aube_dix après l'Épreuve des Dix, CG cg_aube_dix (RunPod).
- **Le Contrat collectif** (`harem_mercenaire`) — Bloc refuge_groupe:harem_mercenaire + entrée group_scenes (voie() == 'mercenaire', six drapeaux de nuit).
- **La Cour de l'Ombre** (`harem_ombre`) — Bloc refuge_groupe:harem_ombre + entrée group_scenes (Protéger ≤ −15, aucun drapeau pacte.*, six nuits).

## Amorces à compléter (31)

Le début se joue et débloque l'emplacement ; le texte s'arrête avant la suite (palier P3 vide, CG à créer pour les scènes de groupe).

- Seconde nuit — Seo-Yeon — `refuge:seo_nuit2`
- Écho — Seo-Yeon — `refuge:seo_yeon_echo`
- Écho — Haneul — `refuge:haneul_echo`
- Écho — Aoi — `refuge:aoi_echo`
- Écho — Maricel — `refuge:maricel_echo`
- Écho — Ryeon — `refuge:ryeon_echo`
- Écho — Xiaoyu — `refuge:xiaoyu_echo`
- Écho — Hae-in — `refuge:hae_in_echo`
- Lame et Lunette : Ryeon et Nadia — `refuge_groupe:paire_ryeon_nadia`
- Feu Croisé : Simone et Nadia — `refuge_groupe:paire_simone_nadia`
- OPA Hostile : Hae-in et Xiaoyu — `refuge_groupe:paire_hae_in_xiaoyu`
- Sérum H-07 : Seo-Yeon et Minh-Anh — `refuge_groupe:paire_seo_yeon_minh_anh`
- Contrebande : Maricel et Xiaoyu — `refuge_groupe:paire_maricel_xiaoyu`
- Équation du Seuil : Minh-Anh et Haneul — `refuge_groupe:paire_minh_anh_haneul`
- Avant-Garde : Simone et Ryeon — `refuge_groupe:paire_simone_ryeon`
- Hymne du Seuil : Aoi et Haneul — `refuge_groupe:paire_aoi_haneul`
- Loi Martiale : Hae-in et Simone — `refuge_groupe:paire_hae_in_simone`
- Ballade du Triage : Seo-Yeon et Aoi — `refuge_groupe:paire_seo_yeon_aoi`
- Les Trois Lames — `refuge_groupe:trio_trois_lames`
- Les Reines — `refuge_groupe:trio_reines`
- Les Invisibles — `refuge_groupe:trio_invisibles`
- Les Filles du Fleuve — `refuge_groupe:trio_filles_fleuve`
- Le Laboratoire — `refuge_groupe:trio_laboratoire`
- Les Sceptres — `refuge_groupe:trio_sceptres`
- Les Gardiennes du Seuil — `refuge_groupe:trio_gardiennes`
- La Garde de Fer — `refuge_groupe:trio_garde_fer`
- Les Trois Vérités — `refuge_groupe:trio_trois_verites`
- Les Quatre Fins — `refuge_groupe:quatuor_quatre_fins`
- Loin de chez soi — `refuge_groupe:quatuor_loin_de_chez_soi`
- La Constellation de cinq — `refuge_groupe:constellation_cinq`
- La Constellation de huit — `refuge_groupe:constellation_huit`
