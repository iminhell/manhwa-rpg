extends Control
## Galerie : catalogue data/world/gallery.json, en deux onglets (« Histoire / CG clés », « Scènes intimes »).
## Une entrée se débloque pour toutes les boucles dès que sa scène commence en jeu (SaveManager.meta["scenes"]) ;
## les CG déjà vues (meta["cgs"]) comptent aussi. Compteurs : global, par onglet, par catégorie et par voie.
## Entrée verrouillée : bouton « Indice » (condition exacte). Entrée débloquée : « Revoir » rejoue la scène dans un
## état « bac à sable », sans toucher à la partie. Entrée « prevue » : emplacement réservé, scène en préparation.
## Accessible depuis l'écran titre et le menu pause.

const UI := preload("res://ui/ui_style.gd")
const DialogueScene := preload("res://scenes/dialogue/dialogue_scene.gd")
const StateStore := preload("res://core/state_store.gd")
const MANIFEST := "res://data/art/manifest.json"
const TILE := Vector2(300, 169)

var tab := "histoire"
var cat := ""     ## "" : toutes les catégories
var route := ""   ## "" : toutes les voies
var unlocked_count := 0
var total := 0     ## entrées jouables (hors emplacements prévus)
var planned := 0   ## emplacements prévus (scène en préparation)

var _panel: PanelContainer
var _title: Label
var _tabs: HBoxContainer
var _cats: HFlowContainer
var _routes: HFlowContainer
var _grid: GridContainer
var _detail: RichTextLabel
var _viewer: TextureRect
var _replay: Control
var _prev_music := ""
var _nsfw: Dictionary = {}


func _ready() -> void:
	add_to_group("modal")
	UI.full_rect(self)
	for a in DataDB.load_json(MANIFEST).get("assets", []):
		if a.get("kind", "") == "cg":
			_nsfw[a["id"]] = bool(a.get("nsfw", false))
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.75)
	add_child(UI.full_rect(shade))
	_panel = PanelContainer.new()
	_panel.anchor_left = 0.03
	_panel.anchor_right = 0.97
	_panel.anchor_top = 0.03
	_panel.anchor_bottom = 0.97
	_panel.add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.05, 0.08, 0.98), UI.MAGENTA, 3))
	add_child(_panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	_panel.add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	_title = UI.label("", 30, UI.MAGENTA)
	_title.name = "Title"
	_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(_title)
	var close := UI.button("Fermer", 20, UI.MAGENTA)
	close.pressed.connect(queue_free)
	head.add_child(close)
	_tabs = HBoxContainer.new()
	_tabs.name = "Tabs"
	_tabs.add_theme_constant_override("separation", 10)
	v.add_child(_tabs)
	_cats = HFlowContainer.new()
	_cats.name = "Categories"
	v.add_child(_cats)
	_routes = HFlowContainer.new()
	_routes.name = "Routes"
	v.add_child(_routes)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	_grid = GridContainer.new()
	_grid.name = "Grid"
	_grid.columns = 5
	_grid.add_theme_constant_override("h_separation", 12)
	_grid.add_theme_constant_override("v_separation", 12)
	scroll.add_child(_grid)
	_detail = RichTextLabel.new()
	_detail.name = "Detail"
	_detail.bbcode_enabled = true
	_detail.custom_minimum_size = Vector2(0, 96)
	_detail.add_theme_font_size_override("normal_font_size", 19)
	_detail.add_theme_font_size_override("bold_font_size", 20)
	_detail.add_theme_font_size_override("italics_font_size", 19)
	_detail.text = "[i]« Indice » sur une scène verrouillée : la condition exacte pour la débloquer.[/i]"
	v.add_child(_detail)
	_viewer = TextureRect.new()
	_viewer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_viewer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	UI.full_rect(_viewer)
	_viewer.visible = false
	_viewer.gui_input.connect(func(e): if _is_click(e): _viewer.visible = false)
	add_child(_viewer)
	rebuild()


# --- Catalogue -------------------------------------------------------------------------------------

static func entries() -> Array:
	return DataDB.gallery.get("entries", [])


## [débloquées, jouables, prévues] pour une liste d'entrées.
static func progress(list: Array) -> Array:
	var u := 0
	var n := 0
	var p := 0
	for e in list:
		if e.get("status", "") == "prevue":
			p += 1
		else:
			n += 1
			if SaveManager.entry_unlocked(e):
				u += 1
	return [u, n, p]


static func label_of(table: String, key: String) -> String:
	return str(DataDB.gallery.get(table, {}).get(key, key))


static func _count(pr: Array) -> String:
	return "%d/%d" % [pr[0], pr[1]] + ((" · +%d prévue" % pr[2]) + ("s" if pr[2] > 1 else "") if pr[2] > 0 else "")


func rebuild() -> void:
	var all := entries()
	var pr := progress(all)
	unlocked_count = pr[0]
	total = pr[1]
	planned = pr[2]
	_title.text = "GALERIE   %d / %d   (%d %%)   ·   %d scènes en préparation" % [pr[0], pr[1], int(100.0 * pr[0] / max(1, pr[1])), pr[2]]
	_clear(_tabs)
	for t in DataDB.gallery.get("tabs", {}):
		var b := _chip("%s   %s" % [label_of("tabs", t), _count(progress(all.filter(func(e): return e["tab"] == t)))], t == tab, 22)
		b.name = t
		b.pressed.connect(func(): _set_filter(t, "", ""))
		_tabs.add_child(b)
	var in_tab := all.filter(func(e): return e["tab"] == tab)
	_clear(_cats)
	_cats.add_child(_filter_chip("Toutes catégories   " + _count(progress(in_tab)), cat == "", "cat_all", func(): _set_filter(tab, "", route)))
	for c in DataDB.gallery.get("categories", {}):
		var sub := in_tab.filter(func(e): return e["cat"] == c)
		if not sub.is_empty():
			_cats.add_child(_filter_chip("%s   %s" % [label_of("categories", c), _count(progress(sub))], cat == c, "cat_" + c, func(): _set_filter(tab, c, route)))
	_clear(_routes)
	var in_cat := in_tab.filter(func(e): return cat == "" or e["cat"] == cat)
	_routes.add_child(_filter_chip("Toutes les voies", route == "", "route_all", func(): _set_filter(tab, cat, "")))
	for r in DataDB.gallery.get("routes", {}):
		var sub := in_cat.filter(func(e): return e["route"] == r)
		if not sub.is_empty():
			_routes.add_child(_filter_chip("%s   %s" % [label_of("routes", r), _count(progress(sub))], route == r, "route_" + r, func(): _set_filter(tab, cat, r)))
	_clear(_grid)
	for e in in_cat.filter(func(e): return route == "" or e["route"] == route):
		_grid.add_child(_tile(e))


func _set_filter(t: String, c: String, r: String) -> void:
	tab = t
	cat = c
	route = r
	rebuild()


func _chip(text: String, on: bool, size: int = 18) -> Button:
	var b := UI.button(text, size, UI.MAGENTA if on else UI.DIM)
	b.toggle_mode = true
	b.button_pressed = on
	b.focus_mode = Control.FOCUS_NONE
	return b


func _filter_chip(text: String, on: bool, id: String, cb: Callable) -> Button:
	var b := _chip(text, on)
	b.name = id
	b.pressed.connect(cb)
	return b


static func _clear(n: Node) -> void:
	for c in n.get_children():
		n.remove_child(c)
		c.queue_free()


# --- Tuiles ----------------------------------------------------------------------------------------

func _tile(e: Dictionary) -> Control:
	var id: String = e["id"]
	var prevue: bool = e.get("status", "") == "prevue"
	var open := SaveManager.entry_unlocked(e)
	var cg: String = e.get("cg", "")
	var masked: bool = open and bool(_nsfw.get(cg, false)) and Settings.hide_pacte_p3
	var tile := PanelContainer.new()
	tile.name = id
	tile.custom_minimum_size = TILE + Vector2(0, 92)
	var border := UI.MAGENTA.darkened(0.3) if open else (UI.GOLD.darkened(0.55) if prevue else UI.DIM.darkened(0.5))
	tile.add_theme_stylebox_override("panel", UI.box(UI.PANEL, border, 2))
	var v := VBoxContainer.new()
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile.add_child(v)
	var tex: Texture2D = AssetDB.cg(cg) if open and cg != "" and not masked else null
	if tex != null:
		var tr := TextureRect.new()
		tr.texture = tex
		tr.custom_minimum_size = TILE
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(tr)
		tile.gui_input.connect(func(ev): if _is_click(ev): _show(tex))
		tile.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		var msg := "???"
		if prevue:
			msg = "En préparation"
		elif masked:
			msg = "Masquée (option P3)"
		elif open:
			msg = "Visuel à générer" if cg != "" else _members(e)
		var l := UI.label(msg, 26 if msg == "???" else 18, UI.GOLD.darkened(0.2) if prevue else UI.DIM)
		l.custom_minimum_size = TILE
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		v.add_child(l)
	var who := _members(e) if not e.get("members", []).is_empty() else "Verrouillée"
	var cap := UI.label(e.get("title", id) if open or prevue else who, 16, UI.TEXT if open else UI.DIM)
	cap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cap.clip_text = true
	cap.custom_minimum_size = Vector2(TILE.x, 0)
	v.add_child(cap)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	v.add_child(row)
	var tag := UI.label("%s · %s" % [label_of("categories", e["cat"]), label_of("routes", e["route"])], 14, UI.DIM)
	tag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tag.clip_text = true
	row.add_child(tag)
	if open:
		var b := UI.button("Revoir", 16, UI.MAGENTA)
		b.name = "Revoir"
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(replay.bind(e))
		row.add_child(b)
	else:
		var h := UI.button("Indice", 16, UI.GOLD)
		h.name = "Indice"
		h.focus_mode = Control.FOCUS_NONE
		h.pressed.connect(show_hint.bind(e))
		row.add_child(h)
	return tile


static func _members(e: Dictionary) -> String:
	var names: Array = e.get("members", []).map(func(m): return DataDB.display_name(m))
	return " · ".join(names) if not names.is_empty() else "Scène débloquée"


func show_hint(e: Dictionary) -> void:
	var gold := UI.GOLD.to_html(false)
	var out := "[b]%s[/b]   [color=#%s]%s · %s[/color]\n" % [e.get("title", ""), UI.DIM.to_html(false), label_of("categories", e["cat"]), label_of("routes", e["route"])]
	out += "[color=#%s]Indice :[/color] %s" % [gold, e.get("hint", "")]
	if e.get("status", "") == "prevue":
		out += "\n[i]Scène en préparation : son emplacement est réservé, elle n'est pas encore jouable.[/i]"
	_detail.text = out


func _show(tex: Texture2D) -> void:
	_viewer.texture = tex
	_viewer.visible = true


# --- Revoir ------------------------------------------------------------------------------------------

## Rejoue la scène d'une entrée débloquée, dans un état vierge (la partie en cours n'est pas modifiée).
func replay(e: Dictionary) -> Control:
	if _replay != null or e.get("scene", "") == "":
		return null
	_prev_music = MusicManager.current_context
	var d := DialogueScene.new()
	d.name = "Replay"
	d.replay = true
	d.sandbox = StateStore.new()
	d.replay_title = e.get("title", "")
	_panel.visible = false
	add_child(d)
	d.finished.connect(end_replay)
	d.menu_requested.connect(end_replay)
	_replay = d
	d.start(e["scene"])
	return d


func end_replay() -> void:
	if _replay == null:
		return
	_replay.queue_free()
	_replay = null
	VoiceManager.stop()
	if _prev_music != "":
		MusicManager.play_context(_prev_music)
	_panel.visible = true
	rebuild()


static func _is_click(e: InputEvent) -> bool:
	return (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT) or (e is InputEventScreenTouch and e.pressed)


func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		if _replay != null:
			end_replay()
		elif _viewer.visible:
			_viewer.visible = false
		else:
			queue_free()
