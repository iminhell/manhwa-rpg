extends Control
## Fiches des personnages : portrait, identité, présentation ; en partie, liens (Affinité, Confiance, Peur), groupe
## et Fin connue. Accessible depuis l'écran titre et le menu pause.

const UI := preload("res://ui/ui_style.gd")
const PortraitView := preload("res://scenes/dialogue/portrait_view.gd")
const ORDER := ["elias", "seo_yeon", "haneul", "hae_in", "aoi", "maricel", "ryeon", "xiaoyu", "nadia", "simone", "minh_anh"]

var in_game := false   ## affiche les liens de la partie en cours
var selected := ""
var _portrait: Control
var _info: RichTextLabel
var _list: VBoxContainer


func _ready() -> void:
	add_to_group("modal")
	UI.full_rect(self)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.7)
	add_child(UI.full_rect(shade))
	var panel := PanelContainer.new()
	panel.anchor_left = 0.04
	panel.anchor_right = 0.96
	panel.anchor_top = 0.05
	panel.anchor_bottom = 0.95
	panel.add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.05, 0.08, 0.98), UI.CYAN, 3))
	add_child(panel)
	var v := VBoxContainer.new()
	panel.add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	var t := UI.label("FICHES DES PERSONNAGES", 30, UI.CYAN)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(t)
	var close := UI.button("Fermer", 20)
	close.pressed.connect(queue_free)
	head.add_child(close)
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 16)
	v.add_child(body)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(300, 0)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body.add_child(scroll)
	_list = VBoxContainer.new()
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list.add_theme_constant_override("separation", 6)
	scroll.add_child(_list)
	for id in ids():
		var b := UI.button(DataDB.display_name(id), 20, DataDB.palette_color(id))
		b.name = id
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.custom_minimum_size = Vector2(280, 48)
		b.toggle_mode = true
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(show_character.bind(id))
		_list.add_child(b)
	_portrait = PortraitView.new()
	_portrait.custom_minimum_size = Vector2(420, 0)
	_portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(_portrait)
	_info = RichTextLabel.new()
	_info.bbcode_enabled = true
	_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_info.add_theme_font_size_override("normal_font_size", 21)
	_info.add_theme_font_size_override("bold_font_size", 22)
	_info.add_theme_font_size_override("italics_font_size", 21)
	body.add_child(_info)
	show_character(selected if selected != "" else ids()[0])


## Personnages présentés : ordre du casting, puis tout personnage ajouté plus tard aux données.
static func ids() -> Array:
	var out: Array = ORDER.filter(func(id): return DataDB.characters.has(id))
	for id in DataDB.characters:
		if not out.has(id):
			out.append(id)
	return out


func show_character(id: String) -> void:
	selected = id
	var c: Dictionary = DataDB.character(id)
	var col: Color = DataDB.palette_color(id)
	_portrait.show_character(id, "neutral")
	var gold := UI.GOLD.to_html(false)
	var out := "[font_size=34][b][color=#%s]%s[/color][/b][/font_size]\n" % [col.to_html(false), c.get("name", id)]
	out += "[color=#%s]%s[/color]\n\n" % [gold, c.get("role", "")]
	out += "Âge : %d ans · Taille : %d cm · Origine : %s\n\n" % [int(c.get("age", 0)), int(c.get("height_cm", 0)), c.get("origin", "?")]
	if c.has("bio"):
		out += "%s\n\n" % c["bio"]
	if c.has("trait"):
		out += "[i]%s[/i]\n\n" % c["trait"]
	out += combat_text(c)
	if in_game and id != "elias":
		var st = GameState.store
		var status := "dans le groupe" if st.has_flag("party." + id) else ("rencontrée" if st.aff(id) != 0 or st.trust(id) != 0 else "pas encore rencontrée")
		out += "[b][color=#%s]Dans cette boucle[/color][/b] : %s\n" % [gold, status]
		out += "Affinité %s   ·   Confiance %s   ·   Peur %s\n" % [_bar(st.aff(id)), _bar(st.trust(id)), _bar(st.fear(id))]
		if st.knows_fin(id) and DataDB.fins.has(id):
			out += "\n[b][color=#%s]Fin lue dans le Registre[/color][/b]\n%s\n" % [gold, DataDB.fins[id].get("text", "")]
	_info.text = out
	for b in _list.get_children():
		b.button_pressed = b.name == id


const ROWS := ["avant", "milieu", "arrière"]


## Fiche de combat : statistiques, rangée de départ et compétences (data/combat/skills.json).
static func combat_text(c: Dictionary) -> String:
	var cb: Dictionary = c.get("combat", {})
	if cb.is_empty():
		return ""
	var gold := UI.GOLD.to_html(false)
	var s: Dictionary = cb.get("stats", {})
	var out := "[b][color=#%s]Combat[/color][/b]\n" % gold
	out += "PV %d · Attaque %d · Défense %d · Vitesse %d · Mana %d" % [int(s.get("hp", 0)), int(s.get("atk", 0)), int(s.get("def", 0)),
		int(s.get("spd", 0)), int(s.get("mana", 0))]
	var pos: Array = cb.get("position", [])
	if pos.size() == 2:
		out += " · rangée %s" % ROWS[clampi(int(pos[0]), 0, 2)]
	out += "\n"
	for sid in cb.get("skills", []):
		var sk: Dictionary = DataDB.skills.get(sid, {})
		var cost := int(sk.get("cost", 0))
		out += "• [b]%s[/b]%s%s — %s\n" % [sk.get("name", sid), " (%d mana)" % cost if cost > 0 else "",
			" [color=#%s][Éveil][/color]" % gold if sk.get("awaken", false) else "", sk.get("desc", "")]
	return out + "\n"


static func _bar(value: float) -> String:
	var n := clampi(int(round(value / 10.0)), 0, 10)
	return "[bgcolor=#%s]%s[/bgcolor][bgcolor=#2a2f3a]%s[/bgcolor] %d" % [UI.GOLD.to_html(false), "  ".repeat(n), "  ".repeat(10 - n), int(value)]


func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		queue_free()
