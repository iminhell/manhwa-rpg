extends RefCounted
## Logique de la carte (pure, testable) : secteurs, sous-zones, zones cachées, coûts en temps,
## fatigue, événements datés (Ancres) et recherche de chemin. Voir GDD §3 et §7.
##
## Temps : 1 tick = ¼ de phase. Déplacement entre sous-zones = 1 tick, action = 2 ticks par défaut,
## secteur adjacent = 3 ticks, secteur non adjacent = 6 ticks (v0.8).
## Jours de répit (v0.9) : la Tour « retient son souffle » ; pas d'Ancre ni de combat, et à la nuit le temps
## revient au matin du répit (les liens tissés restent). Cadeaux : achetés sur un nœud, offerts au Refuge.
## Le temps avance tick par tick : un événement daté interrompt l'avancée à la frontière de phase.

const TRAVEL_ADJACENT := 3   ## v0.8 : assoupli (mesure du temps libre, GDD §19.7.5)
const TRAVEL_FAR := 6
const COLLAPSE_FATIGUE := 32   ## 8 phases éveillé : malaise forcé
const SPECIAL_SECTORS := ["etage1", "etage2", "etage3", "etage4", "etage5", "etage6", "etage7", "etage8", "etage9", "etage10"]  ## accessibles uniquement depuis un secteur adjacent
const RefugeModel := preload("res://world/refuge_model.gd")

var store
var sectors: Dictionary = {}
var factions: Dictionary = {}
var events: Array = []
var messages: Array = []        ## messages à afficher (vidés par l'UI)
var pending_event: Dictionary = {}
var refuge  ## RefugeModel
var difficulty: Dictionary = {}  ## mode de la boucle (data/world/difficulty.json → modes.<mode>)
var gifts: Dictionary = {}       ## data/world/gifts.json
var group_scenes: Array = []     ## data/world/group_scenes.json → scenes


func _init(state_store, world_data: Dictionary, events_data: Dictionary, refuge_data: Dictionary = {},
		difficulty_data: Dictionary = {}, gifts_data: Dictionary = {}, group_data: Dictionary = {}) -> void:
	store = state_store
	group_scenes = group_data.get("scenes", [])
	difficulty = difficulty_data
	gifts = gifts_data
	refuge = RefugeModel.new(state_store, refuge_data)
	refuge.difficulty = difficulty_data
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


## Durée lisible : 3 ticks → « ¾ ph. », 6 → « 1 ½ ph. », 8 → « 2 ph. ».
static func cost_label(ticks: int) -> String:
	var whole := ticks / 4
	var frac: String = ["", "¼", "½", "¾"][ticks % 4]
	if whole == 0:
		return (frac if frac != "" else "0") + " ph."
	return "%d%s ph." % [whole, (" " + frac) if frac != "" else ""]


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
	messages.append("Trajet vers %s (%s)." % [sector(sid)["short"], cost_label(cost)])
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
		if in_repit() and a.has("encounter"):
			continue
		out.append(a)
	for gid in gifts.get("gifts", {}):
		var g: Dictionary = gifts["gifts"][gid]
		if str(g.get("node", "")) == nid and store.money() >= int(g.get("price", 0)):
			out.append({"id": "_buy_" + gid, "label": "Acheter un cadeau : %s (%d)" % [g.get("name", gid), int(g.get("price", 0))],
				"cost": 1, "fx": ["money -%d" % int(g.get("price", 0)), "item cadeau_%s 1" % gid]})
	if in_repit():
		out.append({"id": "_repit_fin", "label": "Clore le jour de répit (le temps revient au matin)", "cost": 0, "repit_end": true})
	if is_refuge(nid):
		if refuge.node_id() == nid:
			out.append({"id": "_manage", "label": "Gérer le Refuge (stock, améliorations)", "cost": 0, "panel": "refuge"})
			if store.phase() >= 2 or in_repit():
				for cid in _party_heroines():
					if not refuge.rest_done_today(cid):
						out.append({"id": "_rest_" + cid, "label": "Moment de repos avec %s" % cid.capitalize().replace("_", "-"),
							"cost": 2, "rest": true, "dialogue": "refuge:" + cid})
			if store.phase() >= 2 or in_repit():
				for gs in group_scenes:
					if _group_available(gs):
						out.append({"id": "_groupe_" + str(gs["id"]), "label": "Scène de groupe : %s" % gs.get("label", gs["id"]),
							"cost": 2, "dialogue": gs["dialogue"], "groupe": gs})
			for cid in _party_heroines():
				var gid := best_gift_for(cid)
				if gid != "" and not store.has_flag("refuge.cadeau.%s.%s" % [cid, refuge.day_key()]):
					out.append({"id": "_gift_" + cid, "label": "Offrir un cadeau à %s (%s)" % [cid.capitalize().replace("_", "-"),
						gifts["gifts"][gid].get("name", gid)], "cost": 1, "gift": gid, "to": cid})
			if not in_repit() and store.phase() <= 1 and can_start_repit():
				out.append({"id": "_repit", "label": "Déclarer un jour de répit (la Tour retient son souffle)", "cost": 0, "repit": true})
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
		refuge.mark_rest(str(a.get("id", "")).trim_prefix("_rest_"))
	if a.get("repit", false):
		start_repit()
		return {}
	if a.get("repit_end", false):
		end_repit()
		return {}
	if a.has("gift"):
		give_gift(str(a["gift"]), str(a["to"]))
	if a.has("groupe"):
		store.set_flag(_group_flag(a["groupe"]))
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


# --- Jours de répit & cadeaux (v0.9) --------------------------------------------------

func in_repit() -> bool:
	return store.has_flag("repit.actif")


func can_start_repit() -> bool:
	if str(difficulty.get("repit", "objets")) == "illimite":
		return true
	return store.item("sablier") > 0


func start_repit() -> void:
	if str(difficulty.get("repit", "objets")) != "illimite":
		store.apply_effects(["item sablier -1"])
	store.set_flag("repit.actif")
	store.set_var("repit.debut", store.ticks())
	store.add_var("repit.compte", 1)
	messages.append("Jour de répit. La Tour retient son souffle : aucune Ancre, aucune Marée, aucun combat. À la nuit, le temps reviendra à ce matin.")


func end_repit() -> void:
	if not in_repit():
		return
	store.set_var("time.ticks", int(store.get_var("repit.debut", store.ticks())))
	store.set_flag("repit.actif", false)
	store.set_var("fatigue", 0)
	messages.append("Le répit s'achève. La Tour reprend son souffle : c'est de nouveau le matin du jour %d." % store.day())
	refresh()


## Scènes de groupe (§13.3) : tous les membres dans le groupe, condition remplie, une fois ou une fois par jour.
func _group_available(gs: Dictionary) -> bool:
	for m in gs.get("members", []):
		if not store.party(str(m)):
			return false
	return store.check(str(gs.get("if", ""))) and not store.has_flag(_group_flag(gs))


func _group_flag(gs: Dictionary) -> String:
	if gs.get("once", false):
		return "refuge.groupe.%s" % gs["id"]
	return "refuge.groupe.%s.%s" % [gs["id"], refuge.day_key()]


## Le meilleur cadeau du sac pour une héroïne : adoré > apprécié > n'importe lequel.
func best_gift_for(cid: String) -> String:
	var best := ""
	var best_score := -1
	for gid in gifts.get("gifts", {}):
		if store.item("cadeau_" + gid) <= 0:
			continue
		var g: Dictionary = gifts["gifts"][gid]
		var score := 2 if g.get("loves", []).has(cid) else (1 if g.get("likes", []).has(cid) else 0)
		if score > best_score:
			best_score = score
			best = gid
	return best


func give_gift(gid: String, cid: String) -> void:
	var g: Dictionary = gifts.get("gifts", {}).get(gid, {})
	var tier := "loves" if g.get("loves", []).has(cid) else ("likes" if g.get("likes", []).has(cid) else "neutral")
	var bonus: int = {"loves": 8, "likes": 4, "neutral": 1}[tier]
	store.apply_effects(["item cadeau_%s -1" % gid, "add aff.%s %d" % [cid, bonus]])
	store.set_flag("refuge.cadeau.%s.%s" % [cid, refuge.day_key()])
	var text: String = g.get("reactions", {}).get(cid, gifts.get("default_reactions", {}).get(tier, ""))
	messages.append("%s (Affinité +%d)" % [text, bonus])


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
		if in_repit() and store.phase() == 3:
			end_repit()
			return
		if store.phase() != before:
			refresh()
			if _check_events():
				return
	if int(store.get_var("fatigue", 0)) >= COLLAPSE_FATIGUE:
		store.apply_effects(["money -10"])
		if store.phase() >= 2:
			messages.append("Tu t'effondres d'épuisement. Tu te réveilles à l'aube, détroussé (−10).")
			store.sleep_until_dawn()
		else:
			# Malaise à l'aube ou en journée : deux phases perdues, pas une journée entière.
			messages.append("Tu t'effondres d'épuisement. Tu te réveilles deux phases plus tard, détroussé (−10).")
			store.set_var("time.ticks", store.ticks() + 2 * 4)
			store.set_var("fatigue", 0)
		refresh()
	_check_events()


## Cherche l'événement prioritaire déclenchable ici et maintenant, et le met en attente.
func _check_events() -> bool:
	if not pending_event.is_empty():
		return true
	if in_repit():
		return false
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
