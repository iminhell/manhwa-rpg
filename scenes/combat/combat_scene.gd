extends Control
## Scène de combat tactique : deux grilles 3×3, frise CTB, compétences, Réécriture.
## La logique est dans combat/combat_state.gd.

signal finished(result: String)

const UI := preload("res://ui/ui_style.gd")
const CombatState := preload("res://combat/combat_state.gd")
const UnitCard := preload("res://scenes/combat/unit_card.gd")

const ENEMY_DELAY := 0.7

var state: CombatState
var auto_battle := false     ## mode test : les alliés jouent seuls
var _actor = null
var _pending_skill: String = ""
var _rewind_actor: String = ""
var _ally_grid: GridContainer
var _enemy_grid: GridContainer
var _timeline: HBoxContainer
var _skills_box: HFlowContainer
var _actor_label: Label
var _hint: Label
var _log: RichTextLabel
var _rewrite_btn: Button
var _over := false


func setup(encounter_id: String, party_ids: Array, seed_value: int = 0) -> void:
	var enc: Dictionary = DataDB.encounters.get(encounter_id, {})
	var party := []
	# Duels et combats imposés : la rencontre peut fixer son propre groupe ("party").
	for id in enc.get("party", GameState.squad(party_ids)):
		party.append(DataDB.character(id))
	state = CombatState.new()
	state.setup(party, enc, DataDB.enemies, DataDB.skills, seed_value)
	state.rewrite_charges = GameState.rewrite_charges()
	var dif: Dictionary = GameState.difficulty()
	state.apply_difficulty(float(dif.get("enemy_atk", 1.0)), float(dif.get("enemy_hp", 1.0)))
	_apply_modifiers()
	var boss: bool = enc.get("enemies", []).any(func(e): return DataDB.enemies.get(e["id"], {}).get("boss", false))
	MusicManager.play_context("boss" if boss else "combat")
	state.logged.connect(_on_log)
	_build_ui(enc)
	_on_log("— %s —" % enc.get("name", encounter_id))
	if TUTORIAL.has(encounter_id) and GameState.store.loop() == 1:
		for l in TUTORIAL[encounter_id]:
			_on_log(l)
	for l in _pending_log:
		_on_log(l)
	_rewrite_btn.visible = GameState.store.loop() >= 2  # la Réécriture n'existe qu'après la première régression
	_next_turn.call_deferred()


## Fatigue (§3.1) et équipement : la lame du forgeron Gu, etc.
func _apply_modifiers() -> void:
	var fatigue: float = GameState.fatigue_modifier()
	var elias = state.unit("elias")
	if elias == null:
		return
	elias.atk *= fatigue
	if GameState.store.item("lame_gu") > 0:
		elias.atk += 3.0
	if GameState.store.item("lame_tour") > 0:  # étage 3 : la lame qui coupe les glyphes
		elias.atk += 4.0
	if fatigue < 1.0:
		_pending_log.append("Fatigue : Elias combat à %d %% de sa force." % int(fatigue * 100))


var _pending_log: Array = []

## Premiers combats de la première boucle : quelques lignes d'aide dans le journal (voir aussi Guide → Combat).
const TUTORIAL := {
	"tuto_rodeur": [
		"AIDE — La FRISE, en haut, montre l'ordre des tours : la Vitesse décide qui agit.",
		"AIDE — À ton tour : choisis une compétence, puis une case cible dorée. « (n) » = coût en mana.",
		"AIDE — Cases magenta : ce que l'ennemi va faire au prochain tour (Pressentiment). Écarte-toi ou frappe avant.",
	],
	"j1_maree": [
		"AIDE — Deux grilles de 3 × 3 : la mêlée ne touche que la rangée avant ennemie ; certaines compétences ne partent que de certaines rangées.",
		"AIDE — La barre dorée, l'Éveil, se remplit à chaque action ; pleine, elle libère la technique ultime (bouton doré).",
	],
}


func _build_ui(enc: Dictionary) -> void:
	UI.full_rect(self)
	add_child(UI.background(AssetDB.background(enc.get("background", "black"))))
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.45)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(UI.full_rect(shade))

	var root := VBoxContainer.new()
	UI.full_rect(root)
	root.offset_left = 24
	root.offset_right = -24
	root.offset_top = 16
	root.offset_bottom = -16
	root.add_theme_constant_override("separation", 12)
	add_child(root)

	var top := HBoxContainer.new()
	root.add_child(top)
	top.add_child(UI.label("FRISE  ", 20, UI.GOLD))
	_timeline = HBoxContainer.new()
	_timeline.add_theme_constant_override("separation", 6)
	top.add_child(_timeline)

	var field := HBoxContainer.new()
	field.size_flags_vertical = Control.SIZE_EXPAND_FILL
	field.alignment = BoxContainer.ALIGNMENT_CENTER
	field.add_theme_constant_override("separation", 80)
	root.add_child(field)
	_ally_grid = _make_grid()
	_enemy_grid = _make_grid()
	field.add_child(_side_column("ALLIÉS   (arrière · milieu · avant)", _ally_grid, UI.CYAN))
	field.add_child(_side_column("ENNEMIS   (avant · milieu · arrière)", _enemy_grid, UI.MAGENTA))

	var bottom := PanelContainer.new()
	bottom.add_theme_stylebox_override("panel", UI.box())
	bottom.custom_minimum_size = Vector2(0, 230)
	root.add_child(bottom)
	var bh := HBoxContainer.new()
	bh.add_theme_constant_override("separation", 16)
	bottom.add_child(bh)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bh.add_child(left)
	_actor_label = UI.label("", 26, UI.CYAN)
	left.add_child(_actor_label)
	_skills_box = HFlowContainer.new()
	_skills_box.add_theme_constant_override("h_separation", 8)
	_skills_box.add_theme_constant_override("v_separation", 8)
	left.add_child(_skills_box)
	_hint = UI.label("", 18, UI.DIM)
	left.add_child(_hint)
	var right := VBoxContainer.new()
	right.custom_minimum_size = Vector2(560, 0)
	bh.add_child(right)
	_rewrite_btn = UI.button("RÉÉCRITURE", 22, UI.GOLD)
	_rewrite_btn.pressed.connect(_on_rewrite)
	right.add_child(_rewrite_btn)
	_log = RichTextLabel.new()
	_log.scroll_following = true
	_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_log.add_theme_font_size_override("normal_font_size", 17)
	right.add_child(_log)


func _make_grid() -> GridContainer:
	var g := GridContainer.new()
	g.columns = 3
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 10)
	return g


func _side_column(title: String, grid: GridContainer, col: Color) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.add_child(UI.label(title, 18, col))
	v.add_child(grid)
	return v


# --- Boucle de tour -------------------------------------------------------------

func _next_turn() -> void:
	if _check_end():
		return
	_actor = state.begin_turn()
	if _actor == null:
		return
	if state.skip_if_stunned(_actor):
		_refresh()
		_next_turn.call_deferred()
		return
	_pending_skill = ""
	_refresh()
	if _actor.side == "enemy":
		await get_tree().create_timer(0.05 if auto_battle else ENEMY_DELAY).timeout
		if _over:
			return
		state.run_enemy_turn(_actor)
		_refresh()
		_next_turn.call_deferred()
	elif auto_battle:
		_auto_play.call_deferred()


func _auto_play() -> void:
	var act := state.auto_action(_actor)
	if not act.is_empty():
		_execute(act["skill"], act["target"])


func _on_skill(sid: String) -> void:
	if _actor == null or _actor.side != "ally":
		return
	if not state.needs_target_choice(sid):
		_execute(sid, _actor)
		return
	_pending_skill = sid
	_hint.text = "Choisis une cible pour « %s » (cases dorées)." % state.skill(sid).get("name", sid)
	_refresh()


func _on_card(uid: String) -> void:
	if _pending_skill == "":
		return
	var target = state.unit(uid)
	if target != null and state.valid_targets(_actor, _pending_skill).has(target):
		_execute(_pending_skill, target)


func _execute(sid: String, target) -> void:
	state.take_snapshot()
	_rewind_actor = _actor.uid
	state.use_skill(_actor, sid, target)
	_pending_skill = ""
	_refresh()
	_next_turn.call_deferred()


func _on_rewrite() -> void:
	if _over or _actor == null or _actor.side != "ally" or not state.rewrite():
		return
	_actor = state.unit(_rewind_actor)
	_pending_skill = ""
	_refresh()


func _check_end() -> bool:
	var r := state.result()
	if r == "":
		return false
	_over = true
	_show_result(r)
	return true


func _show_result(r: String) -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.7)
	add_child(UI.full_rect(overlay))
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	overlay.add_child(v)
	v.add_child(UI.label("VICTOIRE" if r == "win" else "LE LECTEUR TOMBE", 64, UI.GOLD if r == "win" else UI.RED))
	var b := UI.button("Continuer", 28)
	b.pressed.connect(func(): finished.emit(r))
	v.add_child(b)
	if auto_battle:
		finished.emit.call_deferred(r)


# --- Affichage ---------------------------------------------------------------------

func _refresh() -> void:
	var danger: bool = state.alive("ally").any(func(u): return u.hp_ratio() < 0.3)
	if MusicManager.current_context in ["combat", "combat.danger"]:
		MusicManager.set_danger(danger)
	_fill_grid(_ally_grid, "ally")
	_fill_grid(_enemy_grid, "enemy")
	for c in _timeline.get_children():
		c.queue_free()
	for uid in state.timeline(10):
		var u = state.unit(uid)
		var chip := UI.label(" %s " % u.name.substr(0, 10), 16, Color(u.color))
		chip.add_theme_stylebox_override("normal", UI.box(Color(0, 0, 0, 0.6), Color(u.color), 1, 4))
		_timeline.add_child(chip)
	for c in _skills_box.get_children():
		c.queue_free()
	var is_ally: bool = _actor != null and _actor.side == "ally" and not _over
	_actor_label.text = ("Tour de %s" % _actor.name) if _actor != null else ""
	if is_ally:
		for sid in _actor.skills:
			var s := state.skill(sid)
			var label := "%s%s" % [s.get("name", sid), (" (%d)" % int(s["cost"])) if int(s.get("cost", 0)) > 0 else ""]
			var b := UI.button(label, 18, UI.GOLD if s.get("awaken", false) else UI.CYAN)
			b.tooltip_text = s.get("desc", "")
			b.disabled = not state.can_use(_actor, sid)
			b.pressed.connect(_on_skill.bind(sid))
			_skills_box.add_child(b)
		if _pending_skill == "":
			_hint.text = "Mana / Éveil : barres bleue et dorée. Cases magenta : intentions ennemies (Pressentiment)."
	_rewrite_btn.disabled = not (is_ally and state.can_rewrite())
	_rewrite_btn.text = "RÉÉCRITURE (%d)" % state.rewrite_charges


func _fill_grid(grid: GridContainer, side: String) -> void:
	for c in grid.get_children():
		c.queue_free()
	var targets: Array = state.valid_targets(_actor, _pending_skill) if _pending_skill != "" else []
	for lane in 3:
		for col in 3:
			var row := 2 - col if side == "ally" else col
			var u = _unit_in_cell(side, row, lane)
			var card := UnitCard.new()
			card.setup(u, state, u != null and u == _actor, u != null and targets.has(u))
			card.clicked.connect(_on_card)
			grid.add_child(card)


func _unit_in_cell(side: String, row: int, lane: int):
	for u in state.units:
		if u.side == side and u.row == row and u.lane == lane and (u.is_alive() or u.hp <= 0 and not u.fled):
			return u
	return null


func _on_log(text: String) -> void:
	if _log != null:
		_log.append_text(text + "\n")
