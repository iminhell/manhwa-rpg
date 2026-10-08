extends Node
## Autoload : charge les données JSON du jeu (personnages, combat, dialogues).

var characters: Dictionary = {}
var skills: Dictionary = {}
var enemies: Dictionary = {}
var encounters: Dictionary = {}
var dialogues: Dictionary = {}
var world: Dictionary = {}
var events: Dictionary = {}
var souvenirs: Dictionary = {}
var fins: Dictionary = {}
var act_summary: Dictionary = {}
var music: Dictionary = {}
var refuge: Dictionary = {}
var difficulty: Dictionary = {}
var resilience: Dictionary = {}
var gifts: Dictionary = {}
var echoes: Dictionary = {}
var group_scenes: Dictionary = {}
var gallery: Dictionary = {}
var items: Dictionary = {}   ## data/world/items.json (écran Inventaire)
var guide: Dictionary = {}   ## data/world/guide.json (Guide du joueur)
var gallery_unlocks: Dictionary = {}  ## « dialogue:bloc » → identifiants des entrées de galerie qu'il débloque


func _ready() -> void:
	reload()


func reload() -> void:
	characters = load_dir("res://data/characters")
	skills = load_json("res://data/combat/skills.json").get("skills", {})
	enemies = load_json("res://data/combat/enemies.json").get("enemies", {})
	encounters = load_json("res://data/combat/encounters.json").get("encounters", {})
	dialogues = load_dir("res://data/dialogues")
	world = load_json("res://data/world/sectors.json")
	events = load_json("res://data/world/events.json")
	souvenirs = load_json("res://data/world/souvenirs.json").get("souvenirs", {})
	fins = load_json("res://data/world/fins.json").get("fins", {})
	act_summary = load_json("res://data/world/act_summary.json")
	music = load_json("res://data/audio/music.json")
	refuge = load_json("res://data/world/refuge.json")
	difficulty = load_json("res://data/world/difficulty.json")
	resilience = load_json("res://data/world/resilience.json")
	gifts = load_json("res://data/world/gifts.json")
	echoes = load_json("res://data/world/echoes.json").get("echoes", {})
	group_scenes = load_json("res://data/world/group_scenes.json")
	gallery = load_json("res://data/world/gallery.json")
	items = load_json("res://data/world/items.json")
	guide = load_json("res://data/world/guide.json")
	gallery_unlocks = {}
	for e in gallery.get("entries", []):
		for ref in e.get("unlock", []):
			if not gallery_unlocks.has(ref):
				gallery_unlocks[ref] = []
			gallery_unlocks[ref].append(e["id"])


static func load_json(path: String) -> Dictionary:
	var text := FileAccess.get_file_as_string(path)
	if text == "":
		push_error("JSON introuvable ou vide : %s" % path)
		return {}
	var data: Variant = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		push_error("JSON invalide : %s" % path)
		return {}
	return data


## Charge tous les .json d'un dossier, indexés par leur champ "id" (ou le nom du fichier).
static func load_dir(dir_path: String) -> Dictionary:
	var out := {}
	for file in DirAccess.get_files_at(dir_path):
		if not file.ends_with(".json"):
			continue
		var d := load_json(dir_path.path_join(file))
		out[d.get("id", file.get_basename())] = d
	return out


func character(id: String) -> Dictionary:
	return characters.get(id, {})


func display_name(id: String) -> String:
	match id:
		"narrator", "":
			return ""
		"system":
			return "SYSTÈME"
		"registre":
			return "REGISTRE"
	return character(id).get("name", id.capitalize())


## Prénom d'usage (« seo_yeon » → « Seo-Yeon », « hae_in » → « Hae-in ») pour les messages courts.
func short_name(id: String) -> String:
	var parts := id.split("_")
	var out := parts[0].capitalize()
	for i in range(1, parts.size()):
		out += "-" + (parts[i] if id == "hae_in" else parts[i].capitalize())
	return out


## Couleur d'accent lisible sur fond sombre (les palettes très sombres sont éclaircies).
func palette_color(id: String) -> Color:
	var pal: Array = character(id).get("palette", [])
	var c := Color(pal[2]) if pal.size() > 2 else Color("#2ec5ff")
	while c.get_luminance() < 0.35:
		c = c.lightened(0.2)
	return c
