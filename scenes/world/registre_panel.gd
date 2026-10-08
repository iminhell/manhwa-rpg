extends PanelContainer
## Registre des Fins : Fins connues, Souvenirs, Échos des boucles passées, Pression, alignement et Voie.

const UI := preload("res://ui/ui_style.gd")

var _text: RichTextLabel


func _ready() -> void:
	anchor_left = 0.15
	anchor_right = 0.85
	anchor_top = 0.08
	anchor_bottom = 0.92
	add_theme_stylebox_override("panel", UI.box(Color(0.1, 0.07, 0.02, 0.97), UI.GOLD, 3))
	var v := VBoxContainer.new()
	add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	var t := UI.label("REGISTRE DES FINS", 30, UI.GOLD)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(t)
	var close := UI.button("Fermer", 20, UI.GOLD)
	close.pressed.connect(func(): visible = false)
	head.add_child(close)
	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_text.add_theme_font_size_override("normal_font_size", 18)
	_text.add_theme_font_size_override("bold_font_size", 20)
	v.add_child(_text)


func refresh() -> void:
	var st = GameState.store
	var out := "[b][color=#e8b23a]Fins connues[/color][/b]\n"
	var any := false
	for id in DataDB.fins:
		if st.knows_fin(id):
			any = true
			var f: Dictionary = DataDB.fins[id]
			out += "• [b]%s[/b] — %s\n" % [f["who"], f["text"]]
	if not any:
		out += "[i]Aucune. Approche les gens pour lire leur Fin.[/i]\n"
	out += "\n[b][color=#e8b23a]Souvenirs[/color][/b]\n"
	for id in st.souvenirs:
		out += "• %s\n" % DataDB.souvenirs.get(id, id)
	var echoes := []
	for f in st.flags:
		if str(f).begins_with("echo.") and DataDB.echoes.has(str(f).substr(5)):
			echoes.append(DataDB.echoes[str(f).substr(5)].get("text", ""))
	if not echoes.is_empty():
		out += "\n[b][color=#e8b23a]Échos des boucles passées[/color][/b]\n"
		for e in echoes:
			out += "• [i]%s[/i]\n" % e
	out += "\n[b][color=#e8b23a]Pression de la Tour[/color][/b] : %d / 100   (Effacement au-delà de 85 au Jour 30)\n" % int(st.pressure())
	out += "[b][color=#e8b23a]Alignement[/color][/b] : Protéger/Dominer %+d · Lien/Solitude %+d\n" % [
		int(st.get_var("align.protect")), int(st.get_var("align.bond"))]
	var voie: String = {"heros": "Héros", "tyran": "Tyran", "loup": "Loup", "mercenaire": "Mercenaire"}.get(st.voie(), "indécise")
	out += "[b][color=#e8b23a]Voie[/color][/b] : %s   [i](Héros : Protéger ≥ 20 · Tyran : ≤ −20 · Loup : Lien ≤ −20 · Mercenaire : 400 ₩)[/i]\n" % voie
	_text.text = out


func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R)):
		get_viewport().set_input_as_handled()
		visible = false
