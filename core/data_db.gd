extends Node
## Autoload : charge les données JSON du jeu (personnages, combat, dialogues).

var characters: Dictionary = {}
var skills: Dictionary = {}
var enemies: Dictionary = {}
var encounters: Dictionary = {}
var dialogues: Dictionary = {}


func _ready() -> void:
	reload()


func reload() -> void:
	characters = load_dir("res://data/characters")
	skills = load_json("res://data/combat/skills.json").get("skills", {})
	enemies = load_json("res://data/combat/enemies.json").get("enemies", {})
	encounters = load_json("res://data/combat/encounters.json").get("encounters", {})
	dialogues = load_dir("res://data/dialogues")


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


func palette_color(id: String) -> Color:
	var pal: Array = character(id).get("palette", [])
	return Color(pal[2]) if pal.size() > 2 else Color("#2ec5ff")
