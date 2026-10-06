extends Control
## Écran de carte : barre de temps, carte stratégique, graphe du secteur, actions du nœud.
## La logique est dans world/world_model.gd ; cette scène relaie les demandes à main.gd.

signal dialogue_requested(ref: String)
signal combat_requested(encounter: String, win_fx: Array)
signal options_requested

const UI := preload("res://ui/ui_style.gd")
const MapView := preload("res://scenes/world/map_view.gd")
const GraphView := preload("res://scenes/world/graph_view.gd")
const RegistrePanel := preload("res://scenes/world/registre_panel.gd")
const RefugePanel := preload("res://scenes/world/refuge_panel.gd")
const SavePanel := preload("res://scenes/save_panel.gd")

var model
var autopilot := false
var _top: Label
var _pressure: Label
var _phase_bar: HBoxContainer
var _map: Control
var _graph: Control
var _sector_title: Label
var _sector_desc: Label
var _node_title: Label
var _node_desc: Label
var _actions: VBoxContainer
var _log: RichTextLabel
var _registre: Control
var _busy := false
var _last_autosave := -1


func _ready() -> void:
	model = GameState.world
	UI.full_rect(self)
	var bg := ColorRect.new()
	bg.color = UI.BG
	add_child(UI.full_rect(bg))
	var root := VBoxContainer.new()
	UI.full_rect(root)
	root.offset_left = 16
	root.offset_right = -16
	root.offset_top = 10
	root.offset_bottom = -10
	root.add_theme_constant_override("separation", 8)
	add_child(root)

	# Barre du haut : date, phases, Pression, ressources
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 18)
	root.add_child(top)
	_top = UI.label("", 22, UI.GOLD)
	top.add_child(_top)
	_phase_bar = HBoxContainer.new()
	_phase_bar.add_theme_constant_override("separation", 3)
	top.add_child(_phase_bar)
	_pressure = UI.label("", 20, UI.MAGENTA)
	top.add_child(_pressure)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(spacer)
	var reg := UI.button("Registre", 20, UI.GOLD)
	reg.pressed.connect(_toggle_registre)
	top.add_child(reg)
	var sv_btn := UI.button("Sauvegarder", 20, UI.GOLD)
	sv_btn.pressed.connect(_open_save)
	top.add_child(sv_btn)
	var opt := UI.button("Options", 20)
	opt.pressed.connect(func(): options_requested.emit())
	top.add_child(opt)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	root.add_child(body)

	var left := PanelContainer.new()
	left.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.CYAN.darkened(0.5), 1))
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 0.8
	body.add_child(left)
	var lv := VBoxContainer.new()
	left.add_child(lv)
	lv.add_child(UI.label("SÉOUL — carte stratégique", 18, UI.CYAN))
	_map = MapView.new()
	_map.model = model
	_map.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_map.sector_clicked.connect(_on_sector)
	lv.add_child(_map)

	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_stretch_ratio = 1.2
	body.add_child(right)
	var sp := PanelContainer.new()
	sp.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.MAGENTA.darkened(0.5), 1))
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(sp)
	var sv := VBoxContainer.new()
	sp.add_child(sv)
	_sector_title = UI.label("", 24, UI.MAGENTA)
	sv.add_child(_sector_title)
	_sector_desc = UI.label("", 16, UI.DIM)
	_sector_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sv.add_child(_sector_desc)
	_graph = GraphView.new()
	_graph.model = model
	_graph.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_graph.node_clicked.connect(_on_node)
	sv.add_child(_graph)

	var bottom := HBoxContainer.new()
	bottom.custom_minimum_size = Vector2(0, 280)
	bottom.add_theme_constant_override("separation", 12)
	root.add_child(bottom)
	var np := PanelContainer.new()
	np.add_theme_stylebox_override("panel", UI.box())
	np.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom.add_child(np)
	var nv := VBoxContainer.new()
	np.add_child(nv)
	_node_title = UI.label("", 22, UI.CYAN)
	nv.add_child(_node_title)
	_node_desc = UI.label("", 17, UI.TEXT)
	_node_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nv.add_child(_node_desc)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	nv.add_child(scroll)
	_actions = VBoxContainer.new()
	_actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_actions)
	var lp := PanelContainer.new()
	lp.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.DIM.darkened(0.5), 1))
	lp.custom_minimum_size = Vector2(620, 0)
	bottom.add_child(lp)
	_log = RichTextLabel.new()
	_log.scroll_following = true
	_log.add_theme_font_size_override("normal_font_size", 16)
	lp.add_child(_log)

	_registre = RegistrePanel.new()
	_registre.visible = false
	add_child(_registre)
	refresh()


## À appeler au retour d'un dialogue ou d'un combat.
func refresh() -> void:
	model.refresh()
	for m in model.messages:
		_log.append_text("• %s\n" % m)
	model.messages.clear()
	var st = GameState.store
	_top.text = "JOUR %d — %s   ·   Boucle %d   ·   Argent %d   ·   Rations %d   ·   Fatigue %d/28" % [
		st.day(), GameState.phase_name(), st.loop(), st.money(), st.item("ration"), int(st.get_var("fatigue", 0))]
	_pressure.text = "Pression de la Tour : %d" % int(st.pressure())
	for c in _phase_bar.get_children():
		c.queue_free()
	for i in 16:
		var r := ColorRect.new()
		r.custom_minimum_size = Vector2(10 if i % 4 != 3 else 14, 18)
		r.color = UI.GOLD if i < st.ticks() % 16 + 1 else Color(1, 1, 1, 0.1)
		_phase_bar.add_child(r)
	var sec: Dictionary = model.sector(model.sector_id())
	var fac: Dictionary = model.factions.get(sec.get("controller", ""), {})
	_sector_title.text = "%s   —   %s   %s" % [sec.get("name", "?"), fac.get("name", ""), "★".repeat(int(sec.get("danger", 1)))]
	_sector_desc.text = sec.get("desc", "")
	var n: Dictionary = model.node(model.node_id())
	_node_title.text = n.get("name", "?") + ("   (refuge)" if model.is_refuge(model.node_id()) else "")
	_node_desc.text = n.get("desc", "")
	for c in _actions.get_children():
		c.queue_free()
	for a in model.actions():
		var label: String = a.get("label", "?")
		if a.get("rest", false):
			label = "Moment de repos avec %s" % DataDB.display_name(str(a["id"]).substr(6))
		var cost := int(a.get("cost", 2))
		if cost > 0:
			label += "   [%s]" % _cost_text(cost)
		var b := UI.button(label, 18, UI.GOLD if a.has("encounter") else UI.CYAN)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.pressed.connect(_on_action.bind(a))
		_actions.add_child(b)
	if _actions.get_child_count() == 0:
		_actions.add_child(UI.label("Rien à faire ici. Clique sur une zone voisine (cercle bleu) ou un secteur.", 16, UI.DIM))
	_map.queue_redraw()
	_graph.queue_redraw()
	if visible:
		MusicManager.play_context("night" if st.phase() == 3 else str(sec.get("music", "")))
	if _registre.visible:
		_registre.refresh()
	_autosave(st)
	_check_event.call_deferred()


## Sauvegarde automatique à chaque nouvelle phase passée sur la carte.
func _autosave(st) -> void:
	var key: int = st.day() * 4 + st.phase()
	if key != _last_autosave and not _busy:
		_last_autosave = key
		SaveManager.autosave()


func _open_save() -> void:
	if _busy:
		return
	var p := SavePanel.new()
	p.mode = "save"
	p.slot_chosen.connect(_save_to)
	add_child(p)


func _open_refuge() -> void:
	var p := RefugePanel.new()
	p.refuge = model.refuge
	p.time_spent.connect(func(t): model.advance(t))
	p.closed.connect(_close_refuge.bind(p))
	add_child(p)


func _save_to(slot: String) -> void:
	SaveManager.save(slot)
	_log.append_text("• Partie sauvegardée (emplacement %s).\n" % slot)


func _close_refuge(p: Control) -> void:
	p.queue_free()
	refresh()


func _cost_text(ticks: int) -> String:
	return "%d ph." % int(ticks / 4.0) if ticks % 4 == 0 else "%d/4 ph." % ticks


func _check_event() -> void:
	if _busy:
		return
	var ev: Dictionary = model.take_event()
	if OS.get_cmdline_user_args().has("--autotest") and not ev.is_empty():
		print("[autotest] événement %s (J%d %s, %s)" % [ev["id"], GameState.day, GameState.phase_name(), model.node_id()])
	if not ev.is_empty():
		_busy = true
		dialogue_requested.emit(str(ev["dialogue"]))


## main.gd rappelle ceci après un dialogue/combat lancé depuis la carte.
func resume() -> void:
	_busy = false
	visible = true
	refresh()


func _on_sector(sid: String) -> void:
	if _busy or sid == model.sector_id():
		return
	if model.travel(sid):
		refresh()
	else:
		_log.append_text("[color=#8a8fa3]Impossible d'aller à %s d'ici.[/color]\n" % model.sector(sid).get("short", sid))


func _on_node(nid: String) -> void:
	if _busy:
		return
	if model.move(nid):
		refresh()
	elif nid != model.node_id() and not model.node_open(nid):
		_log.append_text("[color=#e8b23a]%s[/color]\n" % model.node(nid).get("locked_hint", "Verrouillé."))


func _on_action(a: Dictionary) -> void:
	if _busy:
		return
	var res: Dictionary = model.do_action(a)
	if res.has("panel"):
		_open_refuge()
		return
	if res.has("encounter"):
		_busy = true
		combat_requested.emit(res["encounter"], res.get("win_fx", []))
	elif res.has("dialogue"):
		_busy = true
		dialogue_requested.emit(res["dialogue"])
	else:
		refresh()


func _toggle_registre() -> void:
	_registre.visible = not _registre.visible
	if _registre.visible:
		_registre.refresh()


# --- Autopilote (tests headless) : suit tests/autopilot.json jusqu'à la fin de l'acte -------------

var _route: Array = []
## Mesure du temps libre (ticks de jour, phases 0–2, où l'itinéraire n'avait rien d'obligatoire à faire).
var idle_ticks := 0


func autopilot_step() -> void:
	if _busy:
		return
	if _route.is_empty():
		_route = DataDB.load_json("res://tests/autopilot.json").get("route", [])
	var st = GameState.store
	for leg in _route:
		if st.check(str(leg["until"])):
			continue
		var target: String = leg["go"]
		if OS.get_environment("AUTOPILOT_DEBUG") != "":
			print("[autopilot] J%d p%d %s → %s/%s" % [st.day(), st.phase(), model.node_id(), target, leg["do"]])
		if model.node_id() != target:
			var step: Dictionary = model.path_step(target)
			if step.has("travel"):
				_on_sector(step["travel"])
			elif step.has("move"):
				_on_node(step["move"])
			else:
				_wait(4)
			return
		for a in model.actions():
			if a.get("id", "") == leg["do"] or (leg["do"] == "sleep" and a.get("sleep", false)):
				if a.get("sleep", false) and st.phase() < 3:
					idle_ticks += 12 - st.ticks() % 16
				_on_action(a)
				return
		_count_idle(2)
		_wait(2)
		return
	_count_idle(4)
	_wait(4)


func _count_idle(ticks: int) -> void:
	if GameState.store.phase() < 3:
		idle_ticks += ticks


func _wait(ticks: int) -> void:
	model.advance(ticks)
	refresh()
