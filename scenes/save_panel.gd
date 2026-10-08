extends PanelContainer
## Panneau des emplacements de sauvegarde (mode « save » ou « load »).

signal slot_chosen(slot: String)
signal closed

const UI := preload("res://ui/ui_style.gd")
const PHASES := ["Aube", "Jour", "Crépuscule", "Nuit"]

var mode := "load"


func _ready() -> void:
	add_to_group("modal")
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	custom_minimum_size = Vector2(900, 560)
	add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.05, 0.08, 0.98), UI.GOLD, 3))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	add_child(v)
	v.add_child(UI.label("SAUVEGARDER" if mode == "save" else "CHARGER", 32, UI.GOLD))
	for slot in SaveManager.SLOTS:
		if mode == "save" and slot == "auto":
			continue
		var b := UI.button(_describe(slot), 20, UI.GOLD)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.custom_minimum_size = Vector2(0, 70)
		b.disabled = mode == "load" and not SaveManager.has_save(slot)
		b.pressed.connect(_choose.bind(slot))
		v.add_child(b)
	var meta: Dictionary = SaveManager.meta
	v.add_child(UI.label("Boucles vécues : %d · Actes terminés : %d · Fins découvertes : %d/10" % [
		int(meta.get("loops", 1)), meta.get("acts", []).size(), meta.get("fins", []).size()], 18, UI.DIM))
	var close := UI.button("Fermer", 22)
	close.pressed.connect(_close)
	v.add_child(close)


func _describe(slot: String) -> String:
	var title := "Sauvegarde auto" if slot == "auto" else "Emplacement %s" % slot
	if not SaveManager.has_save(slot):
		return "%s — vide" % title
	var s: Dictionary = SaveManager.summary(slot)
	return "%s — Jour %d, %s · Boucle %d · %s · %s" % [title, int(s.get("day", 1)), PHASES[int(s.get("phase", 0))],
		int(s.get("loop", 1)), str(s.get("node", "")), SaveManager.saved_at(slot)]


func _choose(slot: String) -> void:
	slot_chosen.emit(slot)
	_close()


func _close() -> void:
	closed.emit()
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		_close()
