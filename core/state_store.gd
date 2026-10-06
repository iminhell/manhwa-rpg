extends RefCounted
## Stockage de l'état narratif : variables, drapeaux, souvenirs.
## Pur (aucune dépendance au SceneTree) : utilisé par GameState et par les tests.
##
## Conventions de clés :
##   align.protect / align.bond / align.chaos   axes d'alignement
##   aff.<id> / trust.<id> / fear.<id>          jauges des héroïnes
##   loop                                        numéro de boucle (1 = première vie)

var vars: Dictionary = {}
var flags: Dictionary = {}
var souvenirs: Dictionary = {}


func get_var(key: String, default_value: Variant = 0) -> Variant:
	return vars.get(key, default_value)


func set_var(key: String, value: Variant) -> void:
	vars[key] = value


func add_var(key: String, amount: float) -> void:
	vars[key] = float(vars.get(key, 0)) + amount


func has_flag(name: String) -> bool:
	return flags.get(name, false)


func set_flag(name: String, on: bool = true) -> void:
	if on:
		flags[name] = true
	else:
		flags.erase(name)


func add_souvenir(id: String) -> void:
	souvenirs[id] = true


# --- Effets ------------------------------------------------------------------
## Formats acceptés (chaînes compactes pour l'écriture des dialogues) :
##   "set clé valeur" · "add clé valeur" · "flag nom" · "unflag nom" · "souvenir id"
func apply_effect(effect: String) -> void:
	var parts := effect.strip_edges().split(" ", false)
	if parts.is_empty():
		return
	match parts[0]:
		"set":
			set_var(parts[1], _parse_value(parts[2]) if parts.size() > 2 else true)
		"add":
			add_var(parts[1], float(parts[2]) if parts.size() > 2 else 1.0)
		"flag":
			set_flag(parts[1], true)
		"unflag":
			set_flag(parts[1], false)
		"souvenir":
			add_souvenir(parts[1])
		_:
			push_warning("Effet inconnu : %s" % effect)


func apply_effects(effects: Array) -> void:
	for e in effects:
		apply_effect(str(e))


func _parse_value(raw: String) -> Variant:
	if raw.is_valid_int():
		return int(raw)
	if raw.is_valid_float():
		return float(raw)
	if raw == "true" or raw == "false":
		return raw == "true"
	return raw


# --- Conditions --------------------------------------------------------------
## Expressions Godot évaluées avec ce store comme contexte, par exemple :
##   "loop() > 1 and flag('met_seo_yeon')"   ·   "v('align.protect') >= 10"
func check(condition: String) -> bool:
	if condition.strip_edges() == "":
		return true
	var expr := Expression.new()
	if expr.parse(condition) != OK:
		push_error("Condition invalide « %s » : %s" % [condition, expr.get_error_text()])
		return false
	var result: Variant = expr.execute([], self, false)
	if expr.has_execute_failed():
		push_error("Échec d'évaluation « %s »" % condition)
		return false
	return bool(result)


# Fonctions exposées aux conditions
func v(key: String) -> Variant:
	return get_var(key)


func flag(name: String) -> bool:
	return has_flag(name)


func souvenir(id: String) -> bool:
	return souvenirs.has(id)


func aff(id: String) -> float:
	return float(get_var("aff." + id))


func loop() -> int:
	return int(get_var("loop", 1))


# --- Sérialisation -----------------------------------------------------------
func to_dict() -> Dictionary:
	return {"vars": vars.duplicate(true), "flags": flags.duplicate(), "souvenirs": souvenirs.duplicate()}


func from_dict(d: Dictionary) -> void:
	vars = d.get("vars", {}).duplicate(true)
	flags = d.get("flags", {}).duplicate()
	souvenirs = d.get("souvenirs", {}).duplicate()
