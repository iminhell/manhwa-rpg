# GALERIE — inventaire des scènes

> Fichier **généré** par `tools/build_gallery_doc.py` depuis `data/world/gallery.json`.
> Pour ajouter ou modifier une scène, éditer le JSON puis relancer le script (le validateur vérifie le catalogue).

Catalogue de la galerie. Onglets « histoire » (CG clés) et « intime » (scènes intimes). Une entrée se débloque dès qu'un de ses blocs « unlock » commence (SaveManager.meta.scenes) ; « Revoir » rejoue « scene » sans toucher à la partie. status : ecrite (scène complète jusqu'au palier P3), amorce (début jouable, texte à compléter), prevue (emplacement réservé, « setup » dit ce qui manque ; refusé par le validateur : tout le catalogue doit être jouable). Les nuits de Pacte sont des rapports de force, sans intimité. Validé par tools/validate_data.py.

## Bilan

| Onglet | Catégorie | Écrites | Amorces | Prévues |
|---|---|---|---|---|
| Histoire / CG clés | CG clés | 17 | 0 | 0 |
| Histoire / CG clés | Soirées au Refuge | 7 | 0 | 0 |
| Scènes intimes | Solo | 49 | 30 | 0 |
| Scènes intimes | Duos | 0 | 45 | 0 |
| Scènes intimes | Trios | 1 | 9 | 0 |
| Scènes intimes | Quatuors | 1 | 2 | 0 |
| Scènes intimes | Constellations (5 à 9) | 1 | 4 | 0 |
| Scènes intimes | Harem | 1 | 3 | 0 |
| **Total** | | **77** | **93** | **0** |

Par voie : Histoire 17 · Refuge 7 · Affinités (Lien) 22 · Échos 10 · Tyran (Ombre) 11 · Tyran (Pacte) 6 · Tyran (Contrat renégocié) 6 · Dévotion 6 · Mercenaire 11 · Loup 10 · Groupe 64

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

### Solo (79)

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
| Seconde nuit — Haneul<br>`refuge:haneul_nuit2` | Affinités (Lien) | Haneul (l'Héritière) | amorce | Après une première nuit avec Haneul (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Aoi<br>`refuge:aoi_nuit2` | Affinités (Lien) | Aoi Tsukishiro | amorce | Après une première nuit avec Aoi (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Maricel<br>`refuge:maricel_nuit2` | Affinités (Lien) | Maricel Dizon | amorce | Après une première nuit avec Maricel (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Ryeon<br>`refuge:ryeon_nuit2` | Affinités (Lien) | Baek Ryeon | amorce | Après une première nuit avec Ryeon (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Xiaoyu<br>`refuge:xiaoyu_nuit2` | Affinités (Lien) | Long Xiaoyu | amorce | Après une première nuit avec Xiaoyu (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Hae-in<br>`refuge:haein_nuit2` | Affinités (Lien) | Yoon Hae-in | amorce | Après une première nuit avec Hae-in (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Nadia<br>`refuge:nadia_nuit2` | Affinités (Lien) | Nadia Tsoi | amorce | Après une première nuit avec Nadia (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Simone<br>`refuge:simone_nuit2` | Affinités (Lien) | Simone Hayes | amorce | Après une première nuit avec Simone (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Seconde nuit — Minh-Anh<br>`refuge:minh_anh_nuit2` | Affinités (Lien) | Dr. Tran Minh-Anh | amorce | Après une première nuit avec Minh-Anh (Lien, Ombre, Mercenaire, Loup ou Dévotion), continuer à se reposer avec elle : à partir du troisième repos, elle revient d'elle-même. |
| Écho — Seo-Yeon<br>`refuge:seo_yeon_echo` | Échos | Park Seo-Yeon | amorce | Récurrence 2 ou plus : Seo-Yeon est morte dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Haneul<br>`refuge:haneul_echo` | Échos | Haneul (l'Héritière) | amorce | Récurrence 2 ou plus : Haneul a été capturée dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Aoi<br>`refuge:aoi_echo` | Échos | Aoi Tsukishiro | amorce | Récurrence 2 ou plus : tu as sauvé Aoi dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Maricel<br>`refuge:maricel_echo` | Échos | Maricel Dizon | amorce | Récurrence 2 ou plus : Maricel est morte dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Ryeon<br>`refuge:ryeon_echo` | Échos | Baek Ryeon | amorce | Récurrence 2 ou plus : Ryeon est morte dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Xiaoyu<br>`refuge:xiaoyu_echo` | Échos | Long Xiaoyu | amorce | Récurrence 2 ou plus : tu as sauvé Xiaoyu dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Hae-in<br>`refuge:hae_in_echo` | Échos | Yoon Hae-in | amorce | Récurrence 2 ou plus : tu as sauvé Hae-in dans une boucle précédente. Se reposer avec elle au Refuge dans la boucle suivante. |
| Écho — Nadia<br>`refuge:nadia_echo` | Échos | Nadia Tsoi | amorce | Récurrence 2 ou plus : l'avoir sauvée (ou croisée dans la lunette, pour Nadia) dans une boucle précédente, puis se reposer avec elle. |
| Écho — Simone<br>`refuge:simone_echo` | Échos | Simone Hayes | amorce | Récurrence 2 ou plus : l'avoir sauvée (ou croisée dans la lunette, pour Nadia) dans une boucle précédente, puis se reposer avec elle. |
| Écho — Minh-Anh<br>`refuge:minh_anh_echo` | Échos | Dr. Tran Minh-Anh | amorce | Récurrence 2 ou plus : l'avoir sauvée (ou croisée dans la lunette, pour Nadia) dans une boucle précédente, puis se reposer avec elle. |
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
| Nuit de Pacte — Seo-Yeon<br>`refuge:seo_pacte` | Tyran (Pacte) | Park Seo-Yeon | écrite | Forcer le contrat avec Seo-Yeon — Jour 4 au camp de Yeouido, exiger un tribut et l'obéissance de Seo-Yeon (ou, à l'Acte II, la racheter avec son collier). Puis l'appeler au Refuge. Rapport de force, sans intimité ; le Pacte évolue ensuite selon tes choix (ambivalence, renégociation, Dévotion). |
| Contrat renégocié — Seo-Yeon<br>`refuge:seo_pacte_renegocie` | Tyran (Contrat renégocié) | Park Seo-Yeon | écrite | Sous contrat avec Seo-Yeon, lui laisser sa liberté soir après soir jusqu'à ce que l'ambivalence atteigne +30 et l'Affinité 40 : elle réécrit elle-même le contrat (une Clause du Sceau ou une Ancre de Sang qu'elle seule peut invoquer, le droit de partir). Signer ses conditions. |
| Nuit de Pacte — Xiaoyu<br>`refuge:xiaoyu_pacte` | Tyran (Pacte) | Long Xiaoyu | écrite | Forcer le contrat avec Xiaoyu — Acte III, pendant la mutinerie : jouer son Sceau et elle-même au mahjong. Puis l'appeler au Refuge. Rapport de force, sans intimité ; le Pacte évolue ensuite selon tes choix (ambivalence, renégociation, Dévotion). |
| Contrat renégocié — Xiaoyu<br>`refuge:xiaoyu_pacte_renegocie` | Tyran (Contrat renégocié) | Long Xiaoyu | écrite | Sous contrat avec Xiaoyu, lui laisser sa liberté soir après soir jusqu'à ce que l'ambivalence atteigne +30 et l'Affinité 40 : elle réécrit elle-même le contrat (une Clause du Sceau ou une Ancre de Sang qu'elle seule peut invoquer, le droit de partir). Signer ses conditions. |
| Nuit de Pacte — Hae-in<br>`refuge:haein_pacte` | Tyran (Pacte) | Yoon Hae-in | écrite | Forcer le contrat avec Hae-in — Acte III : prendre le Sceau de la Balance « et toi avec ». Puis l'appeler au Refuge. Rapport de force, sans intimité ; le Pacte évolue ensuite selon tes choix (ambivalence, renégociation, Dévotion). |
| Contrat renégocié — Hae-in<br>`refuge:haein_pacte_renegocie` | Tyran (Contrat renégocié) | Yoon Hae-in | écrite | Sous contrat avec Hae-in, lui laisser sa liberté soir après soir jusqu'à ce que l'ambivalence atteigne +30 et l'Affinité 40 : elle réécrit elle-même le contrat (une Clause du Sceau ou une Ancre de Sang qu'elle seule peut invoquer, le droit de partir). Signer ses conditions. |
| Nuit de Pacte — Simone<br>`refuge:simone_pacte` | Tyran (Pacte) | Simone Hayes | écrite | Forcer le contrat avec Simone — Jour 28, Protocole Cendre : prendre le code de force (Protéger ≤ −15). Puis l'appeler au Refuge. Rapport de force, sans intimité ; le Pacte évolue ensuite selon tes choix (ambivalence, renégociation, Dévotion). |
| Contrat renégocié — Simone<br>`refuge:simone_pacte_renegocie` | Tyran (Contrat renégocié) | Simone Hayes | écrite | Sous contrat avec Simone, lui laisser sa liberté soir après soir jusqu'à ce que l'ambivalence atteigne +30 et l'Affinité 40 : elle réécrit elle-même le contrat (une Clause du Sceau ou une Ancre de Sang qu'elle seule peut invoquer, le droit de partir). Signer ses conditions. |
| Nuit de Pacte — Nadia<br>`refuge:nadia_pacte` | Tyran (Pacte) | Nadia Tsoi | écrite | Forcer le contrat avec Nadia — Jour 24 sur le toit de la Lotte : racheter son contrat à vie (300 ₩, Protéger ≤ −10). Puis l'appeler au Refuge. Rapport de force, sans intimité ; le Pacte évolue ensuite selon tes choix (ambivalence, renégociation, Dévotion). |
| Contrat renégocié — Nadia<br>`refuge:nadia_pacte_renegocie` | Tyran (Contrat renégocié) | Nadia Tsoi | écrite | Sous contrat avec Nadia, lui laisser sa liberté soir après soir jusqu'à ce que l'ambivalence atteigne +30 et l'Affinité 40 : elle réécrit elle-même le contrat (une Clause du Sceau ou une Ancre de Sang qu'elle seule peut invoquer, le droit de partir). Signer ses conditions. |
| Nuit de Pacte — Aoi<br>`refuge:aoi_dominee` | Tyran (Pacte) | Aoi Tsukishiro | écrite | Forcer le contrat avec Aoi — Acte II, au studio : la racheter à Mirae pour qu'elle chante pour toi. Puis l'appeler au Refuge. Rapport de force, sans intimité ; le Pacte évolue ensuite selon tes choix (ambivalence, renégociation, Dévotion). |
| Contrat renégocié — Aoi<br>`refuge:aoi_pacte_renegocie` | Tyran (Contrat renégocié) | Aoi Tsukishiro | écrite | Sous contrat avec Aoi, lui laisser sa liberté soir après soir jusqu'à ce que l'ambivalence atteigne +30 et l'Affinité 40 : elle réécrit elle-même le contrat (une Clause du Sceau ou une Ancre de Sang qu'elle seule peut invoquer, le droit de partir). Signer ses conditions. |
| Dévotion — Seo-Yeon<br>`refuge:seo_devotion` | Dévotion | Park Seo-Yeon | écrite | Sous Pacte avec Seo-Yeon, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Xiaoyu<br>`refuge:xiaoyu_devotion` | Dévotion | Long Xiaoyu | écrite | Sous Pacte avec Xiaoyu, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Hae-in<br>`refuge:haein_devotion` | Dévotion | Yoon Hae-in | écrite | Sous Pacte avec Hae-in, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Simone<br>`refuge:simone_devotion` | Dévotion | Simone Hayes | écrite | Sous Pacte avec Simone, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Nadia<br>`refuge:nadia_devotion` | Dévotion | Nadia Tsoi | écrite | Sous Pacte avec Nadia, la traiter avec respect jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle choisit de rester, librement. |
| Dévotion — Aoi<br>`refuge:aoi_devotion` | Dévotion | Aoi Tsukishiro | écrite | Racheter Aoi à Mirae (Acte II), puis, soir après soir au Refuge, lui répondre « Fais ce que tu veux » jusqu'à ce que l'ambivalence atteigne +60 et l'Affinité 70 : elle déchire le contrat elle-même. |
| Nuit du Loup — Seo-Yeon<br>`refuge:seo_loup` | Loup | Park Seo-Yeon | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Seo-Yeon ≥ 25, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Haneul<br>`refuge:haneul_loup` | Loup | Haneul (l'Héritière) | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Haneul ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Aoi<br>`refuge:aoi_loup` | Loup | Aoi Tsukishiro | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Aoi ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Maricel<br>`refuge:maricel_loup` | Loup | Maricel Dizon | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Maricel ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Ryeon<br>`refuge:ryeon_loup` | Loup | Baek Ryeon | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Ryeon ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Xiaoyu<br>`refuge:xiaoyu_loup` | Loup | Long Xiaoyu | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Xiaoyu ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Hae-in<br>`refuge:haein_loup` | Loup | Yoon Hae-in | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Hae-in ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Nadia<br>`refuge:nadia_loup` | Loup | Nadia Tsoi | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Nadia ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Simone<br>`refuge:simone_loup` | Loup | Simone Hayes | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Simone ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |
| Nuit du Loup — Minh-Anh<br>`refuge:minh_anh_loup` | Loup | Dr. Tran Minh-Anh | amorce | Voie du Loup (Lien ≤ −20 : s'isoler, refuser l'aide ; ni Héros ni Tyran) : Affinité de Minh-Anh ≥ 20, s'être déjà reposé au Refuge avec elle, Dortoir construit. |

### Duos (45)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Lame et Lunette : Ryeon et Nadia<br>`refuge_groupe:paire_ryeon_nadia` | Groupe | Baek Ryeon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Feu Croisé : Simone et Nadia<br>`refuge_groupe:paire_simone_nadia` | Groupe | Simone Hayes, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| OPA Hostile : Hae-in et Xiaoyu<br>`refuge_groupe:paire_hae_in_xiaoyu` | Groupe | Yoon Hae-in, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Sérum H-07 : Seo-Yeon et Minh-Anh<br>`refuge_groupe:paire_seo_yeon_minh_anh` | Groupe | Park Seo-Yeon, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Contrebande : Maricel et Xiaoyu<br>`refuge_groupe:paire_maricel_xiaoyu` | Groupe | Maricel Dizon, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Équation du Seuil : Minh-Anh et Haneul<br>`refuge_groupe:paire_minh_anh_haneul` | Groupe | Dr. Tran Minh-Anh, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Minh-Anh et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Avant-Garde : Simone et Ryeon<br>`refuge_groupe:paire_simone_ryeon` | Groupe | Simone Hayes, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Hymne du Seuil : Aoi et Haneul<br>`refuge_groupe:paire_aoi_haneul` | Groupe | Aoi Tsukishiro, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Loi Martiale : Hae-in et Simone<br>`refuge_groupe:paire_hae_in_simone` | Groupe | Yoon Hae-in, Simone Hayes | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Ballade du Triage : Seo-Yeon et Aoi<br>`refuge_groupe:paire_seo_yeon_aoi` | Groupe | Park Seo-Yeon, Aoi Tsukishiro | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Aoi, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Leçon d'anatomie, deuxième partie : Seo-Yeon et Haneul<br>`refuge_groupe:paire_seo_yeon_haneul` | Groupe | Park Seo-Yeon, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Contrebande médicale : Seo-Yeon et Maricel<br>`refuge_groupe:paire_seo_yeon_maricel` | Groupe | Park Seo-Yeon, Maricel Dizon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Maricel, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Garde de nuit : Seo-Yeon et Ryeon<br>`refuge_groupe:paire_seo_yeon_ryeon` | Groupe | Park Seo-Yeon, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Ordonnance de luxe : Seo-Yeon et Xiaoyu<br>`refuge_groupe:paire_seo_yeon_xiaoyu` | Groupe | Park Seo-Yeon, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Bilan de santé : Seo-Yeon et Hae-in<br>`refuge_groupe:paire_seo_yeon_hae_in` | Groupe | Park Seo-Yeon, Yoon Hae-in | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Point de suture : Seo-Yeon et Nadia<br>`refuge_groupe:paire_seo_yeon_nadia` | Groupe | Park Seo-Yeon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Visite réglementaire : Seo-Yeon et Simone<br>`refuge_groupe:paire_seo_yeon_simone` | Groupe | Park Seo-Yeon, Simone Hayes | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| La porte et les tunnels : Haneul et Maricel<br>`refuge_groupe:paire_haneul_maricel` | Groupe | Haneul (l'Héritière), Maricel Dizon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Maricel, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Deux héritières : Haneul et Ryeon<br>`refuge_groupe:paire_haneul_ryeon` | Groupe | Haneul (l'Héritière), Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Le pari de l'Héritière : Haneul et Xiaoyu<br>`refuge_groupe:paire_haneul_xiaoyu` | Groupe | Haneul (l'Héritière), Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Audit : Haneul et Hae-in<br>`refuge_groupe:paire_haneul_hae_in` | Groupe | Haneul (l'Héritière), Yoon Hae-in | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| La lunette et le Registre : Haneul et Nadia<br>`refuge_groupe:paire_haneul_nadia` | Groupe | Haneul (l'Héritière), Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Briefing : Haneul et Simone<br>`refuge_groupe:paire_haneul_simone` | Groupe | Haneul (l'Héritière), Simone Hayes | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Après le karaoké : Aoi et Maricel<br>`refuge_groupe:paire_aoi_maricel` | Groupe | Aoi Tsukishiro, Maricel Dizon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Maricel, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Le ruban et la scène : Aoi et Ryeon<br>`refuge_groupe:paire_aoi_ryeon` | Groupe | Aoi Tsukishiro, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Contrat d'artiste : Aoi et Xiaoyu<br>`refuge_groupe:paire_aoi_xiaoyu` | Groupe | Aoi Tsukishiro, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Sans caméra : Aoi et Hae-in<br>`refuge_groupe:paire_aoi_hae_in` | Groupe | Aoi Tsukishiro, Yoon Hae-in | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Silence radio : Aoi et Nadia<br>`refuge_groupe:paire_aoi_nadia` | Groupe | Aoi Tsukishiro, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Permission : Aoi et Simone<br>`refuge_groupe:paire_aoi_simone` | Groupe | Aoi Tsukishiro, Simone Hayes | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Fréquences : Aoi et Minh-Anh<br>`refuge_groupe:paire_aoi_minh_anh` | Groupe | Aoi Tsukishiro, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Le couteau et le sabre : Maricel et Ryeon<br>`refuge_groupe:paire_maricel_ryeon` | Groupe | Maricel Dizon, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Redistribution : Maricel et Hae-in<br>`refuge_groupe:paire_maricel_hae_in` | Groupe | Maricel Dizon, Yoon Hae-in | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les oubliées : Maricel et Nadia<br>`refuge_groupe:paire_maricel_nadia` | Groupe | Maricel Dizon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Reddition : Maricel et Simone<br>`refuge_groupe:paire_maricel_simone` | Groupe | Maricel Dizon, Simone Hayes | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Échantillons : Maricel et Minh-Anh<br>`refuge_groupe:paire_maricel_minh_anh` | Groupe | Maricel Dizon, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Maricel et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Alliance des Maisons : Ryeon et Xiaoyu<br>`refuge_groupe:paire_ryeon_xiaoyu` | Groupe | Baek Ryeon, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Revanche : Ryeon et Hae-in<br>`refuge_groupe:paire_ryeon_hae_in` | Groupe | Baek Ryeon, Yoon Hae-in | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Hae-in, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Expérience de contrôle : Ryeon et Minh-Anh<br>`refuge_groupe:paire_ryeon_minh_anh` | Groupe | Baek Ryeon, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Contrat rompu : Xiaoyu et Nadia<br>`refuge_groupe:paire_xiaoyu_nadia` | Groupe | Long Xiaoyu, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Cessez-le-feu : Xiaoyu et Simone<br>`refuge_groupe:paire_xiaoyu_simone` | Groupe | Long Xiaoyu, Simone Hayes | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu et Simone, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Inspection : Xiaoyu et Minh-Anh<br>`refuge_groupe:paire_xiaoyu_minh_anh` | Groupe | Long Xiaoyu, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Garde rapprochée : Hae-in et Nadia<br>`refuge_groupe:paire_hae_in_nadia` | Groupe | Yoon Hae-in, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Contrat de travail : Hae-in et Minh-Anh<br>`refuge_groupe:paire_hae_in_minh_anh` | Groupe | Yoon Hae-in, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Balistique : Nadia et Minh-Anh<br>`refuge_groupe:paire_nadia_minh_anh` | Groupe | Nadia Tsoi, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Nadia et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Le Silo, la nuit : Simone et Minh-Anh<br>`refuge_groupe:paire_simone_minh_anh` | Groupe | Simone Hayes, Dr. Tran Minh-Anh | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone et Minh-Anh, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |

### Trios (10)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| La Nuit des Trois : Seo-Yeon, Aoi et Maricel<br>`refuge_groupe:nuit_des_trois` | Groupe | Park Seo-Yeon, Aoi Tsukishiro, Maricel Dizon | écrite | Affinité ≥ 20 avec Seo-Yeon, Aoi et Maricel, les trois dans le groupe, Dortoir construit. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Trois Lames<br>`refuge_groupe:trio_trois_lames` | Groupe | Baek Ryeon, Simone Hayes, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Ryeon, Simone et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Reines<br>`refuge_groupe:trio_reines` | Groupe | Yoon Hae-in, Long Xiaoyu, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in, Xiaoyu et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Invisibles<br>`refuge_groupe:trio_invisibles` | Groupe | Aoi Tsukishiro, Maricel Dizon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi, Maricel et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Filles du Fleuve<br>`refuge_groupe:trio_filles_fleuve` | Groupe | Long Xiaoyu, Maricel Dizon, Nadia Tsoi | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Xiaoyu, Maricel et Nadia, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Le Laboratoire<br>`refuge_groupe:trio_laboratoire` | Groupe | Dr. Tran Minh-Anh, Park Seo-Yeon, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Minh-Anh, Seo-Yeon et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Sceptres<br>`refuge_groupe:trio_sceptres` | Groupe | Yoon Hae-in, Dr. Tran Minh-Anh, Long Xiaoyu | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Hae-in, Minh-Anh et Xiaoyu, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Gardiennes du Seuil<br>`refuge_groupe:trio_gardiennes` | Groupe | Haneul (l'Héritière), Baek Ryeon, Aoi Tsukishiro | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Haneul, Ryeon et Aoi, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| La Garde de Fer<br>`refuge_groupe:trio_garde_fer` | Groupe | Simone Hayes, Baek Ryeon, Park Seo-Yeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone, Ryeon et Seo-Yeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Trois Vérités<br>`refuge_groupe:trio_trois_verites` | Groupe | Park Seo-Yeon, Yoon Hae-in, Haneul (l'Héritière) | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Seo-Yeon, Hae-in et Haneul, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge — seulement à partir de la deuxième récurrence. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |

### Quatuors (3)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Les Reines et les Lames<br>`refuge_groupe:reines_lames` | Groupe | Yoon Hae-in, Long Xiaoyu, Baek Ryeon, Simone Hayes | écrite | Affinité ≥ 20 avec Hae-in, Xiaoyu, Ryeon et Simone, toutes dans le groupe, et avoir réconcilié les Reines au Mahjong (scène du Refuge). Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Les Quatre Fins<br>`refuge_groupe:quatuor_quatre_fins` | Groupe | Aoi Tsukishiro, Park Seo-Yeon, Maricel Dizon, Baek Ryeon | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Aoi, Seo-Yeon, Maricel et Ryeon, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge, à partir du jour 18. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |
| Loin de chez soi<br>`refuge_groupe:quatuor_loin_de_chez_soi` | Groupe | Simone Hayes, Nadia Tsoi, Maricel Dizon, Aoi Tsukishiro | amorce | Avoir passé une nuit (Lien, Ombre, Mercenaire ou Dévotion) avec Simone, Nadia, Maricel et Aoi, Affinité ≥ 50 pour chacune, Dortoir construit, toutes dans le groupe ; la scène est alors proposée au Refuge. Une héroïne encore sous contrat imposé joue une variante sans intimité : qu'elle le renégocie d'abord. |

### Constellations (5 à 9) (5)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| La Constellation de cinq<br>`refuge_groupe:constellation_cinq` | Groupe | — | amorce | Cinq héroïnes du groupe à Affinité ≥ 50, Dortoir construit. Les héroïnes sous contrat imposé ne comptent pas (elles ne sont pas là ce soir). |
| La Nuit de la Maison (six)<br>`refuge_groupe:nuit_maison` | Groupe | — | écrite | Six héroïnes du groupe à Affinité ≥ 30, Dortoir construit. Les héroïnes sous contrat imposé ne comptent pas (elles ne sont pas là ce soir). |
| La Constellation de sept<br>`refuge_groupe:constellation_sept` | Groupe | — | amorce | Sept héroïnes du groupe à Affinité ≥ 55, Dortoir construit. Les héroïnes sous contrat imposé ne comptent pas (elles ne sont pas là ce soir). |
| La Constellation de huit<br>`refuge_groupe:constellation_huit` | Groupe | — | amorce | Huit héroïnes du groupe à Affinité ≥ 60, Dortoir construit. Les héroïnes sous contrat imposé ne comptent pas (elles ne sont pas là ce soir). |
| La Constellation de neuf<br>`refuge_groupe:constellation_neuf` | Groupe | — | amorce | Neuf héroïnes du groupe à Affinité ≥ 65, Dortoir construit. Les héroïnes sous contrat imposé ne comptent pas (elles ne sont pas là ce soir). |

### Harem (4)

| Scène | Voie | Personnages | Statut | Déblocage (indice affiché) |
|---|---|---|---|---|
| Le Portrait des Dix<br>`refuge_groupe:portrait_dix` | Groupe | — | écrite | Les dix héroïnes dans le groupe, toutes à Affinité ≥ 30. Si l'une porte encore un contrat imposé, seul le portrait est pris, sans la nuit. |
| L'Aube des Dix<br>`act4_finale:aube_dix` | Affinités (Lien) | — | amorce | Nuit du Déversement : terminer la boucle avec dix héroïnes dans le groupe à Affinité ≥ 30, aucune sous contrat imposé, sans être Tyran (Fin du Harem Absolu, « La Maison des Dix »). |
| Le Contrat collectif<br>`refuge_groupe:harem_mercenaire` | Mercenaire | — | amorce | Voie du Mercenaire (400 ₩ en poche) avec six héroïnes du groupe à Affinité ≥ 50, Dortoir construit. Les héroïnes sous contrat imposé ne comptent pas (elles ne sont pas là ce soir). |
| La Cour de l'Ombre<br>`refuge_groupe:harem_ombre` | Tyran (Ombre) | — | amorce | Voie du Tyran (Protéger ≤ −20) avec au moins six héroïnes du groupe à Affinité ≥ 50, libres ou sous contrat renégocié (celles sous contrat imposé n'y sont pas), Dortoir construit. |

## À mettre en place (0 emplacements prévus)

Aucun : chaque emplacement de la galerie se déclenche en jeu (le validateur refuse le statut « prevue »).


## Amorces à compléter (93)

Le début se joue et débloque l'emplacement ; le texte s'arrête avant la suite (palier P3 vide, CG à créer pour les scènes de groupe).

- Seconde nuit — Seo-Yeon — `refuge:seo_nuit2`
- Seconde nuit — Haneul — `refuge:haneul_nuit2`
- Seconde nuit — Aoi — `refuge:aoi_nuit2`
- Seconde nuit — Maricel — `refuge:maricel_nuit2`
- Seconde nuit — Ryeon — `refuge:ryeon_nuit2`
- Seconde nuit — Xiaoyu — `refuge:xiaoyu_nuit2`
- Seconde nuit — Hae-in — `refuge:haein_nuit2`
- Seconde nuit — Nadia — `refuge:nadia_nuit2`
- Seconde nuit — Simone — `refuge:simone_nuit2`
- Seconde nuit — Minh-Anh — `refuge:minh_anh_nuit2`
- Écho — Seo-Yeon — `refuge:seo_yeon_echo`
- Écho — Haneul — `refuge:haneul_echo`
- Écho — Aoi — `refuge:aoi_echo`
- Écho — Maricel — `refuge:maricel_echo`
- Écho — Ryeon — `refuge:ryeon_echo`
- Écho — Xiaoyu — `refuge:xiaoyu_echo`
- Écho — Hae-in — `refuge:hae_in_echo`
- Écho — Nadia — `refuge:nadia_echo`
- Écho — Simone — `refuge:simone_echo`
- Écho — Minh-Anh — `refuge:minh_anh_echo`
- Nuit du Loup — Seo-Yeon — `refuge:seo_loup`
- Nuit du Loup — Haneul — `refuge:haneul_loup`
- Nuit du Loup — Aoi — `refuge:aoi_loup`
- Nuit du Loup — Maricel — `refuge:maricel_loup`
- Nuit du Loup — Ryeon — `refuge:ryeon_loup`
- Nuit du Loup — Xiaoyu — `refuge:xiaoyu_loup`
- Nuit du Loup — Hae-in — `refuge:haein_loup`
- Nuit du Loup — Nadia — `refuge:nadia_loup`
- Nuit du Loup — Simone — `refuge:simone_loup`
- Nuit du Loup — Minh-Anh — `refuge:minh_anh_loup`
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
- Leçon d'anatomie, deuxième partie : Seo-Yeon et Haneul — `refuge_groupe:paire_seo_yeon_haneul`
- Contrebande médicale : Seo-Yeon et Maricel — `refuge_groupe:paire_seo_yeon_maricel`
- Garde de nuit : Seo-Yeon et Ryeon — `refuge_groupe:paire_seo_yeon_ryeon`
- Ordonnance de luxe : Seo-Yeon et Xiaoyu — `refuge_groupe:paire_seo_yeon_xiaoyu`
- Bilan de santé : Seo-Yeon et Hae-in — `refuge_groupe:paire_seo_yeon_hae_in`
- Point de suture : Seo-Yeon et Nadia — `refuge_groupe:paire_seo_yeon_nadia`
- Visite réglementaire : Seo-Yeon et Simone — `refuge_groupe:paire_seo_yeon_simone`
- La porte et les tunnels : Haneul et Maricel — `refuge_groupe:paire_haneul_maricel`
- Deux héritières : Haneul et Ryeon — `refuge_groupe:paire_haneul_ryeon`
- Le pari de l'Héritière : Haneul et Xiaoyu — `refuge_groupe:paire_haneul_xiaoyu`
- Audit : Haneul et Hae-in — `refuge_groupe:paire_haneul_hae_in`
- La lunette et le Registre : Haneul et Nadia — `refuge_groupe:paire_haneul_nadia`
- Briefing : Haneul et Simone — `refuge_groupe:paire_haneul_simone`
- Après le karaoké : Aoi et Maricel — `refuge_groupe:paire_aoi_maricel`
- Le ruban et la scène : Aoi et Ryeon — `refuge_groupe:paire_aoi_ryeon`
- Contrat d'artiste : Aoi et Xiaoyu — `refuge_groupe:paire_aoi_xiaoyu`
- Sans caméra : Aoi et Hae-in — `refuge_groupe:paire_aoi_hae_in`
- Silence radio : Aoi et Nadia — `refuge_groupe:paire_aoi_nadia`
- Permission : Aoi et Simone — `refuge_groupe:paire_aoi_simone`
- Fréquences : Aoi et Minh-Anh — `refuge_groupe:paire_aoi_minh_anh`
- Le couteau et le sabre : Maricel et Ryeon — `refuge_groupe:paire_maricel_ryeon`
- Redistribution : Maricel et Hae-in — `refuge_groupe:paire_maricel_hae_in`
- Les oubliées : Maricel et Nadia — `refuge_groupe:paire_maricel_nadia`
- Reddition : Maricel et Simone — `refuge_groupe:paire_maricel_simone`
- Échantillons : Maricel et Minh-Anh — `refuge_groupe:paire_maricel_minh_anh`
- Alliance des Maisons : Ryeon et Xiaoyu — `refuge_groupe:paire_ryeon_xiaoyu`
- Revanche : Ryeon et Hae-in — `refuge_groupe:paire_ryeon_hae_in`
- Expérience de contrôle : Ryeon et Minh-Anh — `refuge_groupe:paire_ryeon_minh_anh`
- Contrat rompu : Xiaoyu et Nadia — `refuge_groupe:paire_xiaoyu_nadia`
- Cessez-le-feu : Xiaoyu et Simone — `refuge_groupe:paire_xiaoyu_simone`
- Inspection : Xiaoyu et Minh-Anh — `refuge_groupe:paire_xiaoyu_minh_anh`
- Garde rapprochée : Hae-in et Nadia — `refuge_groupe:paire_hae_in_nadia`
- Contrat de travail : Hae-in et Minh-Anh — `refuge_groupe:paire_hae_in_minh_anh`
- Balistique : Nadia et Minh-Anh — `refuge_groupe:paire_nadia_minh_anh`
- Le Silo, la nuit : Simone et Minh-Anh — `refuge_groupe:paire_simone_minh_anh`
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
- La Constellation de sept — `refuge_groupe:constellation_sept`
- La Constellation de huit — `refuge_groupe:constellation_huit`
- La Constellation de neuf — `refuge_groupe:constellation_neuf`
- L'Aube des Dix — `act4_finale:aube_dix`
- Le Contrat collectif — `refuge_groupe:harem_mercenaire`
- La Cour de l'Ombre — `refuge_groupe:harem_ombre`
