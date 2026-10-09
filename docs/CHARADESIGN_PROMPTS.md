# CHARADESIGN & PROMPTS — La Tour du Dernier Jour

> Fichier **généré** par `tools/art_pipeline/build_prompt_doc.py` depuis `data/art/prompts.json`.
> Pour modifier un prompt, éditer le JSON puis relancer le script : le pipeline d'images lit la même source.

## 1. Direction artistique

Manhwa semi-réaliste mature (référence : Solo Leveling, Omniscient Reader's Viewpoint). Encrage net, ombrages durs et profonds, rim light marqué, contrastes cinématographiques, néons cyan et magenta sur fonds sombres, ambiance SF et dark fantasy. Proportions adultes réalistes. Morphologies strictement fidèles aux fiches (Hae-in très plantureuse et mûre, Simone musclée, Maricel pulpeuse, Aoi fine et élancée…). Fanservice assumé : tenues de nuit, angles dynamiques, cadrages cinématiques, expressions suggestives.

**Bloc de style (à ajouter à chaque prompt)** :
```
semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Négatif (SDXL ; Flux n'en utilise pas)** :
```
chibi, childlike, young-looking, loli, school uniform, deformed hands, extra fingers, extra limbs, fused fingers, blurry, lowres, jpeg artifacts, watermark, text, signature, logo, 3d render, photo, flat colors, pastel kawaii style, oversaturated, cropped head, duplicate character
```
**Paramètres** :
- Flux (pipeline cloud) : `{"image_size": "portrait_4_3", "num_inference_steps": 28, "guidance_scale": 3.5}`
- SDXL (option) : `{"width": 832, "height": 1216, "steps": 30, "cfg": 6.0, "sampler": "dpmpp_2m_sde_karras"}`
- Midjourney (exploration manuelle) : `--ar 2:3 --style raw --stylize 150` + `--cref <url de la planche validée>`

## 2. Ajustements capillaires retenus

- Seo-Yeon : châtain → **auburn cuivré délavé** (teinture qui passe, racines plus sombres). Elle se distingue des nombreuses chevelures noires et gagne en chaleur, ce qui colle à son rôle de soignante.
- Xiaoyu : la mèche rouge s'étend à **tout le carré, en rouge carmin profond** avec des racines noires laquées. Silhouette immédiatement lisible, signature femme fatale de la pègre.
- Maricel : mèches cuivre → **balayage blond miel chaud** sur racines brunes. Contraste solaire avec sa peau dorée et sa tenue moutarde.
- Les autres héroïnes restent inchangées : noir (Hae-in, Ryeon, Simone, Minh-Anh), noir et rose (Aoi), platine (Nadia), argent (Haneul).

## 3. Lisibilité du casting (silhouette et couleur dominante)

| Personnage | Token | Taille / poids | Palette |
|---|---|---|---|
| Elias Kang | `elias_kang` | 184 cm / 86 kg | `#111111` `#3a3a3a` `#d4651e` `#e8b23a` |
| Park Seo-Yeon | `seoyeon_park` | 163 cm / 52 kg | `#9ccbe8` `#e8dcc4` `#f5f2ea` `#b5532a` |
| Yoon Hae-in | `haein_yoon` | 172 cm / 58 kg | `#f4f1ea` `#c19a6b` `#6d1a2a` `#3f8f6b` |
| Baek Ryeon | `ryeon_baek` | 168 cm / 55 kg | `#0d0d0d` `#f2f2f2` `#d62828` `#b8c2cc` |
| Simone Hayes | `simone_hayes` | 178 cm / 72 kg | `#5b5f3a` `#2b2b2b` `#c9a227` `#b03a2e` |
| Long Xiaoyu | `xiaoyu_long` | 170 cm / 54 kg | `#0b0b0b` `#c9a227` `#a3122a` `#3f8f6b` |
| Aoi Tsukishiro | `aoi_tsukishiro` | 160 cm / 47 kg | `#f4b6c9` `#111111` `#ffffff` `#9aa0a6` |
| Nadia Tsoi | `nadia_tsoi` | 176 cm / 63 kg | `#4a5560` `#111111` `#e8e8e8` `#b3202a` |
| Maricel Dizon | `maricel_dizon` | 157 cm / 50 kg | `#d4a017` `#556b2f` `#e3b778` `#c9a227` |
| Dr. Tran Minh-Anh | `minhanh_tran` | 166 cm / 53 kg | `#f5f7fa` `#111111` `#2ec5ff` `#c0c6cc` |
| Haneul (l'Héritière) | `haneul_heiress` | 169 cm / 54 kg | `#f7f5f0` `#c0c6cc` `#e8b23a` `#1a1a1a` |

## 4. Gabarits de prompts

- **ref_sheet** : `character reference sheet of {core}, {body}, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing {outfit}, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout`
- **portrait** : `waist-up portrait of {core}, {body}, wearing {outfit}, three-quarter angle facing the viewer, {expression}, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite`
- **full_body** : `full body illustration of {core}, wearing {outfit}, dynamic but readable pose, dark ruined Seoul street at night with neon signs and the black Tower in the sky, cinematic lighting`
- **combat_sprite** : `full body combat stance of {core}, wearing {outfit}, {weapon}, side three-quarter view, dramatic action lighting, plain dark background for cut-out`
- **fanservice** : `{core}, {body}, wearing {outfit}, {pose}, {camera}, {expression}, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights`

**Angles de caméra** : low angle shot looking up · high angle shot looking down · over-the-shoulder shot · dutch angle · extreme close-up on the eyes · from behind, looking back at the viewer · cowboy shot · wide cinematic shot · close-up on the face and collarbone

**Expressions suggestives** : `teasing` (teasing smile, one eyebrow raised) · `bite_lip` (biting her lower lip, half-lidded eyes) · `shy` (flustered blush, looking away, hand near her mouth) · `smolder` (smoldering half-lidded gaze, lips slightly parted)

**Expressions communes** (remplacent `{expression}`) :

| Clé | Suffixe |
|---|---|
| `neutral` | neutral calm expression |
| `joy` | soft genuine smile |
| `laugh` | laughing openly |
| `anger` | angry glare, clenched jaw |
| `sad` | sad downcast eyes |
| `tears` | tears running down cheeks |
| `embarrassed` | flustered, deep blush |
| `surprise` | wide eyes, surprised |
| `fear` | frightened, trembling |
| `contempt` | cold contemptuous look |
| `desire` | half-lidded smoldering gaze, slight blush |
| `exhausted` | exhausted, dark circles, messy hair |
| `blink` | eyes closed, same pose and expression otherwise |

## 5. Fiches de prompts par personnage

### 5.1 Elias Kang — `elias_kang`

**Noyau d'identité (invariant, réutilisé partout)** :
```
elias_kang, 29-year-old handsome young mixed-race man with a Korean mother and a French-Martinican father, tall 184cm, broad shoulders, lean V-shaped muscular fighter build, warm caramel tan skin, handsome youthful face with sharp features, defined jawline with slightly cleft chin, high cheekbones, straight nose with a slightly wide tip, full lips with a one-sided ironic smile, clean-shaven, hooded almond hazel-amber eyes under thick straight brows, thick black hair of medium length, tousled and slightly spiky, soft loose waves, strands falling on the forehead and past the nape, vertical scar splitting the left eyebrow, burn scar on the right forearm, Korean handwritten tattoo on the inner left forearm, sleeves rolled up to the elbows
```
**Tenues** :

- `base` : long black tactical military greatcoat with a high collar, leather belts and buckles, black tactical vest, black gloves, black cargo pants, combat boots, sheathed tower-forged blade at the hip, broken military wristwatch
- `hero` : long pearl-grey high-collared coat, white armband, reinforced gloves, light chest plate
- `tyrant` : long black coat with high collar and shoulder plates, open black shirt, chain pendant with a glowing red seal, dark red leather gloves
- `wolf` : dark hood, half-face respirator mask, knife harness, bandaged hands
- `mercenary` : sand tactical jacket, magazine harness, bandana, shooting glasses pushed up on the forehead
- `casual` : black tank top, sweatpants, barefoot
- `night` : bare-chested, low-slung grey sweatpants, scars and tattoo visible
- `prologue` : worn black bomber jacket with orange lining, charcoal grey t-shirt, black tactical cargo pants, combat boots, broken military wristwatch

**Morphologie (à respecter strictement)** : tall athletic V-shaped muscular male body, broad chest, defined abs, veined forearms, scarred skin

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of elias_kang, 29-year-old handsome young mixed-race man with a Korean mother and a French-Martinican father, tall 184cm, broad shoulders, lean V-shaped muscular fighter build, warm caramel tan skin, handsome youthful face with sharp features, defined jawline with slightly cleft chin, high cheekbones, straight nose with a slightly wide tip, full lips with a one-sided ironic smile, clean-shaven, hooded almond hazel-amber eyes under thick straight brows, thick black hair of medium length, tousled and slightly spiky, soft loose waves, strands falling on the forehead and past the nape, vertical scar splitting the left eyebrow, burn scar on the right forearm, Korean handwritten tattoo on the inner left forearm, sleeves rolled up to the elbows, tall athletic V-shaped muscular male body, broad chest, defined abs, veined forearms, scarred skin, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing long black tactical military greatcoat with a high collar, leather belts and buckles, black tactical vest, black gloves, black cargo pants, combat boots, sheathed tower-forged blade at the hip, broken military wristwatch, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of elias_kang, tall athletic V-shaped muscular male body, broad chest, defined abs, veined forearms, scarred skin, wearing long black tactical military greatcoat with a high collar, leather belts and buckles, black tactical vest, black gloves, black cargo pants, combat boots, sheathed tower-forged blade at the hip, broken military wristwatch, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of elias_kang, wearing long black tactical military greatcoat with a high collar, leather belts and buckles, black tactical vest, black gloves, black cargo pants, combat boots, sheathed tower-forged blade at the hip, broken military wristwatch, combat knife in reverse grip and a heavy tower-forged blade, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : Registre activated: glowing pure gold irises with a slowly rotating clock ring around the pupils, golden glyphs running along the neck veins and hands, swirling luminous pages around him

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
elias_kang, tall athletic V-shaped muscular male body, broad chest, defined abs, veined forearms, scarred skin, wearing bare-chested, low-slung grey sweatpants, scars and tattoo visible, leaning against a doorframe, arms crossed, smirking at the viewer, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
elias_kang, tall athletic V-shaped muscular male body, broad chest, defined abs, veined forearms, scarred skin, wearing bare-chested, low-slung grey sweatpants, scars and tattoo visible, sitting on the edge of a bed at night, elbows on knees, neon light through the blinds, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `smirk` (one-sided ironic smirk, eyes half-lidded)

**Checklist de cohérence** : Cicatrice au sourcil GAUCHE · Cheveux noirs mi-longs, souples, un peu en pique, qui dépassent sur la nuque (ni lisses, ni longs) · Peau caramel métisse, pas pâle · Visage jeune et beau, calme au repos ; imberbe (ni barbe, ni barbe naissante) · Long manteau noir tactique (le bomber est donné à Haneul à l'Acte I) · Montre cassée à 23h58 · Tatouage avant-bras GAUCHE

### 5.2 Park Seo-Yeon — `seoyeon_park`

**Noyau d'identité (invariant, réutilisé partout)** :
```
seoyeon_park, 27-year-old Korean woman, petite slender build 163cm, soft round face, small upturned nose, thin naturally pink lips, large round warm chocolate-brown eyes with dark circles, thin round gold-rimmed glasses repaired with white tape on the left temple, shoulder-blade-length straight auburn hair in a faded copper-red dye with darker roots, worn in a messy bun held by a pencil with loose strands framing her face, small beauty mark at the corner of the right eye, chapped hands with very short nails, red braided fabric bracelet, fair rosy skin
```
**Tenues** :

- `base` : stained light-blue medical scrubs under an oversized beige cardigan, worn white sneakers, stethoscope around the neck
- `combat` : orange rescue vest with many pockets, red-cross armband, medical satchel, surgical gloves
- `casual` : oversized knit sweater, hair let down, no glasses
- `night` : oversized men's shirt half-buttoned, bare legs, glasses off, auburn hair let down

**Morphologie (à respecter strictement)** : petite slender body, narrow shoulders, slim waist, modest medium bust, soft hips

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of seoyeon_park, 27-year-old Korean woman, petite slender build 163cm, soft round face, small upturned nose, thin naturally pink lips, large round warm chocolate-brown eyes with dark circles, thin round gold-rimmed glasses repaired with white tape on the left temple, shoulder-blade-length straight auburn hair in a faded copper-red dye with darker roots, worn in a messy bun held by a pencil with loose strands framing her face, small beauty mark at the corner of the right eye, chapped hands with very short nails, red braided fabric bracelet, fair rosy skin, petite slender body, narrow shoulders, slim waist, modest medium bust, soft hips, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing stained light-blue medical scrubs under an oversized beige cardigan, worn white sneakers, stethoscope around the neck, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of seoyeon_park, petite slender body, narrow shoulders, slim waist, modest medium bust, soft hips, wearing stained light-blue medical scrubs under an oversized beige cardigan, worn white sneakers, stethoscope around the neck, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of seoyeon_park, wearing orange rescue vest with many pockets, red-cross armband, medical satchel, surgical gloves, medical satchel and a glowing surgical scalpel, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : hands glowing with soft white healing light, blood-stained sleeves

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
seoyeon_park, petite slender body, narrow shoulders, slim waist, modest medium bust, soft hips, wearing oversized men's shirt half-buttoned, bare legs, glasses off, auburn hair let down, stretching her back after a long shift, shirt riding up, sleepy smile, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
seoyeon_park, petite slender body, narrow shoulders, slim waist, modest medium bust, soft hips, wearing oversized men's shirt half-buttoned, bare legs, glasses off, auburn hair let down, sitting on a hospital bed hugging her knees, shy glance at the viewer, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `lie` (pushing her glasses up with one finger, avoiding eye contact)

**Checklist de cohérence** : Lunettes rondes scotchées à GAUCHE · Auburn cuivré, racines sombres · Grain de beauté œil DROIT · Bracelet tressé rouge

### 5.3 Yoon Hae-in — `haein_yoon`

**Noyau d'identité (invariant, réutilisé partout)** :
```
haein_yoon, 41-year-old Korean woman, tall elegant mature hourglass figure 172cm, aristocratic oval face, high sculpted cheekbones, full lips with dark burgundy lipstick, beauty mark under the left side of the lower lip, long almond-shaped ink-black eyes with subtle winged eyeliner, long straight jet-black hair in a strict low chignon with a side part, a single silver streak at the left temple, imperial jade drop earrings, flawless porcelain skin with faint laugh lines, cold appraising gaze
```
**Tenues** :

- `base` : tailored white haute couture pantsuit, silk blouse, camel coat draped over the shoulders without using the sleeves, nude stiletto heels, rose-gold watch
- `combat` : reinforced white suit with a black trench coat lined with glowing red contract runes, white gloves
- `casual` : burgundy silk robe, long hair let down, glass of red wine
- `night` : black lace lingerie under an open burgundy silk robe, sheer black stockings, hair let down

**Morphologie (à respecter strictement)** : voluptuous mature hourglass body, very large full bust, tiny cinched waist, wide hips, long shapely legs

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of haein_yoon, 41-year-old Korean woman, tall elegant mature hourglass figure 172cm, aristocratic oval face, high sculpted cheekbones, full lips with dark burgundy lipstick, beauty mark under the left side of the lower lip, long almond-shaped ink-black eyes with subtle winged eyeliner, long straight jet-black hair in a strict low chignon with a side part, a single silver streak at the left temple, imperial jade drop earrings, flawless porcelain skin with faint laugh lines, cold appraising gaze, voluptuous mature hourglass body, very large full bust, tiny cinched waist, wide hips, long shapely legs, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing tailored white haute couture pantsuit, silk blouse, camel coat draped over the shoulders without using the sleeves, nude stiletto heels, rose-gold watch, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of haein_yoon, voluptuous mature hourglass body, very large full bust, tiny cinched waist, wide hips, long shapely legs, wearing tailored white haute couture pantsuit, silk blouse, camel coat draped over the shoulders without using the sleeves, nude stiletto heels, rose-gold watch, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of haein_yoon, wearing reinforced white suit with a black trench coat lined with glowing red contract runes, white gloves, floating glowing contract scrolls, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : golden contract chains materializing around her, an executive tower office overlooking ruined Seoul at night

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
haein_yoon, voluptuous mature hourglass body, very large full bust, tiny cinched waist, wide hips, long shapely legs, wearing black lace lingerie under an open burgundy silk robe, sheer black stockings, hair let down, sitting on the edge of her executive desk with legs crossed, leaning back on one hand, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
haein_yoon, voluptuous mature hourglass body, very large full bust, tiny cinched waist, wide hips, long shapely legs, wearing black lace lingerie under an open burgundy silk robe, sheer black stockings, hair let down, standing at the panoramic window at night, robe slipping off one shoulder, looking back over her shoulder, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `threat` (lowered chin, faint cold smile, one eyebrow raised)

**Checklist de cohérence** : Mèche argentée tempe GAUCHE · Manteau sur les épaules, manches vides · Jade aux oreilles · Grain de beauté sous la lèvre (gauche)

### 5.4 Baek Ryeon — `ryeon_baek`

**Noyau d'identité (invariant, réutilisé partout)** :
```
ryeon_baek, 23-year-old Korean woman, athletic slender swordswoman build 168cm, long toned legs, noble severe oval face, thin straight eyebrows slightly frowning, steel-grey eyes, very long straight blue-black hair in a high ponytail reaching her knees tied with a red ribbon, wispy bangs and two long face-framing strands, thin scar on the left collarbone, calloused hands, fair skin with a light tan on the forearms, perfect upright posture
```
**Tenues** :

- `base` : modernized black-and-white combat hanbok with a short fitted jeogori and wide trousers tied at the ankles, red sash belt, long sword at the hip
- `combat` : white lacquered leather armor pieces over the hanbok, white tiger half-mask
- `casual` : light hot-spring yukata, hair let down, visibly embarrassed
- `wedding` : red and gold traditional wedding hanbok with a ceremonial headpiece
- `night` : loosely tied white sleeping yukata slipping off one shoulder, very long hair untied, red ribbon around the wrist

**Morphologie (à respecter strictement)** : athletic toned swordswoman body, small firm bust, flat toned stomach, long muscular legs

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of ryeon_baek, 23-year-old Korean woman, athletic slender swordswoman build 168cm, long toned legs, noble severe oval face, thin straight eyebrows slightly frowning, steel-grey eyes, very long straight blue-black hair in a high ponytail reaching her knees tied with a red ribbon, wispy bangs and two long face-framing strands, thin scar on the left collarbone, calloused hands, fair skin with a light tan on the forearms, perfect upright posture, athletic toned swordswoman body, small firm bust, flat toned stomach, long muscular legs, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing modernized black-and-white combat hanbok with a short fitted jeogori and wide trousers tied at the ankles, red sash belt, long sword at the hip, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of ryeon_baek, athletic toned swordswoman body, small firm bust, flat toned stomach, long muscular legs, wearing modernized black-and-white combat hanbok with a short fitted jeogori and wide trousers tied at the ankles, red sash belt, long sword at the hip, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of ryeon_baek, wearing white lacquered leather armor pieces over the hanbok, white tiger half-mask, long single-edged Korean sword with a white tiger guard, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : spectral white tiger aura behind her during a drawing slash

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
ryeon_baek, athletic toned swordswoman body, small firm bust, flat toned stomach, long muscular legs, wearing loosely tied white sleeping yukata slipping off one shoulder, very long hair untied, red ribbon around the wrist, kneeling in seiza by a hot spring, flustered, covering herself with a towel, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
ryeon_baek, athletic toned swordswoman body, small firm bust, flat toned stomach, long muscular legs, wearing loosely tied white sleeping yukata slipping off one shoulder, very long hair untied, red ribbon around the wrist, mid-sword-draw in a dynamic low stance, ponytail whipping, hanbok fluttering, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `tsundere` (arms crossed, head turned away, cheeks red)

**Checklist de cohérence** : Ruban ROUGE dans la queue de cheval · Yeux GRIS acier · Cicatrice clavicule GAUCHE · Queue de cheval jusqu'aux genoux

### 5.5 Simone Hayes — `simone_hayes`

**Noyau d'identité (invariant, réutilisé partout)** :
```
simone_hayes, 38-year-old African-American woman, powerful curvy muscular build 178cm, the tallest woman of the cast, very large heavy bust, broad shoulders, defined arms and visible abs, wide hips and thick thighs, mature commanding presence, deep dark-brown skin with a warm copper undertone, strong square jaw with a diagonal scar on the left jawline, high cheekbones, wide straight nose, full lips, piercing very dark eyes, tight black cornrows on top and on the right side with a shaved undercut on the left side, two military dog tags and an engagement ring on a chain around her neck, eagle unit tattoo on the right shoulder
```
**Tenues** :

- `base` : open officer command jacket with epaulettes over a cropped tactical top with a plunging neckline, bare midriff showing her abs and a small scar, utility belt with a thigh holster, multicam cargo pants, red beret, fingerless gloves, combat boots
- `combat` : light military exoskeleton over the fatigues, awakened assault rifle with glowing runes
- `casual` : khaki tank top, sweatpants, barefoot, hair unbound into a natural afro, cigar
- `night` : black sports bra and tight boxer briefs, dog tags on bare skin, hair unbound into an afro

**Morphologie (à respecter strictement)** : powerful muscular body, broad shoulders, muscular arms, six-pack abs, full firm bust, thick strong thighs

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of simone_hayes, 38-year-old African-American woman, powerful curvy muscular build 178cm, the tallest woman of the cast, very large heavy bust, broad shoulders, defined arms and visible abs, wide hips and thick thighs, mature commanding presence, deep dark-brown skin with a warm copper undertone, strong square jaw with a diagonal scar on the left jawline, high cheekbones, wide straight nose, full lips, piercing very dark eyes, tight black cornrows on top and on the right side with a shaved undercut on the left side, two military dog tags and an engagement ring on a chain around her neck, eagle unit tattoo on the right shoulder, powerful muscular body, broad shoulders, muscular arms, six-pack abs, full firm bust, thick strong thighs, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing open officer command jacket with epaulettes over a cropped tactical top with a plunging neckline, bare midriff showing her abs and a small scar, utility belt with a thigh holster, multicam cargo pants, red beret, fingerless gloves, combat boots, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of simone_hayes, powerful muscular body, broad shoulders, muscular arms, six-pack abs, full firm bust, thick strong thighs, wearing open officer command jacket with epaulettes over a cropped tactical top with a plunging neckline, bare midriff showing her abs and a small scar, utility belt with a thigh holster, multicam cargo pants, red beret, fingerless gloves, combat boots, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of simone_hayes, wearing light military exoskeleton over the fatigues, awakened assault rifle with glowing runes, awakened assault rifle, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : commanding pose with tactical holographic map, artillery flares in the background

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
simone_hayes, powerful muscular body, broad shoulders, muscular arms, six-pack abs, full firm bust, thick strong thighs, wearing black sports bra and tight boxer briefs, dog tags on bare skin, hair unbound into an afro, doing pull-ups on a bar, sweat glistening, determined look, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
simone_hayes, powerful muscular body, broad shoulders, muscular arms, six-pack abs, full firm bust, thick strong thighs, wearing black sports bra and tight boxer briefs, dog tags on bare skin, hair unbound into an afro, sitting on an ammo crate with a cigar, tank top, relaxed confident grin, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `cigar` (rare tired smile with a lit cigar)

**Checklist de cohérence** : Cicatrice mâchoire GAUCHE · Undercut côté GAUCHE · Plaques et bague de fiançailles · Carrure puissante · Silhouette de commandante : la plus grande, poitrine imposante, ventre et abdos visibles

### 5.6 Long Xiaoyu — `xiaoyu_long`

**Noyau d'identité (invariant, réutilisé partout)** :
```
xiaoyu_long, 31-year-old Chinese woman, tall feline curvy figure 170cm, full bust, wasp waist, wide hips, long legs, mature sultry allure, heart-shaped face, cat-like upturned eyes with sharp black winged eyeliner, amber-gold irises, beauty mark under the left eye, carmine red lips with a teasing smirk, sleek chin-length blunt bob with straight-cut bangs dyed deep crimson red with glossy black roots, jade hairpin, long red lacquered nails, black and gold dragon tattoo across the back from the right shoulder to the left hip, pale ivory skin
```
**Tenues** :

- `base` : modern black qipao with a high slit embroidered with golden dragons, fitted black leather jacket, heeled ankle boots, black stockings, steel folding fan
- `combat` : same qipao, gauntlets with poison needles, belt of small vials, fan blades extended
- `casual` : red silk robe on a casino barge, mahjong tiles on the table
- `night` : red silk slip dress with thin straps and a thigh-high slit, barefoot, fan in hand

**Morphologie (à respecter strictement)** : slender feline body, wasp waist, medium perky bust, round hips, very long slender legs

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of xiaoyu_long, 31-year-old Chinese woman, tall feline curvy figure 170cm, full bust, wasp waist, wide hips, long legs, mature sultry allure, heart-shaped face, cat-like upturned eyes with sharp black winged eyeliner, amber-gold irises, beauty mark under the left eye, carmine red lips with a teasing smirk, sleek chin-length blunt bob with straight-cut bangs dyed deep crimson red with glossy black roots, jade hairpin, long red lacquered nails, black and gold dragon tattoo across the back from the right shoulder to the left hip, pale ivory skin, slender feline body, wasp waist, medium perky bust, round hips, very long slender legs, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing modern black qipao with a high slit embroidered with golden dragons, fitted black leather jacket, heeled ankle boots, black stockings, steel folding fan, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of xiaoyu_long, slender feline body, wasp waist, medium perky bust, round hips, very long slender legs, wearing modern black qipao with a high slit embroidered with golden dragons, fitted black leather jacket, heeled ankle boots, black stockings, steel folding fan, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of xiaoyu_long, wearing same qipao, gauntlets with poison needles, belt of small vials, fan blades extended, steel war fan with retractable blades, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : neon-lit floating casino barge on the black Han river, lanterns, smoke

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
xiaoyu_long, slender feline body, wasp waist, medium perky bust, round hips, very long slender legs, wearing red silk slip dress with thin straps and a thigh-high slit, barefoot, fan in hand, lounging on a mahjong table, fan hiding a smile, slit revealing a long leg, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
xiaoyu_long, slender feline body, wasp waist, medium perky bust, round hips, very long slender legs, wearing red silk slip dress with thin straps and a thigh-high slit, barefoot, fan in hand, leaning on a casino barge railing at night, back tattoo visible through an open-back qipao, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `fan` (hiding a laugh behind an open fan, eyes narrowed)

**Checklist de cohérence** : Carré ROUGE carmin, racines noires · Grain de beauté œil GAUCHE · Dragon dans le dos · Éventail d'acier

### 5.7 Aoi Tsukishiro — `aoi_tsukishiro`

**Noyau d'identité (invariant, réutilisé partout)** :
```
aoi_tsukishiro, 22-year-old Japanese woman with adult features, slim toned dancer build 160cm, small V-shaped face, large expressive hazel eyes with green flecks, heart-shaped lips, two-tone hair black on top and pastel pink underneath, chest-length, worn in low twin tails with black roots growing out, star stud in the left earlobe, colorful bandages on her fingers, tight bracelets on the left wrist, faint freckles on the nose, smudged glitter stage makeup
```
**Tenues** :

- `base` : white sleeveless high-collar zip-up top half-zipped, black bomber jacket with pink stripes slipping off the shoulders, glittery pink pleated miniskirt, black and pink striped over-the-knee socks, black combat boots with pink laces, tight bracelets on the left wrist
- `combat` : headset microphone turned into a sonic weapon, glowing stage ribbon
- `casual` : oversized grey hoodie, face mask pulled down, cap, denim shorts, sneakers
- `concert` : angelic white and gold stage dress
- `night` : oversized grey hoodie as her only garment, thigh-high socks, hair loose

**Morphologie (à respecter strictement)** : slim slender dancer body with adult proportions, small bust, narrow waist, long toned legs

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of aoi_tsukishiro, 22-year-old Japanese woman with adult features, slim toned dancer build 160cm, small V-shaped face, large expressive hazel eyes with green flecks, heart-shaped lips, two-tone hair black on top and pastel pink underneath, chest-length, worn in low twin tails with black roots growing out, star stud in the left earlobe, colorful bandages on her fingers, tight bracelets on the left wrist, faint freckles on the nose, smudged glitter stage makeup, slim slender dancer body with adult proportions, small bust, narrow waist, long toned legs, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing white sleeveless high-collar zip-up top half-zipped, black bomber jacket with pink stripes slipping off the shoulders, glittery pink pleated miniskirt, black and pink striped over-the-knee socks, black combat boots with pink laces, tight bracelets on the left wrist, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of aoi_tsukishiro, slim slender dancer body with adult proportions, small bust, narrow waist, long toned legs, wearing white sleeveless high-collar zip-up top half-zipped, black bomber jacket with pink stripes slipping off the shoulders, glittery pink pleated miniskirt, black and pink striped over-the-knee socks, black combat boots with pink laces, tight bracelets on the left wrist, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of aoi_tsukishiro, wearing headset microphone turned into a sonic weapon, glowing stage ribbon, headset microphone emitting visible sound waves, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : standing alone on a ruined concert stage under a single spotlight, crowd of silhouettes

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
aoi_tsukishiro, slim slender dancer body with adult proportions, small bust, narrow waist, long toned legs, wearing oversized grey hoodie as her only garment, thigh-high socks, hair loose, dancing alone on a ruined stage, hoodie flaring, spotlight, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
aoi_tsukishiro, slim slender dancer body with adult proportions, small bust, narrow waist, long toned legs, wearing oversized grey hoodie as her only garment, thigh-high socks, hair loose, curled up on a studio couch with headphones, looking up at the viewer, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `stage_smile` (perfect idol smile with empty eyes and no dimple) · `true_smile` (genuine laughing smile with a dimple on the right cheek)

**Checklist de cohérence** : Noir dessus / rose dessous · Bracelets serrés poignet GAUCHE · Fossette DROITE seulement en vrai sourire · Visage adulte (22 ans)

### 5.8 Nadia Tsoi — `nadia_tsoi`

**Noyau d'identité (invariant, réutilisé partout)** :
```
nadia_tsoi, 34-year-old Koryo-saram woman of Central Asian Korean descent, tall lean wiry build 176cm, angular face with very high prominent cheekbones, narrow straight nose, thin pale lips holding an unlit cigarette, narrow monolid almond eyes with pale grey almost silver irises, dark circles under the eyes, short platinum-white hair with a shaved undercut on the right side and the nape, long asymmetric fringe falling over the right eye, very pale cool-toned skin with visible veins at the temples
```
**Tenues** :

- `base` : long slate-grey military greatcoat, black turtleneck, combat trousers, fingerless gloves, faded red wool scarf
- `combat` : urban camouflage poncho, awakened anti-materiel sniper rifle with a white-glinting scope
- `casual` : oversized men's white shirt, bare legs, vodka bottle, vinyl record player
- `night` : unbuttoned oversized men's white shirt, black underwear, red scarf around the neck

**Morphologie (à respecter strictement)** : tall lean wiry body, small bust, sharp collarbones, long legs

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of nadia_tsoi, 34-year-old Koryo-saram woman of Central Asian Korean descent, tall lean wiry build 176cm, angular face with very high prominent cheekbones, narrow straight nose, thin pale lips holding an unlit cigarette, narrow monolid almond eyes with pale grey almost silver irises, dark circles under the eyes, short platinum-white hair with a shaved undercut on the right side and the nape, long asymmetric fringe falling over the right eye, very pale cool-toned skin with visible veins at the temples, tall lean wiry body, small bust, sharp collarbones, long legs, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing long slate-grey military greatcoat, black turtleneck, combat trousers, fingerless gloves, faded red wool scarf, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of nadia_tsoi, tall lean wiry body, small bust, sharp collarbones, long legs, wearing long slate-grey military greatcoat, black turtleneck, combat trousers, fingerless gloves, faded red wool scarf, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of nadia_tsoi, wearing urban camouflage poncho, awakened anti-materiel sniper rifle with a white-glinting scope, anti-materiel sniper rifle with a long scope, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : prone on a skyscraper rooftop in falling ash, a white glint on the scope

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
nadia_tsoi, tall lean wiry body, small bust, sharp collarbones, long legs, wearing unbuttoned oversized men's white shirt, black underwear, red scarf around the neck, prone sniper position on a rooftop, shirt hem lifting, cold glance over the scope, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
nadia_tsoi, tall lean wiry body, small bust, sharp collarbones, long legs, wearing unbuttoned oversized men's white shirt, black underwear, red scarf around the neck, sitting on a windowsill smoking in the snow, shirt open, scarf, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `aim` (one eye closed, utterly calm, cheek against the rifle stock)

**Checklist de cohérence** : Platine, undercut côté DROIT · Mèche sur l'œil DROIT · Yeux gris pâle · Écharpe ROUGE (confiance)

### 5.9 Maricel Dizon — `maricel_dizon`

**Noyau d'identité (invariant, réutilisé partout)** :
```
maricel_dizon, 26-year-old Filipina woman, petite curvy athletic build 157cm, round cheerful face with deep dimples on both cheeks, small slightly flat nose, full lips, beauty mark above the right side of the upper lip, large warm dark-brown eyes with long lashes, wavy shoulder-length hair with dark roots melting into a warm honey-blonde balayage, backwards baseball cap, golden-brown sun-kissed skin, Philippine eight-ray sun tattoo on the left shoulder, many beaded and cord bracelets on both wrists, slightly crooked left canine visible when she grins
```
**Tenues** :

- `base` : mustard-yellow cropped hoodie, tank top, olive-green cargo pants with stuffed pockets, high-top sneakers, fanny pack
- `combat` : retractable claw gloves, rope and grappling hook, headlamp
- `casual` : oversized basketball jersey worn as a dress, messy bun
- `night` : cropped white tank top and tiny cotton shorts, bracelets, cap backwards

**Morphologie (à respecter strictement)** : petite curvy body, large bust for her small frame, narrow waist, wide hips, thick thighs, round bottom

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of maricel_dizon, 26-year-old Filipina woman, petite curvy athletic build 157cm, round cheerful face with deep dimples on both cheeks, small slightly flat nose, full lips, beauty mark above the right side of the upper lip, large warm dark-brown eyes with long lashes, wavy shoulder-length hair with dark roots melting into a warm honey-blonde balayage, backwards baseball cap, golden-brown sun-kissed skin, Philippine eight-ray sun tattoo on the left shoulder, many beaded and cord bracelets on both wrists, slightly crooked left canine visible when she grins, petite curvy body, large bust for her small frame, narrow waist, wide hips, thick thighs, round bottom, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing mustard-yellow cropped hoodie, tank top, olive-green cargo pants with stuffed pockets, high-top sneakers, fanny pack, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of maricel_dizon, petite curvy body, large bust for her small frame, narrow waist, wide hips, thick thighs, round bottom, wearing mustard-yellow cropped hoodie, tank top, olive-green cargo pants with stuffed pockets, high-top sneakers, fanny pack, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of maricel_dizon, wearing retractable claw gloves, rope and grappling hook, headlamp, retractable claw gloves and a grappling hook, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : crouching on a Myeongdong rooftop at night, spinning a stolen watch between her fingers

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
maricel_dizon, petite curvy body, large bust for her small frame, narrow waist, wide hips, thick thighs, round bottom, wearing cropped white tank top and tiny cotton shorts, bracelets, cap backwards, crouching on a rooftop edge with a playful wink, shorts and bracelets, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
maricel_dizon, petite curvy body, large bust for her small frame, narrow waist, wide hips, thick thighs, round bottom, wearing cropped white tank top and tiny cotton shorts, bracelets, cap backwards, lying on her stomach on a hammock under a bridge, kicking her feet, grin, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `wink` (playful wink with a crooked grin)

**Checklist de cohérence** : Balayage blond miel, racines brunes · Tatouage soleil épaule GAUCHE · Fossettes des deux côtés · Casquette à l'envers

### 5.10 Dr. Tran Minh-Anh — `minhanh_tran`

**Noyau d'identité (invariant, réutilisé partout)** :
```
minhanh_tran, 36-year-old Vietnamese-Korean woman, slender willowy build 166cm, delicate oval face, soft cheekbones, small upturned nose, full naturally dark lips, very dark almost black eyes behind thin black rectangular glasses, purple shadows under the eyes, extremely long straight black hair in a single braid down to her lower back tied with an electric cable, cybernetic implant on the right temple with three silver ports and a strip of glowing blue LEDs, chipped black nail polish, light golden olive skin
```
**Tenues** :

- `base` : long white lab coat over a fitted black high-collar bodysuit traced with glowing cyan circuit lines, utility belt with test tubes, ID badge, thigh-high boots, holographic tablet on the wrist
- `combat` : lab coat unfolding into a swarm of small drones, analysis visor
- `casual` : oversized black turtleneck sweater, mismatched socks, iced coffee
- `night` : unbuttoned lab coat over a black lace bodysuit, glasses, braid over the shoulder

**Morphologie (à respecter strictement)** : slender willowy body, medium bust, slim waist, long elegant hands

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of minhanh_tran, 36-year-old Vietnamese-Korean woman, slender willowy build 166cm, delicate oval face, soft cheekbones, small upturned nose, full naturally dark lips, very dark almost black eyes behind thin black rectangular glasses, purple shadows under the eyes, extremely long straight black hair in a single braid down to her lower back tied with an electric cable, cybernetic implant on the right temple with three silver ports and a strip of glowing blue LEDs, chipped black nail polish, light golden olive skin, slender willowy body, medium bust, slim waist, long elegant hands, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing long white lab coat over a fitted black high-collar bodysuit traced with glowing cyan circuit lines, utility belt with test tubes, ID badge, thigh-high boots, holographic tablet on the wrist, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of minhanh_tran, slender willowy body, medium bust, slim waist, long elegant hands, wearing long white lab coat over a fitted black high-collar bodysuit traced with glowing cyan circuit lines, utility belt with test tubes, ID badge, thigh-high boots, holographic tablet on the wrist, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of minhanh_tran, wearing lab coat unfolding into a swarm of small drones, analysis visor, swarm of hovering hexagonal drones, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : underground laboratory full of servers and holographic data, LEDs turning red

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
minhanh_tran, slender willowy body, medium bust, slim waist, long elegant hands, wearing unbuttoned lab coat over a black lace bodysuit, glasses, braid over the shoulder, leaning over a holographic console, glasses sliding down, lab coat open, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
minhanh_tran, slender willowy body, medium bust, slim waist, long elegant hands, wearing unbuttoned lab coat over a black lace bodysuit, glasses, braid over the shoulder, sitting cross-legged on a server rack floor taking notes, LEDs glowing red, blushing, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `red_leds` (flustered, temple LEDs glowing red, looking away)

**Checklist de cohérence** : Tresse unique jusqu'aux reins · Implant tempe DROITE (LED bleues) · Lunettes rectangulaires · Teint olive doré

### 5.11 Haneul (l'Héritière) — `haneul_heiress`

**Noyau d'identité (invariant, réutilisé partout)** :
```
haneul_heiress, adult woman appearing about 25 years old, ethereal slender figure 169cm, timeless delicate oval face of no identifiable ethnicity, pale pink lips, large almond eyes with liquid gold irises and a slowly rotating clock-face ring around the pupils, silver eyelashes, very long glittering silver-white straight hair, translucent pearl-white opaline skin with faintly glowing golden glyphs on the arms and neck, gentle wondering expression, hovering slightly above the ground
```
**Tenues** :

- `base` : oversized worn black bomber jacket with orange lining over a mismatched long sweater and long skirt, boots of two different sizes
- `awakening` : obsidian and gold dress-armor, crown of floating glyphs, wings of fragmented light
- `casual` : man's shirt, sitting on a window ledge looking at the sky
- `night` : Elias's oversized black shirt as her only garment, bare legs, glyphs glowing on her thighs

**Morphologie (à respecter strictement)** : ethereal slender body, medium bust, slim waist, long graceful legs

**Planche de référence** (étape 1 du pipeline) :
```
character reference sheet of haneul_heiress, adult woman appearing about 25 years old, ethereal slender figure 169cm, timeless delicate oval face of no identifiable ethnicity, pale pink lips, large almond eyes with liquid gold irises and a slowly rotating clock-face ring around the pupils, silver eyelashes, very long glittering silver-white straight hair, translucent pearl-white opaline skin with faintly glowing golden glyphs on the arms and neck, gentle wondering expression, hovering slightly above the ground, ethereal slender body, medium bust, slim waist, long graceful legs, full body turnaround: front view, three-quarter view, side view and back view, plus two close-up head shots, wearing oversized worn black bomber jacket with orange lining over a mismatched long sweater and long skirt, boots of two different sizes, natural standing pose, flat neutral grey background, consistent design across all views, model sheet layout, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Portrait de dialogue** (neutre) :
```
waist-up portrait of haneul_heiress, ethereal slender body, medium bust, slim waist, long graceful legs, wearing oversized worn black bomber jacket with orange lining over a mismatched long sweater and long skirt, boots of two different sizes, three-quarter angle facing the viewer, neutral calm expression, dark gradient background with subtle neon rim light, clean silhouette, visual novel dialogue sprite, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Sprite de combat** :
```
full body combat stance of haneul_heiress, wearing oversized worn black bomber jacket with orange lining over a mismatched long sweater and long skirt, boots of two different sizes, floating golden glyph circles and a clock-hand of light, side three-quarter view, dramatic action lighting, plain dark background for cut-out, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Signature visuelle** : standing before a door without a lock on the first floor of the Tower, golden pages floating

**Fanservice / pin-up** (tenue de nuit, angles dynamiques) :
```
haneul_heiress, ethereal slender body, medium bust, slim waist, long graceful legs, wearing Elias's oversized black shirt as her only garment, bare legs, glyphs glowing on her thighs, sitting on a window ledge looking at the sky, shirt slipping off one shoulder, low angle shot looking up, teasing smile, one eyebrow raised, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
```
haneul_heiress, ethereal slender body, medium bust, slim waist, long graceful legs, wearing Elias's oversized black shirt as her only garment, bare legs, glyphs glowing on her thighs, floating mid-air in a golden glyph circle, hair spreading like silk, high angle shot looking down, biting her lower lip, half-lidded eyes, cinematic manhwa panel framing, dramatic rim lighting, glossy skin highlights, semi-realistic mature Korean webtoon illustration, premium action manhwa rendering in the vein of Solo Leveling and Omniscient Reader's Viewpoint, sharp clean lineart, dramatic hard cel shading with deep shadows, strong rim lighting, cinematic contrast, neon cyan and magenta accent lights, dark fantasy and sci-fi atmosphere, highly detailed eyes, realistic adult proportions, high detail
```
**Expressions propres** : `tilt` (head tilted 45 degrees, curious) · `administrator` (cold ancient expression, glyphs turning red)

**États évolutifs** : `memory_25` → silver hair · `memory_50` → pearl-grey hair · `memory_100` → ink-black hair

**Checklist de cohérence** : Yeux OR + anneau d'horloge · Glyphes dorés · Bomber d'Elias (doublure orange) · Cheveux selon l'état de mémoire

## 6. Production automatisée

Ces prompts alimentent directement le pipeline cloud `tools/art_pipeline/generate.py` (voir `tools/art_pipeline/README.md`) :
1. `refs` : 4 planches de référence par personnage ;
2. choix dans `art_work/review.html` ;
3. `auto <id> <planche>` : jeu de données à identité fixe, LoRA, puis tous les assets du manifeste.
4. Visuels 18+ : les entrées du manifeste marquées `"backend": "runpod"` passent par le backend ComfyUI serverless (`runpod_backend.py`).

