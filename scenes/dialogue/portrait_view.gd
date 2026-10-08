extends Control
## Portrait d'un personnage : image générée (avec respiration et clignement) ou placeholder.
## Deux cadrages, calculés sur la silhouette (marges transparentes ignorées) :
##   - « stage » (dialogue, façon visual novel) : grand, pieds sous l'écran derrière la boîte de texte, et taille
##     relative au personnage (data/characters/*.json → height_cm) : Elias (184 cm) a la tête en haut de l'écran,
##     Maricel (157 cm) plus bas ;
##   - sinon (fiches) : silhouette entière, centrée dans le cadre.

const UI := preload("res://ui/ui_style.gd")
const BREATHE := preload("res://shaders/portrait_breathe.gdshader")
const REF_CM := 184.0       ## taille du plus grand personnage (Elias)
const STAGE_TALL := 1.45    ## hauteur affichée du plus grand, en hauteurs de l'écran
const STAGE_TOP := 0.035    ## haut de la tête du plus grand, en fraction de la hauteur

var char_id: String = ""
var expression: String = "neutral"
var stage := false
var center_x := 0.5         ## position horizontale du personnage (fraction de la largeur)
var _tex_rect: TextureRect
var _placeholder: PanelContainer
var _blink_timer := 0.0
static var _used: Dictionary = {}   ## chemin de l'image → rectangle de la silhouette (alpha > 0)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = not stage
	_tex_rect = TextureRect.new()
	_tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_tex_rect.stretch_mode = TextureRect.STRETCH_SCALE
	_tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mat := ShaderMaterial.new()
	mat.shader = BREATHE
	_tex_rect.material = mat
	add_child(_tex_rect)
	_placeholder = PanelContainer.new()
	add_child(_placeholder)
	_blink_timer = randf_range(2.0, 5.0)
	resized.connect(_layout)


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
	_layout()


## Rectangle de la silhouette dans l'image (mis en cache) ; l'image entière si elle n'est pas lisible.
static func used_rect(tex: Texture2D) -> Rect2:
	var key := tex.resource_path if tex.resource_path != "" else str(tex.get_rid())
	if not _used.has(key):
		var r := Rect2(Vector2.ZERO, tex.get_size())
		var img := tex.get_image()
		if img != null:
			if img.is_compressed():
				img.decompress()
			var u := img.get_used_rect()
			if u.size.x > 0 and u.size.y > 0:
				r = Rect2(u)
		_used[key] = r
	return _used[key]


## Échelle et position de l'image entière, pour que la silhouette occupe la place voulue.
static func placement(tex_size: Vector2, used: Rect2, box: Vector2, staged: bool, height_cm: float, cx: float) -> Rect2:
	var s: float
	var pos: Vector2
	if staged:
		var tall := box.y * STAGE_TALL
		var fig_h := tall * clampf(height_cm / REF_CM, 0.75, 1.0)
		s = fig_h / used.size.y
		var floor_y := box.y * STAGE_TOP + tall   # même sol pour tous : les plus petits ont la tête plus bas
		pos = Vector2(box.x * cx - (used.position.x + used.size.x / 2.0) * s, floor_y - used.end.y * s)
	else:
		s = minf(box.y * 0.98 / used.size.y, box.x * 0.98 / used.size.x)
		pos = box / 2.0 - (used.position + used.size / 2.0) * s
	return Rect2(pos, tex_size * s)


func _layout() -> void:
	if _placeholder != null:
		if stage:
			var ph := Vector2(minf(size.x, 460.0), minf(size.y * 0.62, 620.0))
			_placeholder.position = Vector2(size.x * center_x - ph.x / 2.0, size.y * 0.06)
			_placeholder.size = ph
		else:
			_placeholder.position = Vector2.ZERO
			_placeholder.size = size
	var tex: Texture2D = _tex_rect.texture if _tex_rect != null else null
	if tex == null or size.x <= 0.0 or size.y <= 0.0:
		return
	var h_cm := float(DataDB.character(char_id).get("height_cm", REF_CM))
	var r := placement(tex.get_size(), used_rect(tex), size, stage, h_cm, center_x)
	_tex_rect.position = r.position
	_tex_rect.size = r.size


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
