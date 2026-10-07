extends PanelContainer
## Menu Options : voix IA On/Off, langue (coréen / japonais), volumes, préférences de contenu.

signal closed

const UI := preload("res://ui/ui_style.gd")


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	custom_minimum_size = Vector2(760, 520)
	add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.05, 0.08, 0.98), UI.CYAN, 3))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	add_child(v)
	v.add_child(UI.label("OPTIONS", 34, UI.CYAN))

	var voice := CheckButton.new()
	voice.text = "Voix IA (scènes clés, apparitions, scènes intimes)"
	voice.add_theme_font_size_override("font_size", 22)
	voice.button_pressed = Settings.voice_enabled
	voice.toggled.connect(_set_option.bind("voice_enabled"))
	v.add_child(voice)

	var lang_row := HBoxContainer.new()
	lang_row.add_child(UI.label("Langue des voix :  ", 22))
	var lang := OptionButton.new()
	lang.add_theme_font_size_override("font_size", 22)
	lang.add_item("Coréen (한국어)")
	lang.add_item("Japonais (日本語)")
	lang.selected = Settings.VOICE_LANGS.find(Settings.voice_lang)
	lang.item_selected.connect(_set_lang)
	lang_row.add_child(lang)
	v.add_child(lang_row)

	v.add_child(_slider("Volume des voix", Settings.voice_volume, _set_option.bind("voice_volume")))
	v.add_child(_slider("Volume de la musique", Settings.music_volume, _set_option.bind("music_volume")))

	var p3 := CheckButton.new()
	p3.text = "Masquer les passages P3 explicites (préférence, sans effet sur le jeu)"
	p3.add_theme_font_size_override("font_size", 18)
	p3.button_pressed = Settings.hide_pacte_p3
	p3.toggled.connect(_set_option.bind("hide_pacte_p3"))
	v.add_child(p3)

	var close := UI.button("Fermer", 24)
	close.pressed.connect(_close)
	v.add_child(close)


func _slider(title: String, value: float, on_change: Callable) -> HBoxContainer:
	var row := HBoxContainer.new()
	var l := UI.label(title + "  ", 20)
	l.custom_minimum_size = Vector2(300, 0)
	row.add_child(l)
	var s := HSlider.new()
	s.min_value = 0.0
	s.max_value = 1.0
	s.step = 0.05
	s.value = value
	s.custom_minimum_size = Vector2(360, 30)
	s.value_changed.connect(on_change)
	row.add_child(s)
	return row


func _set_option(value: Variant, key: String) -> void:
	Settings.set(key, value)
	Settings.save_settings()


func _set_lang(index: int) -> void:
	_set_option(Settings.VOICE_LANGS[index], "voice_lang")


func _close() -> void:
	closed.emit()
	queue_free()
