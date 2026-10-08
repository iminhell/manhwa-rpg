extends Control
## Guide du joueur (data/world/guide.json) : la Tour, le Registre, les Ancres, la régression, le temps, le Refuge,
## les objets, les liens, les Voies, le combat. Menu pause → Guide ; ouvert seul à la première arrivée sur la carte.

const UI := preload("res://ui/ui_style.gd")

var page := ""   ## page affichée à l'ouverture (sinon la première)
var _text: RichTextLabel
var _list: VBoxContainer


func _ready() -> void:
	add_to_group("modal")
	UI.full_rect(self)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.7)
	add_child(UI.full_rect(shade))
	var panel := PanelContainer.new()
	panel.anchor_left = 0.08
	panel.anchor_right = 0.92
	panel.anchor_top = 0.07
	panel.anchor_bottom = 0.93
	panel.add_theme_stylebox_override("panel", UI.box(Color(0.03, 0.04, 0.07, 0.98), UI.CYAN, 3))
	add_child(panel)
	var v := VBoxContainer.new()
	panel.add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	var t := UI.label("GUIDE", 30, UI.CYAN)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(t)
	var close := UI.button("Fermer", 20)
	close.pressed.connect(queue_free)
	head.add_child(close)
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 18)
	v.add_child(body)
	_list = VBoxContainer.new()
	_list.custom_minimum_size = Vector2(340, 0)
	_list.add_theme_constant_override("separation", 6)
	body.add_child(_list)
	for p in pages():
		var b := UI.button(p["title"], 19)
		b.name = p["id"]
		b.toggle_mode = true
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(show_page.bind(p["id"]))
		_list.add_child(b)
	_text = RichTextLabel.new()
	_text.name = "Text"
	_text.bbcode_enabled = true
	_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_text.add_theme_font_size_override("normal_font_size", 22)
	_text.add_theme_font_size_override("bold_font_size", 26)
	body.add_child(_text)
	show_page(page if page != "" else (pages()[0]["id"] if not pages().is_empty() else ""))


static func pages() -> Array:
	return DataDB.guide.get("pages", [])


func show_page(id: String) -> void:
	page = id
	for p in pages():
		if p["id"] == id:
			_text.text = "[b][color=#%s]%s[/color][/b]\n\n%s" % [UI.CYAN.to_html(false), p["title"], p["text"]]
	for b in _list.get_children():
		b.button_pressed = b.name == id


func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		queue_free()
