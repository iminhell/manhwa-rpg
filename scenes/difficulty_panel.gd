extends PanelContainer
## Choix du mode de difficulté à la création d'une boucle (data/world/difficulty.json).

signal chosen(mode: String)
signal closed

const UI := preload("res://ui/ui_style.gd")


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	custom_minimum_size = Vector2(980, 600)
	add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.05, 0.08, 0.98), UI.GOLD, 3))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 14)
	add_child(v)
	v.add_child(UI.label("CHOISIR LE MODE DE LA BOUCLE", 32, UI.GOLD))
	var modes: Dictionary = DataDB.difficulty.get("modes", {})
	for id in ["histoire", "normal", "survie"]:
		if not modes.has(id):
			continue
		var m: Dictionary = modes[id]
		var b := UI.button("%s\n%s" % [m.get("name", id), m.get("desc", "")], 20, UI.GOLD if id == "normal" else UI.CYAN)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size = Vector2(0, 120)
		b.pressed.connect(_choose.bind(id))
		v.add_child(b)
	var close := UI.button("Retour", 22)
	close.pressed.connect(_close)
	v.add_child(close)


func _choose(id: String) -> void:
	chosen.emit(id)
	queue_free()


func _close() -> void:
	closed.emit()
	queue_free()
