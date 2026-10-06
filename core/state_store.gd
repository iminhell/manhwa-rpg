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
##   "item id n" (inventaire) · "money n" · "fin id" (Fin connue au Registre)
##   "join id" / "leave id" (groupe) · "pressure n" (Pression de la Tour)
const EFFECT_OPS := ["set", "add", "flag", "unflag", "souvenir", "item", "money", "fin", "join", "leave", "pressure"]


func apply_effect(effect: String) -> void:
	var parts := effect.strip_edges().split(" ", false)
	if parts.is_empty():
		return
	match parts[0]:
		"item":
			add_var("item." + parts[1], float(parts[2]) if parts.size() > 2 else 1.0)
		"money":
			add_var("argent", float(parts[1]))
		"fin":
			set_flag("fin." + parts[1], true)
		"join":
			set_flag("party." + parts[1], true)
		"leave":
			set_flag("party." + parts[1], false)
		"pressure":
			add_var("tower.p_mod", float(parts[1]))
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
func v(key: String, default_value: Variant = 0) -> Variant:
	return get_var(key, default_value)


func flag(name: String) -> bool:
	return has_flag(name)


func souvenir(id: String) -> bool:
	return souvenirs.has(id)


func aff(id: String) -> float:
	return float(get_var("aff." + id))


func loop() -> int:
	return int(get_var("loop", 1))


# --- Temps (1 jour = 4 phases = 16 ticks ; 1 tick = ¼ de phase) ---------------------
const TICKS_PER_PHASE := 4
const TICKS_PER_DAY := 16


func ticks() -> int:
	return int(get_var("time.ticks", 0))


@warning_ignore("integer_division")
func day() -> int:
	return ticks() / TICKS_PER_DAY + 1


@warning_ignore("integer_division")
func phase() -> int:
	return (ticks() % TICKS_PER_DAY) / TICKS_PER_PHASE


func advance_ticks(n: int) -> void:
	set_var("time.ticks", ticks() + n)
	add_var("fatigue", n)


## Place l'horloge sur (jour, phase) sans jamais remonter le temps.
func set_time(d: int, p: int) -> void:
	var target := (d - 1) * TICKS_PER_DAY + p * TICKS_PER_PHASE
	if target > ticks():
		advance_ticks(target - ticks())


## Saute à l'aube suivante. Si l'on est pile au lever du jour (malaise à l'aube), le temps ne bouge pas.
func sleep_until_dawn() -> void:
	if ticks() % TICKS_PER_DAY != 0:
		set_var("time.ticks", day() * TICKS_PER_DAY)
	set_var("fatigue", 0)


func pressure() -> float:
	return 20.0 + 2.5 * float(day() - 1) + float(get_var("tower.p_mod", 0))


# --- Monde, groupe, inventaire ------------------------------------------------------
func at(node_id: String) -> bool:
	return str(get_var("pos.node", "")) == node_id


func in_sector(sector_id: String) -> bool:
	return str(get_var("pos.sector", "")) == sector_id


func party(id: String) -> bool:
	return id == "elias" or has_flag("party." + id)


func item(id: String) -> int:
	return int(get_var("item." + id, 0))


func money() -> int:
	return int(get_var("argent", 0))


func trust(id: String) -> float:
	return float(get_var("trust." + id))


func fear(id: String) -> float:
	return float(get_var("fear." + id))


## Vrai si Elias est dans le secteur où il a établi son Refuge.
func in_refuge_sector() -> bool:
	var rs := str(get_var("refuge.sector", ""))
	return rs != "" and rs == str(get_var("pos.sector", ""))


func done(event_id: String) -> bool:
	return has_flag("event." + event_id)


func knows_fin(id: String) -> bool:
	return has_flag("fin." + id)


# --- Sérialisation -----------------------------------------------------------
func to_dict() -> Dictionary:
	return {"vars": vars.duplicate(true), "flags": flags.duplicate(), "souvenirs": souvenirs.duplicate()}


func from_dict(d: Dictionary) -> void:
	vars = d.get("vars", {}).duplicate(true)
	flags = d.get("flags", {}).duplicate()
	souvenirs = d.get("souvenirs", {}).duplicate()
