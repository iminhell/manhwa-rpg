extends Control
## Menu pause (Échap ou bouton « Menu ») : reprendre, sauvegarder, charger, inventaire, fiches, galerie, guide, options, titre.

signal chosen(action: String)

const UI := preload("res://ui/ui_style.gd")
const ENTRIES := [
	["resume", "Reprendre"], ["save", "Sauvegarder"], ["load", "Charger"], ["inventory", "Inventaire"],
	["sheets", "Fiches des personnages"], ["gallery", "Galerie"], ["guide", "Guide"], ["options", "Options"], ["title", "Retour au titre"],
]

var can_save := true
var save_hint := ""


func _ready() -> void:
	add_to_group("modal")
	UI.full_rect(self)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.62)
	add_child(UI.full_rect(shade))
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	panel.custom_minimum_size = Vector2(560, 0)
	panel.add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.05, 0.08, 0.98), UI.GOLD, 3))
	add_child(panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	panel.add_child(v)
	var t := UI.label("PAUSE", 34, UI.GOLD)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(t)
	for e in ENTRIES:
		var b := UI.button(e[1], 26, UI.MAGENTA if e[0] == "title" else UI.CYAN)
		b.name = e[0]
		b.custom_minimum_size = Vector2(0, 58)
		if e[0] == "save" and not can_save:
			b.disabled = true
			b.tooltip_text = save_hint
		b.pressed.connect(_choose.bind(e[0]))
		v.add_child(b)
	if not can_save and save_hint != "":
		var hint := UI.label(save_hint, 18, UI.DIM)
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(hint)


func _choose(action: String) -> void:
	chosen.emit(action)
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()  # rien ne passe au jeu sous le menu
	if event.is_action_pressed("ui_cancel"):
		_choose("resume")
