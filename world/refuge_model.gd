extends RefCounted
## Logique du Refuge (pure, testable) — GDD §8.5.
## État dans le StateStore : refuge.node, refuge.sector, refuge.rations, refuge.defense, refuge.faim,
## drapeaux refuge.<amélioration>, refuge.last_day, refuge.repos.<jour>.

var store
var data: Dictionary


func _init(state_store, refuge_data: Dictionary) -> void:
	store = state_store
	data = refuge_data


func established() -> bool:
	return str(store.get_var("refuge.node", "")) != ""


func node_id() -> String:
	return str(store.get_var("refuge.node", ""))


func establish(nid: String) -> void:
	var first := not established()
	store.set_var("refuge.node", nid)
	store.set_var("refuge.sector", nid.get_slice(".", 0))
	store.set_var("refuge.last_day", store.day())
	if first:
		store.add_var("refuge.rations", 2)


func rations() -> int:
	return int(store.get_var("refuge.rations", 0))


func has(upgrade: String) -> bool:
	return store.has_flag("refuge." + upgrade)


func type_info() -> Dictionary:
	for t in data.get("types", []):
		if store.check(str(t.get("if", "true"))):
			return t
	return {}


func residents() -> int:
	var n := 1
	for f in store.flags:
		if str(f).begins_with("party."):
			n += 1
	return n


func daily_need() -> int:
	return int(ceil(float(residents()) / float(data.get("upkeep", {}).get("residents_per_ration", 2))))


func can_build(id: String) -> bool:
	var u: Dictionary = data.get("upgrades", {}).get(id, {})
	if u.is_empty() or has(id) or not store.check(str(u.get("if", ""))):
		return false
	var cost: Dictionary = u.get("cost", {})
	return store.money() >= int(cost.get("argent", 0)) and rations() >= int(cost.get("ration", 0))


## Construit une amélioration. Renvoie le nombre de ticks consommés (0 si impossible).
func build(id: String) -> int:
	if not can_build(id):
		return 0
	var u: Dictionary = data["upgrades"][id]
	var cost: Dictionary = u.get("cost", {})
	store.apply_effects(["money -%d" % int(cost.get("argent", 0))])
	store.add_var("refuge.rations", -int(cost.get("ration", 0)))
	store.set_flag("refuge." + id)
	store.apply_effects(u.get("fx", []))
	return int(u.get("ticks", 4))


func deposit(n: int) -> int:
	var moved: int = min(n, store.item("ration"))
	store.apply_effects(["item ration %d" % -moved])
	store.add_var("refuge.rations", moved)
	return moved


func withdraw(n: int) -> int:
	var moved: int = min(n, rations())
	store.add_var("refuge.rations", -moved)
	store.apply_effects(["item ration %d" % moved])
	return moved


func sell_fragments() -> int:
	var n: int = store.item("fragment_strate")
	if n <= 0 or not has("atelier"):
		return 0
	store.apply_effects(["item fragment_strate %d" % -n, "money %d" % (25 * n)])
	return n


## Entretien quotidien, appliqué à chaque nouvelle aube. Renvoie les messages à afficher.
func daily_upkeep() -> Array:
	var msgs := []
	if not established():
		return msgs
	var last := int(store.get_var("refuge.last_day", store.day()))
	for d in range(last + 1, store.day() + 1):
		if has("cuisine"):
			store.add_var("refuge.rations", 1)
		var need := daily_need()
		if rations() >= need:
			store.add_var("refuge.rations", -need)
			store.set_var("refuge.faim", 0)
		else:
			store.set_var("refuge.rations", 0)
			store.add_var("refuge.faim", 1)
			var pen := int(data.get("upkeep", {}).get("hunger_trust_penalty", 2))
			for f in store.flags.keys():
				if str(f).begins_with("party."):
					store.add_var("trust." + str(f).substr(6), -pen)
			msgs.append("Jour %d : le Refuge manque de rations. Le groupe a faim (Confiance −%d)." % [d, pen])
	store.set_var("refuge.last_day", store.day())
	return msgs


## Effets d'une nuit passée au Refuge.
func on_sleep_here() -> void:
	if has("infirmerie"):
		for f in store.flags.keys():
			if str(f).begins_with("party."):
				store.add_var("trust." + str(f).substr(6), 1)


func rest_done_today() -> bool:
	return store.has_flag("refuge.repos.%d" % store.day())


func mark_rest() -> void:
	store.set_flag("refuge.repos.%d" % store.day())
