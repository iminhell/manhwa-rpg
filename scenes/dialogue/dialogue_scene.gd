extends Control
## Scène de dialogue : décor, CG, portrait, boîte de texte (effet machine à écrire), choix.
## La logique est dans narrative/dialogue_runner.gd ; cette scène ne fait qu'afficher.

signal event_requested(name: String, args: Dictionary)
signal finished

const UI := preload("res://ui/ui_style.gd")
const DialogueRunner := preload("res://narrative/dialogue_runner.gd")
const PortraitView := preload("res://scenes/dialogue/portrait_view.gd")

const CHARS_PER_SEC := 55.0

var runner: DialogueRunner
var auto_advance := false        ## mode test : avance et choisit seul
var choice_overrides: Dictionary = {}  ## mode test : "dialogue:bloc" → index de choix
var _speakers: Dictionary = {}
var _bg_layer: Control
var _bg: Control
var _cg: TextureRect
var _portrait: Control
var _box: PanelContainer
var _name_label: Label
var _text: RichTextLabel
var _choices: VBoxContainer
var _hud: Label
var _typing := false
var _paused := false
var _current: Dictionary = {}


func _ready() -> void:
	UI.full_rect(self)
	_bg_layer = UI.full_rect(Control.new())
	_bg_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg_layer)
	_set_background("black")

	_portrait = PortraitView.new()
	_portrait.anchor_left = 0.04
	_portrait.anchor_right = 0.36
	_portrait.anchor_top = 0.06
	_portrait.anchor_bottom = 0.70
	add_child(_portrait)
	_portrait.visible = false

	_cg = TextureRect.new()
	_cg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_cg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_cg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.full_rect(_cg)
	_cg.visible = false
	add_child(_cg)

	_box = PanelContainer.new()
	_box.anchor_left = 0.04
	_box.anchor_right = 0.96
	_box.anchor_top = 0.72
	_box.anchor_bottom = 0.96
	_box.add_theme_stylebox_override("panel", UI.box())
	add_child(_box)
	var v := VBoxContainer.new()
	_box.add_child(v)
	_name_label = UI.label("", 30, UI.CYAN)
	v.add_child(_name_label)
	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.fit_content = false
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for item in ["normal_font_size", "italics_font_size", "bold_font_size", "bold_italics_font_size"]:
		_text.add_theme_font_size_override(item, 28)
	_text.add_theme_color_override("default_color", UI.TEXT)
	_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(_text)

	_choices = VBoxContainer.new()
	_choices.anchor_left = 0.42
	_choices.anchor_right = 0.94
	_choices.anchor_top = 0.18
	_choices.anchor_bottom = 0.68
	_choices.alignment = BoxContainer.ALIGNMENT_CENTER
	_choices.add_theme_constant_override("separation", 14)
	add_child(_choices)

	_hud = UI.label("", 22, UI.GOLD)
	_hud.position = Vector2(24, 16)
	add_child(_hud)


## Accepte « fichier » ou « fichier:bloc ».
func start(dialogue_id: String, block: String = "") -> void:
	if ":" in dialogue_id:
		block = dialogue_id.get_slice(":", 1)
		dialogue_id = dialogue_id.get_slice(":", 0)
	VoiceManager.begin_scene()
	var dlg: Dictionary = DataDB.dialogues.get(dialogue_id, {})
	_speakers = dlg.get("speakers", {})
	runner = DialogueRunner.new(GameState.store)
	runner.show_p3 = not Settings.hide_pacte_p3
	_cg.texture = null
	_cg.visible = false
	runner.start(dlg, block)
	_advance()


## Reprend après un événement (combat…).
func resume() -> void:
	_paused = false
	visible = true
	_advance()


func _advance() -> void:
	if _paused:
		return
	_update_hud()
	_current = runner.next()
	match _current["kind"]:
		"line":
			_show_line(_current)
		"choice":
			_show_choices(_current["options"])
		"bg":
			_set_background(_current["id"])
			_advance()
		"cg":
			var tex: Texture2D = AssetDB.cg(_current["id"]) if _current["id"] != "" else null
			_cg.texture = tex
			_cg.visible = tex != null
			_advance()
		"phase":
			GameState.advance_phase(_current["count"])
			_advance()
		"time":
			GameState.store.set_time(_current["day"], _current["phase"])
			_advance()
		"music":
			MusicManager.play_context(_current["context"])
			_advance()
		"event":
			_paused = true
			event_requested.emit(_current["name"], _current["args"])
		"end":
			VoiceManager.stop()
			finished.emit()


func _show_line(line: Dictionary) -> void:
	var speaker: String = line["speaker"]
	var display: String = _speakers.get(speaker, DataDB.display_name(speaker))
	_name_label.text = display
	var text: String = line["text"]
	match speaker:
		"system":
			_name_label.add_theme_color_override("font_color", UI.CYAN)
			_box.add_theme_stylebox_override("panel", UI.box(Color(0.02, 0.1, 0.16, 0.95), UI.CYAN, 3))
			text = "[color=#9be7ff]%s[/color]" % text
		"registre":
			_name_label.add_theme_color_override("font_color", UI.GOLD)
			_box.add_theme_stylebox_override("panel", UI.box(Color(0.14, 0.1, 0.02, 0.95), UI.GOLD, 3))
			text = "[color=#f5d68a]%s[/color]" % text
		"narrator":
			_box.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.DIM.darkened(0.4), 2))
			text = "[i]%s[/i]" % text
		_:
			var col: Color = DataDB.palette_color(speaker)
			_name_label.add_theme_color_override("font_color", col)
			_box.add_theme_stylebox_override("panel", UI.box(UI.PANEL, col, 2))
	var has_portrait := DataDB.characters.has(speaker)
	_portrait.visible = has_portrait
	if has_portrait:
		_portrait.show_character(speaker, line["expr"])
	_text.text = text
	_text.visible_characters = 0
	_typing = true
	VoiceManager.on_line(line)


func _show_choices(options: Array) -> void:
	_clear_choices()
	_text.visible_ratio = 1.0
	_typing = false
	for opt in options:
		var b := UI.button(opt["text"], 24, UI.MAGENTA)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size = Vector2(0, 64)
		b.pressed.connect(_on_choice.bind(opt["index"]))
		_choices.add_child(b)
	if auto_advance:
		var key := "%s:%s" % [runner.dialogue.get("id", ""), runner.block]
		_on_choice.call_deferred(clampi(int(choice_overrides.get(key, 0)), 0, options.size() - 1))


func _on_choice(index: int) -> void:
	_clear_choices()
	runner.choose(index)
	_advance()


func _clear_choices() -> void:
	for c in _choices.get_children():
		c.queue_free()


func _set_background(id: String) -> void:
	if _bg != null:
		_bg.queue_free()
	_bg = UI.background(AssetDB.background(id))
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg_layer.add_child(_bg)


func _update_hud() -> void:
	_hud.text = "JOUR %d — %s   ·   Boucle %d" % [GameState.day, GameState.phase_name(), GameState.store.loop()]


func _process(delta: float) -> void:
	if _typing and auto_advance:
		_text.visible_ratio = 1.0
		_typing = false
	if _typing:
		_text.visible_characters += max(1, int(CHARS_PER_SEC * delta * 2.0))
		if _text.visible_ratio >= 1.0:
			_typing = false
	elif auto_advance and not _paused and _current.get("kind", "") == "line":
		_advance()


func _unhandled_input(event: InputEvent) -> void:
	var click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	var touch: bool = event is InputEventScreenTouch and event.pressed
	if not (click or touch or event.is_action_pressed("ui_advance")):
		return
	if _paused or _current.get("kind", "") != "line":
		return
	get_viewport().set_input_as_handled()
	if _typing:
		_text.visible_ratio = 1.0
		_typing = false
	else:
		_advance()
