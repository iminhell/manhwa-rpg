extends Node
## Autoload : sauvegarde et chargement.
##   RunSave  : la boucle en cours (tout l'état vit dans le StateStore : variables, drapeaux, souvenirs,
##              temps, position, Refuge). 3 emplacements manuels + 1 automatique (à chaque nouvelle phase sur la carte).
##   MetaSave : ce qui survit à tout (boucles vécues, actes terminés, Fins et souvenirs jamais vus).
## Les sauvegardes ne se font que sur la carte (jamais au milieu d'un dialogue ou d'un combat).

const SaveFormat := preload("res://core/save_format.gd")
const VERSION := SaveFormat.VERSION
const DIR := "user://saves"
const META_PATH := "user://saves/meta.json"
const SLOTS := ["auto", "1", "2", "3"]

var meta: Dictionary = {"loops": 1, "acts": [], "fins": [], "souvenirs": []}


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(DIR)
	meta = _read(META_PATH, meta)


func slot_path(slot: String) -> String:
	return "%s/slot_%s.json" % [DIR, slot]


func save(slot: String) -> bool:
	var data := SaveFormat.build_save(GameState.store, GameState.party_ids())
	update_meta(GameState.store)
	var ok := _write(slot_path(slot), data)
	if ok:
		print_verbose("[sauvegarde] emplacement %s" % slot)
	return ok


func autosave() -> void:
	save("auto")


func has_save(slot: String) -> bool:
	return FileAccess.file_exists(slot_path(slot))


func summary(slot: String) -> Dictionary:
	return _read(slot_path(slot), {}).get("summary", {})


func saved_at(slot: String) -> String:
	return str(_read(slot_path(slot), {}).get("saved_at", ""))


## Emplacement le plus récent (pour « Continuer »), ou "" s'il n'y en a aucun.
func latest_slot() -> String:
	var best := ""
	var best_t := 0
	for s in SLOTS:
		if has_save(s):
			var t := FileAccess.get_modified_time(slot_path(s))
			if t >= best_t:
				best_t = t
				best = s
	return best


## Charge l'emplacement dans GameState. Renvoie false si absent ou incompatible.
func load_slot(slot: String) -> bool:
	var data := _read(slot_path(slot), {})
	if data.is_empty() or int(data.get("version", 0)) > VERSION:
		return false
	GameState.load_store(data.get("store", {}))
	return true


func delete_slot(slot: String) -> void:
	if has_save(slot):
		DirAccess.remove_absolute(slot_path(slot))


# --- Méta-progression ---------------------------------------------------------------

func update_meta(store) -> void:
	meta["loops"] = max(int(meta.get("loops", 1)), store.loop())
	for f in store.flags:
		if str(f).begins_with("fin.") and not meta["fins"].has(f.substr(4)):
			meta["fins"].append(f.substr(4))
	for s in store.souvenirs:
		if not meta["souvenirs"].has(s):
			meta["souvenirs"].append(s)
	if not meta.has("echoes"):
		meta["echoes"] = []
	if not meta.has("endings"):
		meta["endings"] = []
	for f in store.flags:
		var key := str(f)
		if key.begins_with("echo.") and not meta["echoes"].has(key.substr(5)):
			meta["echoes"].append(key.substr(5))
		if key.begins_with("issue.") and not meta["endings"].has(key.substr(6)):
			meta["endings"].append(key.substr(6))
	_write(META_PATH, meta)


func record_act(act: int) -> void:
	if not meta["acts"].has(act):
		meta["acts"].append(act)
	update_meta(GameState.store)


# --- E/S ------------------------------------------------------------------------------------

func _write(path: String, data: Dictionary) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("Sauvegarde impossible : %s" % path)
		return false
	f.store_string(JSON.stringify(data, "\t"))
	return true


func _read(path: String, fallback: Dictionary) -> Dictionary:
	if not FileAccess.file_exists(path):
		return fallback.duplicate(true)
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if typeof(parsed) == TYPE_DICTIONARY else fallback.duplicate(true)
