extends RefCounted
## Une unité sur la grille 3×3 (allié ou ennemi). Données pures, sérialisables.

var uid: String = ""        ## identifiant unique dans le combat (ex. "rodeur#2")
var base_id: String = ""    ## id du personnage ou de l'ennemi dans les données
var name: String = ""
var side: String = "ally"   ## "ally" | "enemy"
var row: int = 0            ## 0 avant · 1 milieu · 2 arrière
var lane: int = 1           ## 0..2
var max_hp: int = 100
var hp: int = 100
var atk: float = 10.0
var def: float = 5.0
var spd: float = 10.0
var max_mana: int = 50
var mana: int = 50
var awaken: int = 0         ## Jauge d'Éveil 0..100
var fear: int = 0
var skills: Array = []
var statuses: Dictionary = {}   ## nom → tours restants
var ctb: float = 0.0        ## temps avant le prochain tour (frise CTB)
var crit_next: bool = false
var boss: bool = false
var fled: bool = false
var color: String = "#2ec5ff"
var intent: Dictionary = {}     ## ennemis : {"skill": id, "target": uid}
var phases: Array = []          ## boss : [{"below": 0.5, "atk_mult": 1.2, "spd_mult": 1.0, "add_skills": [], "log": "…"}]
var phase_idx: int = 0          ## nombre de paliers déjà franchis
var rule: String = ""           ## Règle de Gardien (ex. "bruit" : chaque compétence coûteuse l'enrage)
var rage: int = 0


func is_alive() -> bool:
	return hp > 0 and not fled


func hp_ratio() -> float:
	return float(hp) / float(max(1, max_hp))


func has_status(s: String) -> bool:
	return statuses.get(s, 0) > 0


const FIELDS := ["uid", "base_id", "name", "side", "row", "lane", "max_hp", "hp", "atk", "def", "spd",
	"max_mana", "mana", "awaken", "fear", "skills", "statuses", "ctb", "crit_next", "boss", "fled",
	"color", "intent", "phases", "phase_idx", "rule", "rage"]


func to_dict() -> Dictionary:
	var d := {}
	for f in FIELDS:
		var val: Variant = get(f)
		d[f] = val.duplicate(true) if (val is Array or val is Dictionary) else val
	return d


func from_dict(d: Dictionary) -> void:
	for f in FIELDS:
		if d.has(f):
			var val: Variant = d[f]
			set(f, val.duplicate(true) if (val is Array or val is Dictionary) else val)
