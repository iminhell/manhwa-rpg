extends PanelContainer
## Case de la grille 3×3 : une unité (ou une case vide).

signal clicked(uid: String)

const UI := preload("res://ui/ui_style.gd")

var uid: String = ""


func setup(u, state, is_current: bool, targetable: bool) -> void:
	custom_minimum_size = Vector2(190, 150)
	mouse_filter = Control.MOUSE_FILTER_STOP
	if u == null:
		add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.03), Color(1, 1, 1, 0.08), 1))
		return
	uid = u.uid
	var col := Color(u.color)
	var border := UI.GOLD if targetable else (UI.CYAN if is_current else col.darkened(0.3))
	var bg := Color(col, 0.10) if u.is_alive() else Color(0.1, 0.1, 0.1, 0.6)
	add_theme_stylebox_override("panel", UI.box(bg, border, 4 if (targetable or is_current) else 2))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(v)

	var tex: Texture2D = AssetDB.sprite(u.base_id)
	if tex != null:
		var tr := TextureRect.new()
		tr.texture = tex
		tr.custom_minimum_size = Vector2(0, 60)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(tr)

	var title := UI.label(u.name if u.is_alive() else "%s (KO)" % u.name, 20, col.lightened(0.3) if u.is_alive() else UI.DIM)
	title.clip_text = true
	v.add_child(title)
	v.add_child(_bar(u.hp, u.max_hp, UI.RED))
	v.add_child(UI.label("PV %d/%d" % [u.hp, u.max_hp], 16, UI.TEXT))
	if u.side == "ally":
		v.add_child(_bar(u.mana, max(1, u.max_mana), UI.CYAN))
		v.add_child(_bar(u.awaken, 100, UI.GOLD))
	var st := []
	for k in u.statuses:
		st.append("%s %d" % [k, u.statuses[k]])
	if u.fear > 0 and u.side == "enemy":
		st.append("peur %d" % u.fear)
	if not st.is_empty():
		v.add_child(UI.label(" · ".join(st), 14, UI.DIM))
	if u.side == "enemy" and u.is_alive():
		var txt := "Intention : ???"
		if state.intent_visible(u) and not u.intent.is_empty():
			var target = state.unit(u.intent["target"])
			txt = "→ %s : %s" % [state.skill(u.intent["skill"]).get("name", "?"), target.name if target else "?"]
		v.add_child(UI.label(txt, 15, UI.MAGENTA))


func _bar(value: float, max_value: float, color: Color) -> ProgressBar:
	var b := ProgressBar.new()
	b.max_value = max_value
	b.value = value
	b.show_percentage = false
	b.custom_minimum_size = Vector2(0, 8)
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	var back := StyleBoxFlat.new()
	back.bg_color = Color(0, 0, 0, 0.5)
	b.add_theme_stylebox_override("fill", fill)
	b.add_theme_stylebox_override("background", back)
	return b


func _gui_input(event: InputEvent) -> void:
	var click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	var touch: bool = event is InputEventScreenTouch and event.pressed
	if (click or touch) and uid != "":
		clicked.emit(uid)
