extends Control
## Inventaire : argent, ressources, consommables, équipement, objets clés et cadeaux (data/world/items.json,
## cadeaux de data/world/gifts.json). Accessible depuis la carte (bouton « Inventaire », touche I) et le menu pause.

const UI := preload("res://ui/ui_style.gd")

var _text: RichTextLabel


func _ready() -> void:
	add_to_group("modal")
	UI.full_rect(self)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.6)
	add_child(UI.full_rect(shade))
	var panel := PanelContainer.new()
	panel.anchor_left = 0.18
	panel.anchor_right = 0.82
	panel.anchor_top = 0.08
	panel.anchor_bottom = 0.92
	panel.add_theme_stylebox_override("panel", UI.box(Color(0.03, 0.04, 0.07, 0.98), UI.GOLD, 3))
	add_child(panel)
	var v := VBoxContainer.new()
	panel.add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	var t := UI.label("INVENTAIRE", 30, UI.GOLD)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(t)
	var close := UI.button("Fermer", 20, UI.GOLD)
	close.pressed.connect(queue_free)
	head.add_child(close)
	_text = RichTextLabel.new()
	_text.name = "Text"
	_text.bbcode_enabled = true
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_text.add_theme_font_size_override("normal_font_size", 20)
	_text.add_theme_font_size_override("bold_font_size", 21)
	_text.add_theme_font_size_override("italics_font_size", 18)
	v.add_child(_text)
	_text.text = describe(GameState.store)


## Objets possédés (quantité > 0), regroupés par catégorie : [[catégorie, [[nom, quantité, description]…]]…].
static func owned(store) -> Array:
	var cats: Dictionary = DataDB.items.get("categories", {})
	var by_cat := {}
	for key in store.vars:
		var k := str(key)
		if not k.begins_with("item.") or int(store.vars[key]) <= 0:
			continue
		var id := k.substr(5)
		var entry := info(id)
		var c: String = entry.get("cat", "cle")
		if not by_cat.has(c):
			by_cat[c] = []
		by_cat[c].append([entry.get("name", id), int(store.vars[key]), entry.get("desc", "")])
	var out := []
	for c in cats:
		if by_cat.has(c):
			by_cat[c].sort_custom(func(a, b): return a[0] < b[0])
			out.append([cats[c], by_cat[c]])
	return out


static func info(id: String) -> Dictionary:
	if DataDB.items.get("items", {}).has(id):
		return DataDB.items["items"][id]
	if id.begins_with("cadeau_"):
		var g: Dictionary = DataDB.gifts.get("gifts", {}).get(id.substr(7), {})
		return {"name": g.get("name", id), "cat": "cadeau", "desc": "Cadeau à offrir au Refuge (action « Offrir un cadeau »)."}
	return {"name": id, "cat": "cle", "desc": ""}


static func describe(store) -> String:
	var gold := UI.GOLD.to_html(false)
	var out := "[b][color=#%s]Argent[/color][/b] : %d ₩\n\n" % [gold, store.money()]
	var groups := owned(store)
	if groups.is_empty():
		out += "[i]Aucun objet. Les missions, les combats et les marchés de Séoul en fournissent.[/i]"
	for g in groups:
		out += "[b][color=#%s]%s[/color][/b]\n" % [gold, g[0]]
		for it in g[1]:
			out += "• [b]%s[/b] × %d\n   [i]%s[/i]\n" % [it[0], it[1], it[2]]
		out += "\n"
	return out


func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_I):
		queue_free()
