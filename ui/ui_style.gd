extends RefCounted
## Palette et fabriques d'UI (thème « néon SF / dark fantasy »).

const BG := Color("#0b0d14")
const PANEL := Color(0.05, 0.06, 0.09, 0.92)
const CYAN := Color("#2ec5ff")
const MAGENTA := Color("#ff2e88")
const GOLD := Color("#e8b23a")
const RED := Color("#e04848")
const TEXT := Color("#e8e8ee")
const DIM := Color("#8a8fa3")


static func box(bg: Color = PANEL, border: Color = CYAN, border_w: int = 2, radius: int = 6) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(border_w)
	sb.set_corner_radius_all(radius)
	sb.set_content_margin_all(12)
	return sb


static func label(text: String, size: int = 24, color: Color = TEXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l


static func button(text: String, size: int = 24, accent: Color = CYAN) -> Button:
	var b := Button.new()
	b.text = text
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", TEXT)
	b.add_theme_color_override("font_hover_color", accent)
	b.add_theme_color_override("font_disabled_color", DIM)
	b.add_theme_stylebox_override("normal", box(PANEL, accent.darkened(0.4), 2))
	b.add_theme_stylebox_override("hover", box(PANEL.lightened(0.08), accent, 2))
	b.add_theme_stylebox_override("pressed", box(accent.darkened(0.6), accent, 2))
	b.add_theme_stylebox_override("disabled", box(PANEL.darkened(0.3), DIM.darkened(0.5), 1))
	b.add_theme_stylebox_override("focus", box(Color(0, 0, 0, 0), accent, 2))
	return b


static func full_rect(c: Control) -> Control:
	c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return c


## Fond : texture si disponible, sinon dégradé sombre.
static func background(tex: Texture2D) -> Control:
	if tex != null:
		var tr := TextureRect.new()
		tr.texture = tex
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		return full_rect(tr)
	var cr := ColorRect.new()
	cr.color = BG
	return full_rect(cr)
