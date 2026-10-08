extends Control
## Écran titre.

signal new_loop
signal continue_game
signal load_game
signal combat_test
signal options
signal sheets
signal gallery
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
	var st := UI.label("Prototype — Actes I à IV", 26, UI.GOLD)
	st.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(st)
	var loops := int(SaveManager.meta.get("loops", 1))
	if loops > 1:
		var ml := UI.label("Boucles vécues : %d · Échos gravés : %d · Fins de boucle : %d" % [loops,
			SaveManager.meta.get("echoes", []).size(), SaveManager.meta.get("endings", []).size()], 20, UI.DIM)
		ml.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(ml)
	v.add_child(Control.new())
	var entries := []
	if SaveManager.latest_slot() != "":
		entries.append(["Continuer", continue_game])
	entries.append(["Nouvelle boucle", new_loop])
	if SaveManager.latest_slot() != "":
		entries.append(["Charger", load_game])
	entries += [["Fiches des personnages", sheets], ["Galerie", gallery], ["Combat de test : le Portier", combat_test],
		["Options", options], ["Quitter", quit_game]]
	for entry in entries:
		var b := UI.button(entry[0], 30)
		b.custom_minimum_size = Vector2(520, 58)
		b.name = entry[0]
		var sig: Signal = entry[1]
		b.pressed.connect(func(): sig.emit())
		v.add_child(b)
