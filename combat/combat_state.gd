extends RefCounted
## Logique de combat (pure) : grilles 3×3, frise CTB, compétences, intentions ennemies,
## Pressentiment (intentions visibles) et Réécriture (retour à l'état avant la dernière action).
## Voir GDD §9 et §10.9.

const CombatUnit := preload("res://combat/combat_unit.gd")

signal logged(text: String)

var units: Array = []
var skills: Dictionary = {}
var rng := RandomNumberGenerator.new()
const MANA_REGEN := 4            ## mana récupéré à chaque action (évite les fins de combat à la seule Garde)
var reveal_count: int = 2       ## Pressentiment niveau 1 : 2 premières cases ennemies
var rewrite_charges: int = 0
var turn: int = 0
var log_lines: Array = []
var _rewind: Dictionary = {}


# --- Mise en place -------------------------------------------------------------

## party : Array de dictionnaires personnage (data/characters/*.json) ;
## encounter : data/combat/encounters.json ; enemy_db : data/combat/enemies.json
func setup(party: Array, encounter: Dictionary, enemy_db: Dictionary, skill_db: Dictionary, seed_value: int = 0) -> void:
	skills = skill_db
	units = []
	rng.seed = seed_value if seed_value != 0 else randi()
	var positions: Dictionary = encounter.get("party_positions", {})
	for c in party:
		var cb: Dictionary = c.get("combat", {})
		if cb.is_empty():
			continue
		var pos: Array = positions.get(c["id"], cb.get("position", [0, 1]))
		units.append(_make_unit(c["id"], c["id"], c.get("name", c["id"]), "ally", pos, cb, c.get("palette", [])))
	var counts := {}
	for e in encounter.get("enemies", []):
		var def: Dictionary = enemy_db.get(e["id"], {})
		counts[e["id"]] = counts.get(e["id"], 0) + 1
		var uid := "%s#%d" % [e["id"], counts[e["id"]]]
		var u = _make_unit(uid, e["id"], def.get("name", e["id"]), "enemy", [e.get("row", 0), e.get("lane", 1)], def, [])
		u.boss = def.get("boss", false)
		u.color = def.get("color", "#c0392b")
		u.atk *= float(encounter.get("atk_mult", 1.0))  # difficulté propre à la rencontre (tutoriels plus doux)
		u.phases = def.get("phases", []).duplicate(true)
		u.rule = str(def.get("rule", ""))
		units.append(u)
	for u in units:
		u.ctb = _turn_delay(u, 100) * rng.randf_range(0.8, 1.0)
	for u in alive("enemy"):
		plan_intent(u)


func _make_unit(uid: String, base_id: String, display: String, side: String, pos: Array, cb: Dictionary, palette: Array):
	var u = CombatUnit.new()
	var st: Dictionary = cb.get("stats", {})
	u.uid = uid
	u.base_id = base_id
	u.name = display
	u.side = side
	u.row = int(pos[0])
	u.lane = int(pos[1])
	u.max_hp = int(st.get("hp", 100))
	u.hp = u.max_hp
	u.atk = float(st.get("atk", 10))
	u.def = float(st.get("def", 5))
	u.spd = float(st.get("spd", 10))
	u.max_mana = int(st.get("mana", 50))
	u.mana = u.max_mana
	u.skills = cb.get("skills", []).duplicate()
	if palette.size() > 2:
		u.color = palette[2]
	return u


# --- Requêtes --------------------------------------------------------------------

func alive(side: String) -> Array:
	return units.filter(func(u): return u.side == side and u.is_alive())


func unit(uid: String):
	for u in units:
		if u.uid == uid:
			return u
	return null


func unit_at(side: String, row: int, lane: int):
	for u in units:
		if u.side == side and u.row == row and u.lane == lane and u.is_alive():
			return u
	return null


func other_side(side: String) -> String:
	return "enemy" if side == "ally" else "ally"


func front_row(side: String) -> int:
	var best := 3
	for u in alive(side):
		best = min(best, u.row)
	return best


func result() -> String:
	if alive("enemy").is_empty():
		return "win"
	if alive("ally").is_empty():
		return "lose"
	return ""


func skill(id: String) -> Dictionary:
	return skills.get(id, {})


func can_use(actor, skill_id: String) -> bool:
	var s := skill(skill_id)
	if s.is_empty():
		return false
	if s.get("awaken", false) and actor.awaken < 100:
		return false
	if actor.mana < int(s.get("cost", 0)):
		return false
	var rows: Array = s.get("from_rows", [])
	if not rows.is_empty() and not rows.map(func(r): return int(r)).has(actor.row):  # JSON : nombres flottants
		return false
	return not valid_targets(actor, skill_id).is_empty()


func valid_targets(actor, skill_id: String) -> Array:
	var s := skill(skill_id)
	var foes := alive(other_side(actor.side))
	var friends := alive(actor.side)
	match s.get("target", "melee"):
		"melee":
			var fr := front_row(other_side(actor.side))
			return foes.filter(func(u): return u.row == fr)
		"ranged", "pierce", "row", "all_enemies":
			return foes
		"ally", "all_allies":
			return friends
		"all_allies_any":
			return units.filter(func(u): return u.side == actor.side and not u.fled)
		"ally_other":
			return friends.filter(func(u): return u != actor)
		"self":
			return [actor]
		"ally_ko":
			return units.filter(func(u): return u.side == actor.side and u.hp <= 0 and not u.fled)
	return []


func needs_target_choice(skill_id: String) -> bool:
	return not ["self", "all_allies", "all_allies_any", "all_enemies"].has(skill(skill_id).get("target", "melee"))


func affected(actor, skill_id: String, target) -> Array:
	var s := skill(skill_id)
	match s.get("target", "melee"):
		"pierce":
			return alive(target.side).filter(func(u): return u.lane == target.lane)
		"row":
			return alive(target.side).filter(func(u): return u.row == target.row)
		"all_enemies":
			return alive(other_side(actor.side))
		"all_allies":
			return alive(actor.side)
		"all_allies_any":
			return units.filter(func(u): return u.side == actor.side and not u.fled)
		"self":
			return [actor]
	return [target] if target != null else []


## Ordre prévisionnel des prochains tours (frise CTB).
func timeline(count: int = 8) -> Array:
	var sim := {}
	for u in units:
		if u.is_alive():
			sim[u.uid] = u.ctb
	var order := []
	if sim.is_empty():
		return order
	for i in count:
		var best_uid := ""
		for k in sim:
			if best_uid == "" or sim[k] < sim[best_uid]:
				best_uid = k
		order.append(best_uid)
		sim[best_uid] += _turn_delay(unit(best_uid), 100)
	return order


## Pressentiment : seules les N premières cases ennemies (avant → arrière) montrent leur intention.
func intent_visible(enemy) -> bool:
	var sorted := alive("enemy")
	sorted.sort_custom(func(a, b): return a.row * 3 + a.lane < b.row * 3 + b.lane)
	return sorted.find(enemy) != -1 and sorted.find(enemy) < reveal_count


# --- Déroulement -------------------------------------------------------------------

## Fait avancer la frise et renvoie l'unité qui agit. Gère l'étourdissement.
func begin_turn():
	var actors := units.filter(func(u): return u.is_alive())
	if actors.is_empty():
		return null
	actors.sort_custom(func(a, b): return a.ctb < b.ctb)
	var actor = actors[0]
	var elapsed: float = actor.ctb
	for u in actors:
		u.ctb -= elapsed
	turn += 1
	return actor


## À appeler quand l'acteur ne peut pas agir (étourdi) : consomme le statut et repousse son tour.
func skip_if_stunned(actor) -> bool:
	if actor.has_status("stun"):
		actor.statuses["stun"] -= 1
		_log("%s est étourdi et perd son tour." % actor.name)
		_end_action(actor, 100)
		return true
	return false


func take_snapshot() -> void:
	_rewind = snapshot()


func can_rewrite() -> bool:
	return rewrite_charges > 0 and not _rewind.is_empty()


## Réécriture (§9.2) : rétablit l'état avant la dernière action du joueur.
func rewrite() -> bool:
	if not can_rewrite():
		return false
	var charges := rewrite_charges - 1
	restore(_rewind)
	rewrite_charges = charges
	_rewind = {}
	_log("[Registre] Réécriture. Le temps se replie.")
	return true


func use_skill(actor, skill_id: String, target) -> void:
	var s := skill(skill_id)
	actor.mana -= int(s.get("cost", 0))
	if s.get("awaken", false):
		actor.awaken = 0
	else:
		actor.awaken = min(100, actor.awaken + 8)
	_log("%s utilise %s." % [actor.name, s.get("name", skill_id)])
	if actor.side == "ally" and int(s.get("cost", 0)) > 0:
		_hear_noise(actor)
	for tgt in affected(actor, skill_id, target):
		for eff in s.get("effects", []):
			_apply(actor, tgt, eff)
	if s.has("self_effects"):
		for eff in s["self_effects"]:
			_apply(actor, actor, eff)
	_end_action(actor, int(s.get("weight", 100)))


func _end_action(actor, weight: int) -> void:
	if actor.has_status("poison") and actor.is_alive():
		var pdmg := int(max(1.0, round(actor.max_hp * (0.03 if actor.boss else 0.06))))
		actor.hp = max(0, actor.hp - pdmg)
		_log("  %s souffre du poison (%d)." % [actor.name, pdmg])
		if actor.hp == 0:
			_log("  %s tombe." % actor.name)
		else:
			_check_phase(actor)
	for k in actor.statuses.keys():
		if k == "stun":
			continue
		actor.statuses[k] -= 1
		if actor.statuses[k] <= 0:
			actor.statuses.erase(k)
	actor.mana = min(actor.max_mana, actor.mana + MANA_REGEN)
	actor.ctb += _turn_delay(actor, weight)
	if actor.side == "enemy" and actor.is_alive():
		plan_intent(actor)
	for e in alive("enemy"):
		if e.intent.is_empty() or unit(e.intent.get("target", "")) == null or not unit(e.intent["target"]).is_alive():
			plan_intent(e)


func _turn_delay(u, weight: int) -> float:
	return float(weight) * 100.0 / max(1.0, u.spd)


# --- Effets --------------------------------------------------------------------------

func _apply(actor, tgt, eff: Dictionary) -> void:
	match eff.get("type", ""):
		"damage":
			_damage(actor, tgt, eff)
		"heal":
			var amount := int(round(tgt.max_hp * float(eff.get("pct", 0.25))))
			tgt.hp = min(tgt.max_hp, tgt.hp + amount)
			_log("  %s récupère %d PV." % [tgt.name, amount])
		"status":
			if rng.randf() <= float(eff.get("chance", 1.0)):
				tgt.statuses[eff["status"]] = int(eff.get("turns", 1))
				_log("  %s : %s (%d tour(s))." % [tgt.name, _status_name(eff["status"]), int(eff.get("turns", 1))])
		"fear":
			tgt.fear += int(eff.get("value", 10))
			if tgt.side == "enemy" and not tgt.boss and tgt.fear >= 100 and tgt.is_alive():
				tgt.fled = true
				_log("  %s, terrorisé, prend la fuite !" % tgt.name)
		"delay":
			tgt.ctb += float(eff.get("value", 300))
			_log("  %s est repoussé dans la frise." % tgt.name)
		"haste":
			tgt.ctb = max(0.0, tgt.ctb - float(eff.get("value", 300)))
		"revive":
			if tgt.hp <= 0:
				tgt.hp = int(round(tgt.max_hp * float(eff.get("pct", 0.3))))
				_log("  %s se relève !" % tgt.name)
		"cleanse":
			for s in ["stun", "immobile", "mark", "poison", "charm"]:
				tgt.statuses.erase(s)
			tgt.fear = 0
		"crit_next":
			tgt.crit_next = true
		"swap":
			if tgt != actor:
				var r: int = actor.row
				var l: int = actor.lane
				actor.row = tgt.row
				actor.lane = tgt.lane
				tgt.row = r
				tgt.lane = l
				_log("  %s et %s échangent leurs places." % [actor.name, tgt.name])
		"pull":
			if tgt.row > 0:
				var occupant = unit_at(tgt.side, 0, tgt.lane)
				if occupant == null:
					tgt.row = 0
				else:
					occupant.row = tgt.row
					tgt.row = 0
				_log("  %s est attiré en première ligne." % tgt.name)
		"advance":
			if actor.row > 0 and unit_at(actor.side, actor.row - 1, actor.lane) == null:
				actor.row -= 1
				_log("  %s avance d'une ligne." % actor.name)
		"awaken":
			tgt.awaken = min(100, tgt.awaken + int(eff.get("value", 20)))


func _damage(actor, tgt, eff: Dictionary) -> void:
	if not tgt.is_alive():
		return
	var exec_below := float(eff.get("execute_below", 0.0))
	if exec_below > 0.0 and tgt.hp_ratio() <= exec_below and not tgt.boss:
		tgt.hp = 0
		_log("  %s est exécuté !" % tgt.name)
		return
	var raw: float = actor.atk * float(eff.get("power", 1.0)) * rng.randf_range(0.9, 1.1)
	var crit: bool = actor.crit_next or rng.randf() < 0.05 or (tgt.has_status("mark") and rng.randf() < 0.3) \
		or (eff.get("crit_if_full", false) and tgt.hp == tgt.max_hp)
	if crit:
		raw *= 1.5
	actor.crit_next = false
	if not eff.get("ignore_def", false):
		raw *= 100.0 / (100.0 + tgt.def * 3.0)
	if tgt.has_status("guard"):
		raw *= 0.6
	var dmg := int(max(1.0, round(raw)))
	tgt.hp = max(0, tgt.hp - dmg)
	tgt.awaken = min(100, tgt.awaken + int(round(float(dmg) / float(tgt.max_hp) * 60.0)))
	_log("  %s subit %d dégâts%s." % [tgt.name, dmg, " (critique)" if crit else ""])
	if tgt.hp == 0:
		_log("  %s tombe." % tgt.name)
		return
	_check_phase(tgt)
	# Garde du Lotus : riposte aux coups portés par l'autre camp (jamais en chaîne)
	if tgt.has_status("counter") and actor.side != tgt.side and actor.is_alive() and not eff.get("_counter", false):
		_log("  %s riposte !" % tgt.name)
		_damage(tgt, actor, {"power": 0.7, "_counter": true})


## Paliers de boss : sous un seuil de PV, le Gardien change de comportement (une seule fois par palier).
func _check_phase(u) -> void:
	while u.phase_idx < u.phases.size() and u.hp_ratio() <= float(u.phases[u.phase_idx].get("below", 0.0)):
		var ph: Dictionary = u.phases[u.phase_idx]
		u.phase_idx += 1
		u.atk *= float(ph.get("atk_mult", 1.0))
		u.spd *= float(ph.get("spd_mult", 1.0))
		u.def *= float(ph.get("def_mult", 1.0))
		for sid in ph.get("add_skills", []):
			if not u.skills.has(sid):
				u.skills.append(sid)
		u.mana = u.max_mana
		_log("  [%s] %s" % [u.name, ph.get("log", "change de forme !")])
		plan_intent(u)


## Règle « bruit » (étage 2) : chaque compétence coûteuse d'un allié enrage le Gardien.
func _hear_noise(actor) -> void:
	for e in alive("enemy"):
		if e.rule == "bruit" and e.rage < 12:
			e.rage += 1
			e.atk *= 1.04
			_log("  %s entend %s (rage %d)." % [e.name, actor.name, e.rage])


func _status_name(s: String) -> String:
	return {"stun": "étourdi", "immobile": "immobilisé", "guard": "protégé", "mark": "marqué", "charm": "charmé",
		"poison": "empoisonné", "counter": "en garde du Lotus"}.get(s, s)


# --- IA ennemie ----------------------------------------------------------------------

func plan_intent(enemy) -> void:
	var best := {}
	var best_score := -1.0
	for sid in enemy.skills:
		if not can_use(enemy, sid):
			continue
		var s := skill(sid)
		var targets := valid_targets(enemy, sid)
		if targets.is_empty():
			continue
		var score := float(s.get("ai_weight", 1.0)) * rng.randf_range(0.7, 1.3)
		var target = _ai_target(enemy, s, targets)
		if _would_kill(enemy, s, target):
			score += 0.6
		if score > best_score:
			best_score = score
			best = {"skill": sid, "target": target.uid}
	enemy.intent = best


## Choix de cible ennemi (v0.8) : achever une cible > viser un soigneur > la cible la plus entamée.
func _ai_target(enemy, s: Dictionary, targets: Array):
	var killable := targets.filter(func(t): return _would_kill(enemy, s, t))
	if not killable.is_empty():
		return killable[0]
	var healers := targets.filter(func(t): return t.skills.any(func(sid): return skill(sid).get("effects", []).any(
		func(e): return e.get("type", "") == "heal")))
	if not healers.is_empty() and rng.randf() < (0.6 if enemy.boss else 0.35):
		return healers[rng.randi_range(0, healers.size() - 1)]
	var sorted := targets.duplicate()
	sorted.sort_custom(func(a, b): return a.hp_ratio() < b.hp_ratio())
	return sorted[0]


func _would_kill(enemy, s: Dictionary, t) -> bool:
	var power := 0.0
	for e in s.get("effects", []):
		if e.get("type", "") == "damage":
			power += float(e.get("power", 1.0))
	if power <= 0.0:
		return false
	return enemy.atk * power * 100.0 / (100.0 + t.def * 3.0) >= t.hp


## Politique automatique pour un allié (mode test, combat auto) :
## ultime > relever un KO > soigner sous 50 % > meilleure attaque > garde.
func auto_action(actor) -> Dictionary:
	var usable: Array = actor.skills.filter(func(sid): return can_use(actor, sid))
	if usable.is_empty():
		return {}
	var friends := alive(actor.side)
	var wounded := friends.filter(func(u): return u.hp_ratio() < 0.5)
	var best := {}
	var best_score := -1.0
	for sid in usable:
		var s := skill(sid)
		var types: Array = s.get("effects", []).map(func(e): return e.get("type", ""))
		var targets := valid_targets(actor, sid)
		targets.sort_custom(func(a, b): return a.hp_ratio() < b.hp_ratio())
		var score := 0.0
		if s.get("awaken", false):
			score = 100.0
		elif types.has("revive") and s.get("target", "") == "ally_ko":
			score = 90.0
		elif types.has("heal"):
			score = 80.0 if not wounded.is_empty() else -1.0
		elif types.has("damage"):
			var power := 0.0
			for e in s["effects"]:
				if e.get("type") == "damage":
					power = float(e.get("power", 1.0))
			var spread := affected(actor, sid, targets[0]).size()
			score = 10.0 + power * 10.0 * spread - float(s.get("cost", 0)) * 0.1
		elif types.has("status") and s.get("target", "") in ["ranged", "melee"]:
			score = 8.0
		else:
			score = 1.0
		if score > best_score:
			best_score = score
			best = {"skill": sid, "target": targets[0]}
	return best


## Exécute l'intention planifiée d'un ennemi. Un ennemi charmé frappe l'un de ses alliés.
func run_enemy_turn(enemy) -> void:
	if enemy.has_status("charm"):
		var others := alive(enemy.side).filter(func(u): return u != enemy)
		if not others.is_empty():
			var victim = others[rng.randi_range(0, others.size() - 1)]
			_log("%s, charmé, se retourne contre %s !" % [enemy.name, victim.name])
			_damage(enemy, victim, {"power": 1.0})
			_end_action(enemy, 100)
			return
	if enemy.intent.is_empty():
		plan_intent(enemy)
	if enemy.intent.is_empty():
		_end_action(enemy, 100)
		return
	var target = unit(enemy.intent["target"])
	if target == null or not target.is_alive() or not valid_targets(enemy, enemy.intent["skill"]).has(target):
		plan_intent(enemy)
		target = unit(enemy.intent.get("target", ""))
	if target == null:
		_end_action(enemy, 100)
		return
	use_skill(enemy, enemy.intent["skill"], target)


# --- Snapshot ------------------------------------------------------------------------

func snapshot() -> Dictionary:
	return {"units": units.map(func(u): return u.to_dict()), "rng_state": rng.state, "turn": turn,
			"rewrite_charges": rewrite_charges, "log_size": log_lines.size()}


func restore(d: Dictionary) -> void:
	units = []
	for ud in d["units"]:
		var u = CombatUnit.new()
		u.from_dict(ud)
		units.append(u)
	rng.state = d["rng_state"]
	turn = d["turn"]
	rewrite_charges = d["rewrite_charges"]


func _log(text: String) -> void:
	log_lines.append(text)
	logged.emit(text)
