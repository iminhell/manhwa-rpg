extends RefCounted
## Logique de la carte (pure, testable) : secteurs, sous-zones, zones cachées, coûts en temps,
## fatigue, événements datés (Ancres) et recherche de chemin. Voir GDD §3 et §7.
##
## Temps : 1 tick = ¼ de phase. Déplacement entre sous-zones = 1 tick, action = 2 ticks par défaut,
## secteur adjacent = 4 ticks (1 phase), secteur non adjacent = 8 ticks (2 phases).
## Le temps avance tick par tick : un événement daté interrompt l'avancée à la frontière de phase.

const TRAVEL_ADJACENT := 4
const TRAVEL_FAR := 8
const COLLAPSE_FATIGUE := 28   ## 7 phases éveillé : malaise forcé
const SPECIAL_SECTORS := ["etage1", "etage2"]  ## accessibles uniquement depuis un secteur adjacent
const RefugeModel := preload("res://world/refuge_model.gd")

var store
var sectors: Dictionary = {}
var factions: Dictionary = {}
var events: Array = []
var messages: Array = []        ## messages à afficher (vidés par l'UI)
var pending_event: Dictionary = {}
var refuge  ## RefugeModel


func _init(state_store, world_data: Dictionary, events_data: Dictionary, refuge_data: Dictionary = {}) -> void:
	store = state_store
	refuge = RefugeModel.new(state_store, refuge_data)
	sectors = world_data.get("sectors", {})
	factions = world_data.get("factions", {})
	events = events_data.get("events", [])
	events.sort_custom(func(a, b): return int(a.get("priority", 50)) > int(b.get("priority", 50)))


# --- Requêtes ---------------------------------------------------------------------

func sector_id() -> String:
	return str(store.get_var("pos.sector", ""))


func node_id() -> String:
	return str(store.get_var("pos.node", ""))


static func sector_of(nid: String) -> String:
	return nid.get_slice(".", 0)


func sector(sid: String) -> Dictionary:
	return sectors.get(sid, {})


func node(nid: String) -> Dictionary:
	return sector(sector_of(nid)).get("nodes", {}).get(nid, {})


func sector_available(sid: String) -> bool:
	return sectors.has(sid) and store.check(str(sector(sid).get("available", "")))


func node_visible(nid: String) -> bool:
	return store.check(str(node(nid).get("hidden", "")))


func node_open(nid: String) -> bool:
	return store.check(str(node(nid).get("open", "")))


func is_refuge(nid: String) -> bool:
	var cond := str(node(nid).get("refuge", ""))
	return cond != "" and store.check(cond)


func visible_nodes(sid: String) -> Array:
	return sector(sid).get("nodes", {}).keys().filter(func(n): return node_visible(n))


func can_move(nid: String) -> bool:
	return nid != node_id() and node(nid).get("links", []).has(node_id()) \
		and node_visible(nid) and node_open(nid)


func travel_cost(sid: String) -> int:
	return TRAVEL_ADJACENT if sector(sector_id()).get("adjacent", []).has(sid) else TRAVEL_FAR


func can_travel(sid: String) -> bool:
	if sid == sector_id() or not sector_available(sid):
		return false
	var adjacent: bool = sector(sector_id()).get("adjacent", []).has(sid)
	if SPECIAL_SECTORS.has(sid) or SPECIAL_SECTORS.has(sector_id()):
		return adjacent
	return true


# --- Actions du joueur ----------------------------------------------------------------

## Place Elias sur un nœud (sans coût de temps).
func place(nid: String) -> void:
	store.set_var("pos.sector", sector_of(nid))
	store.set_var("pos.node", nid)
	store.set_flag("visite." + sector_of(nid))
	refresh()


## Recalcule les propriétés dérivées de la position (refuge…), après un dialogue par exemple.
func refresh() -> void:
	store.set_var("pos.refuge", is_refuge(node_id()))
	messages.append_array(refuge.daily_upkeep())


func move(nid: String) -> bool:
	if not can_move(nid):
		return false
	place(nid)
	advance(1)
	return true


func travel(sid: String) -> bool:
	if not can_travel(sid):
		return false
	var cost := travel_cost(sid)
	place(str(sector(sid)["entry"]))
	messages.append("Trajet vers %s (%d phase%s)." % [sector(sid)["short"], int(cost / 4.0), "s" if cost > 4 else ""])
	advance(cost)
	return true


## Actions disponibles sur le nœud courant, y compris les actions intégrées (dormir, manger).
func actions() -> Array:
	var nid := node_id()
	var out := []
	for a in node(nid).get("actions", []):
		if a.get("once", false) and store.has_flag(_act_flag(nid, a)):
			continue
		if a.get("daily", false) and store.has_flag(_act_flag(nid, a) + ".%d" % store.day()):
			continue
		if not store.check(str(a.get("if", ""))):
			continue
		out.append(a)
	if is_refuge(nid):
		if refuge.node_id() == nid:
			out.append({"id": "_manage", "label": "Gérer le Refuge (stock, améliorations)", "cost": 0, "panel": "refuge"})
			if store.phase() >= 2 and not refuge.rest_done_today():
				for cid in _party_heroines():
					out.append({"id": "_rest_" + cid, "label": "Moment de repos avec %s" % cid.capitalize().replace("_", "-"),
						"cost": 4, "rest": true, "dialogue": "act2_refuge:" + cid})
		else:
			out.append({"id": "_establish", "label": "Établir le Refuge ici", "cost": 2, "establish": true})
		out.append({"id": "_sleep", "label": "Dormir jusqu'à l'aube", "cost": 0, "sleep": true})
	if store.item("ration") > 0 and int(store.get_var("fatigue", 0)) >= 8:
		out.append({"id": "_eat", "label": "Manger une ration (fatigue −1 phase)", "cost": 1, "fx": ["item ration -1", "add fatigue -4"]})
	return out


## Exécute une action. Renvoie ce que l'UI doit lancer : {"dialogue", "encounter", "win_fx"}.
func do_action(a: Dictionary) -> Dictionary:
	var nid := node_id()
	if a.get("once", false):
		store.set_flag(_act_flag(nid, a))
	if a.get("daily", false):
		store.set_flag(_act_flag(nid, a) + ".%d" % store.day())
	store.apply_effects(a.get("fx", []))
	if a.get("message", "") != "":
		messages.append(a["message"])
	if a.get("sleep", false):
		sleep()
		return {}
	if a.get("establish", false):
		refuge.establish(nid)
		messages.append("Refuge établi : %s." % node(nid).get("name", nid))
	if a.get("rest", false):
		refuge.mark_rest()
	if a.has("panel"):
		return {"panel": a["panel"]}
	if a.has("travel"):
		place(str(a["travel"]))
	advance(int(a.get("cost", 2)))
	refresh()
	var result := {}
	for k in ["dialogue", "encounter", "win_fx"]:
		if a.has(k):
			result[k] = a[k]
	return result


## Dormir : la nuit passe, sauf si un événement nocturne l'interrompt.
func sleep() -> void:
	if store.phase() < 3:
		advance((3 - store.phase()) * 4 - store.ticks() % 4)
		if not pending_event.is_empty():
			return
	if refuge.node_id() == node_id():
		refuge.on_sleep_here()
	store.sleep_until_dawn()
	messages.append("Tu dors. Jour %d — Aube." % store.day())
	refresh()
	_check_events()


func _party_heroines() -> Array:
	var out := []
	for f in store.flags.keys():
		if str(f).begins_with("party."):
			out.append(str(f).substr(6))
	out.sort()
	return out


func _act_flag(nid: String, a: Dictionary) -> String:
	return "act.%s.%s" % [nid, a.get("id", "?")]


# --- Temps & événements -----------------------------------------------------------------

## Avance le temps tick par tick ; s'arrête à la première frontière de phase où un événement se déclenche.
func advance(n: int) -> void:
	for i in n:
		var before: int = store.phase()
		store.advance_ticks(1)
		if store.phase() != before:
			refresh()
			if _check_events():
				return
	if int(store.get_var("fatigue", 0)) >= COLLAPSE_FATIGUE:
		messages.append("Tu t'effondres d'épuisement. Tu te réveilles à l'aube, détroussé (−10).")
		store.apply_effects(["money -10"])
		store.sleep_until_dawn()
		refresh()
	_check_events()


## Cherche l'événement prioritaire déclenchable ici et maintenant, et le met en attente.
func _check_events() -> bool:
	if not pending_event.is_empty():
		return true
	var ev := next_event()
	if ev.is_empty():
		return false
	pending_event = ev
	return true


func next_event() -> Dictionary:
	for ev in events:
		if _event_done(ev):
			continue
		if not _where_matches(str(ev.get("where", "*"))):
			continue
		if store.check(str(ev.get("when", ""))):
			return ev
	return {}


## L'UI consomme l'événement en attente : il est marqué comme joué et renvoyé.
func take_event() -> Dictionary:
	if pending_event.is_empty():
		_check_events()
	var ev := pending_event
	pending_event = {}
	if not ev.is_empty():
		if ev.get("repeat", "once") == "daily":
			store.set_flag("event.%s.%d" % [ev["id"], store.day()])
		else:
			store.set_flag("event." + str(ev["id"]))
	return ev


func _event_done(ev: Dictionary) -> bool:
	if ev.get("repeat", "once") == "daily":
		return store.has_flag("event.%s.%d" % [ev["id"], store.day()])
	return store.has_flag("event." + str(ev["id"]))


func _where_matches(where: String) -> bool:
	if where == "*" or where == "":
		return true
	if where.begins_with("sector:"):
		return sector_id() == where.substr(7)
	return node_id() == where


# --- Recherche de chemin (autopilote, « aller à ») ------------------------------------------

## Prochaine étape vers un nœud cible : {"move": nid} ou {"travel": sid}, {} si inaccessible ou déjà sur place.
func path_step(target: String) -> Dictionary:
	var tsec := sector_of(target)
	if node_id() == target:
		return {}
	if tsec != sector_id():
		var route := _sector_route(sector_id(), tsec)
		return {"travel": route[0]} if not route.is_empty() else {}
	var prev := {node_id(): ""}
	var queue := [node_id()]
	while not queue.is_empty():
		var cur: String = queue.pop_front()
		if cur == target:
			break
		for l in node(cur).get("links", []):
			if not prev.has(l) and node_visible(l) and node_open(l):
				prev[l] = cur
				queue.append(l)
	if not prev.has(target):
		return {}
	var step := target
	while prev[step] != node_id():
		step = prev[step]
	return {"move": step}


func _sector_route(from: String, to: String) -> Array:
	var prev := {from: ""}
	var queue := [from]
	while not queue.is_empty():
		var cur: String = queue.pop_front()
		if cur == to:
			break
		for s in sector(cur).get("adjacent", []):
			if not prev.has(s) and sector_available(s):
				prev[s] = cur
				queue.append(s)
	if not prev.has(to):
		return []
	var route := []
	var step := to
	while step != from:
		route.push_front(step)
		step = prev[step]
	return route
