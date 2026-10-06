extends Control
## Portrait d'un personnage : image générée (avec respiration et clignement) ou placeholder.

const UI := preload("res://ui/ui_style.gd")
const BREATHE := preload("res://shaders/portrait_breathe.gdshader")

var char_id: String = ""
var expression: String = "neutral"
var _tex_rect: TextureRect
var _placeholder: PanelContainer
var _blink_timer := 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tex_rect = TextureRect.new()
	_tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var mat := ShaderMaterial.new()
	mat.shader = BREATHE
	_tex_rect.material = mat
	UI.full_rect(_tex_rect)
	add_child(_tex_rect)
	_placeholder = PanelContainer.new()
	UI.full_rect(_placeholder)
	add_child(_placeholder)
	_blink_timer = randf_range(2.0, 5.0)


func show_character(id: String, expr: String) -> void:
	char_id = id
	expression = expr
	visible = id != ""
	if not visible:
		return
	var tex: Texture2D = AssetDB.portrait(id, expr)
	_tex_rect.texture = tex
	_tex_rect.visible = tex != null
	_placeholder.visible = tex == null
	if tex == null:
		_build_placeholder()


func _build_placeholder() -> void:
	for c in _placeholder.get_children():
		c.queue_free()
	var col: Color = DataDB.palette_color(char_id)
	_placeholder.add_theme_stylebox_override("panel", UI.box(Color(col, 0.18), col, 3, 12))
	var v := VBoxContainer.new()
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	_placeholder.add_child(v)
	var initials := UI.label(DataDB.display_name(char_id).substr(0, 1), 160, col)
	initials.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(initials)
	var name_l := UI.label(DataDB.display_name(char_id), 34, UI.TEXT)
	name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(name_l)
	var expr_l := UI.label("[%s] — visuel à générer" % expression, 20, UI.DIM)
	expr_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(expr_l)


func _process(delta: float) -> void:
	if not visible or _tex_rect.texture == null:
		return
	_blink_timer -= delta
	if _blink_timer <= 0.0:
		var blink: Texture2D = AssetDB.portrait(char_id, "blink")
		if blink != null and blink != _tex_rect.texture:
			_tex_rect.texture = blink
			_blink_timer = 0.12
		else:
			_tex_rect.texture = AssetDB.portrait(char_id, expression)
			_blink_timer = randf_range(2.5, 6.0)
