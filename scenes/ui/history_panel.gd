extends Control
## Journal : historique des répliques de la scène (et des scènes précédentes de la session).

const UI := preload("res://ui/ui_style.gd")

var entries: Array = []   ## [{"name": String, "text": String, "color": Color}]
var _text: RichTextLabel


func _ready() -> void:
	add_to_group("modal")
	UI.full_rect(self)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.6)
	add_child(UI.full_rect(shade))
	var panel := PanelContainer.new()
	panel.anchor_left = 0.12
	panel.anchor_right = 0.88
	panel.anchor_top = 0.06
	panel.anchor_bottom = 0.94
	panel.add_theme_stylebox_override("panel", UI.box(Color(0.03, 0.04, 0.07, 0.98), UI.CYAN, 3))
	add_child(panel)
	var v := VBoxContainer.new()
	panel.add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	var t := UI.label("JOURNAL", 30, UI.CYAN)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(t)
	var close := UI.button("Fermer", 20)
	close.pressed.connect(queue_free)
	head.add_child(close)
	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.scroll_following = true
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_text.add_theme_font_size_override("normal_font_size", 21)
	_text.add_theme_font_size_override("bold_font_size", 22)
	_text.add_theme_font_size_override("italics_font_size", 21)
	v.add_child(_text)
	_fill()


func _fill() -> void:
	if entries.is_empty():
		_text.text = "[i]Rien pour l'instant.[/i]"
		return
	var out := ""
	for e in entries:
		var name: String = e.get("name", "")
		var text: String = str(e.get("text", "")).replace("[", "[lb]")
		if name == "":
			out += "[i]%s[/i]\n\n" % text
		else:
			out += "[b][color=#%s]%s[/color][/b]\n%s\n\n" % [Color(e.get("color", UI.TEXT)).to_html(false), name, text]
	_text.text = out


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_L):
		get_viewport().set_input_as_handled()
		queue_free()
