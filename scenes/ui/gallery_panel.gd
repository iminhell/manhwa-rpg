extends Control
## Galerie des CG : une CG vue en jeu reste débloquée pour toutes les boucles (SaveManager.meta["cgs"]).
## Accessible depuis l'écran titre et le menu pause. Clic sur une CG débloquée : plein écran.

const UI := preload("res://ui/ui_style.gd")
const MANIFEST := "res://data/art/manifest.json"
const TILE := Vector2(320, 180)

var _viewer: TextureRect
var unlocked_count := 0
var total := 0


func _ready() -> void:
	add_to_group("modal")
	UI.full_rect(self)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.75)
	add_child(UI.full_rect(shade))
	var panel := PanelContainer.new()
	panel.anchor_left = 0.03
	panel.anchor_right = 0.97
	panel.anchor_top = 0.04
	panel.anchor_bottom = 0.96
	panel.add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.05, 0.08, 0.98), UI.MAGENTA, 3))
	add_child(panel)
	var v := VBoxContainer.new()
	panel.add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	var cgs := cg_list()
	total = cgs.size()
	unlocked_count = cgs.filter(func(c): return SaveManager.cg_unlocked(c["id"])).size()
	var t := UI.label("GALERIE   %d / %d" % [unlocked_count, total], 30, UI.MAGENTA)
	t.name = "Title"
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(t)
	var close := UI.button("Fermer", 20, UI.MAGENTA)
	close.pressed.connect(queue_free)
	head.add_child(close)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var grid := GridContainer.new()
	grid.name = "Grid"
	grid.columns = 5
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	scroll.add_child(grid)
	for c in cgs:
		grid.add_child(_tile(c))
	_viewer = TextureRect.new()
	_viewer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_viewer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	UI.full_rect(_viewer)
	_viewer.visible = false
	_viewer.gui_input.connect(func(e): if _is_click(e): _viewer.visible = false)
	add_child(_viewer)


## CG du manifeste d'art, dans l'ordre du manifeste.
static func cg_list() -> Array:
	return DataDB.load_json(MANIFEST).get("assets", []).filter(func(a): return a.get("kind", "") == "cg")


static func title_of(id: String) -> String:
	var t := id.trim_prefix("cg_").replace("_", " ")
	return t.substr(0, 1).to_upper() + t.substr(1)


func _tile(c: Dictionary) -> Control:
	var id: String = c["id"]
	var open := SaveManager.cg_unlocked(id)
	var masked: bool = open and bool(c.get("nsfw", false)) and Settings.hide_pacte_p3
	var tile := PanelContainer.new()
	tile.name = id
	tile.custom_minimum_size = TILE + Vector2(0, 34)
	tile.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.MAGENTA.darkened(0.3) if open else UI.DIM.darkened(0.5), 2))
	var v := VBoxContainer.new()
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile.add_child(v)
	var tex: Texture2D = AssetDB.cg(id) if open and not masked else null
	if tex != null:
		var tr := TextureRect.new()
		tr.texture = tex
		tr.custom_minimum_size = TILE
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(tr)
		tile.gui_input.connect(func(e): if _is_click(e): _show(tex))
		tile.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		var msg := "???" if not open else ("Masquée (option P3)" if masked else "Visuel à générer")
		var l := UI.label(msg, 26 if not open else 18, UI.DIM)
		l.custom_minimum_size = TILE
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		v.add_child(l)
	var cap := UI.label(title_of(id) if open else "Verrouillée", 16, UI.TEXT if open else UI.DIM)
	cap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cap.clip_text = true
	v.add_child(cap)
	return tile


func _show(tex: Texture2D) -> void:
	_viewer.texture = tex
	_viewer.visible = true


static func _is_click(e: InputEvent) -> bool:
	return (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT) or (e is InputEventScreenTouch and e.pressed)


func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		if _viewer.visible:
			_viewer.visible = false
		else:
			queue_free()
