extends Control
## Carte stratégique de Séoul (dessinée) : secteurs, adjacences, fleuve, Tour.

signal sector_clicked(sector_id: String)

const UI := preload("res://ui/ui_style.gd")
const RADIUS := 46.0

var model  ## WorldModel


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func _pos(sid: String) -> Vector2:
	var p: Array = model.sector(sid).get("map_pos", [0.5, 0.5])
	return Vector2(p[0] * size.x, p[1] * size.y)


func _draw() -> void:
	if model == null:
		return
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.03, 0.04, 0.07))
	# Le Han
	var river := PackedVector2Array()
	for i in 21:
		var x := i / 20.0
		river.append(Vector2(x * size.x, (0.66 + 0.06 * sin(x * 5.0)) * size.y))
	draw_polyline(river, Color(0.08, 0.1, 0.16), 34.0)
	draw_polyline(river, Color(0.1, 0.14, 0.22), 18.0)
	var font := ThemeDB.fallback_font
	var cur: String = model.sector_id()
	for sid in model.sectors:
		if not model.sector_available(sid):
			continue
		for adj in model.sector(sid).get("adjacent", []):
			if adj > sid and model.sector_available(adj):
				draw_line(_pos(sid), _pos(adj), Color(1, 1, 1, 0.12), 2.0)
	for sid in model.sectors:
		if not model.sector_available(sid):
			continue
		var s: Dictionary = model.sector(sid)
		var col := Color(s.get("color", "#888888"))
		var p := _pos(sid)
		var can: bool = model.can_travel(sid)
		draw_circle(p, RADIUS, Color(col, 0.22 if can or sid == cur else 0.08))
		draw_arc(p, RADIUS, 0, TAU, 48, col if (can or sid == cur) else Color(col, 0.3), 3.0 if sid == cur else 1.5)
		if sid == cur:
			draw_arc(p, RADIUS + 8, 0, TAU, 48, UI.CYAN, 3.0)
		var label: String = s.get("short", sid)
		var w := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 20).x
		draw_string(font, p + Vector2(-w / 2.0, 6), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, UI.TEXT)
		var stars := "★".repeat(int(s.get("danger", 1)))
		var sw := font.get_string_size(stars, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
		draw_string(font, p + Vector2(-sw / 2.0, 28), stars, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, UI.MAGENTA)
		if can and sid != cur:
			var cost: String = model.cost_label(model.travel_cost(sid))
			draw_string(font, p + Vector2(-16, -RADIUS - 8), cost, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, UI.GOLD)
	# La Tour (au-dessus de Yongsan)
	var tp := _pos("yongsan") + Vector2(RADIUS + 22, 0)
	var tower := PackedVector2Array([tp + Vector2(-7, 30), tp + Vector2(-2, -38), tp + Vector2(2, -38), tp + Vector2(7, 30), tp + Vector2(-7, 30)])
	draw_colored_polygon(tower.slice(0, 4), Color(0.02, 0.02, 0.03))
	draw_polyline(tower, UI.GOLD, 1.5)


func _gui_input(event: InputEvent) -> void:
	var pressed: bool = (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) \
		or (event is InputEventScreenTouch and event.pressed)
	if not pressed or model == null:
		return
	for sid in model.sectors:
		if model.sector_available(sid) and _pos(sid).distance_to(event.position) <= RADIUS:
			sector_clicked.emit(sid)
			return
