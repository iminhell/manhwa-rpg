extends Control
## Écran titre.

signal new_loop
signal combat_test
signal quit_game

const UI := preload("res://ui/ui_style.gd")


func _ready() -> void:
	UI.full_rect(self)
	add_child(UI.background(AssetDB.background("tower_gate")))
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.55)
	add_child(UI.full_rect(shade))
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	v.grow_horizontal = Control.GROW_DIRECTION_BOTH
	v.grow_vertical = Control.GROW_DIRECTION_BOTH
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", 18)
	add_child(v)
	var t := UI.label("LA TOUR DU DERNIER JOUR", 72, UI.TEXT)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(t)
	var st := UI.label("Prototype — Acte I", 26, UI.GOLD)
	st.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(st)
	v.add_child(Control.new())
	for entry in [["Nouvelle boucle", new_loop], ["Combat de test : le Portier", combat_test], ["Quitter", quit_game]]:
		var b := UI.button(entry[0], 30)
		b.custom_minimum_size = Vector2(520, 64)
		var sig: Signal = entry[1]
		b.pressed.connect(func(): sig.emit())
		v.add_child(b)
