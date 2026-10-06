extends Control
## Graphe des sous-zones d'un secteur : nœuds visibles, liens, zones verrouillées.

signal node_clicked(node_id: String)

const UI := preload("res://ui/ui_style.gd")
const R := 30.0
const TYPE_ICON := {"lieu": "◆", "menace": "⚔", "pnj": "●", "cache": "✦", "refuge": "⌂"}
const TYPE_COLOR := {"lieu": Color("#9aa0a6"), "menace": Color("#e04848"), "pnj": Color("#2ec5ff"), "cache": Color("#e8b23a"), "refuge": Color("#5bd18b")}

var model  ## WorldModel
var hovered: String = ""


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func _pos(nid: String) -> Vector2:
	var p: Array = model.node(nid).get("pos", [0.5, 0.5])
	var margin := Vector2(60, 40)
	return margin + Vector2(p[0], p[1]) * (size - margin * 2.0)


func _draw() -> void:
	if model == null:
		return
	var font := ThemeDB.fallback_font
	var sid: String = model.sector_id()
	var visible: Array = model.visible_nodes(sid)
	for nid in visible:
		for l in model.node(nid).get("links", []):
			if l > nid and visible.has(l):
				var col := Color(1, 1, 1, 0.18)
				if (nid == model.node_id() and model.can_move(l)) or (l == model.node_id() and model.can_move(nid)):
					col = Color(UI.CYAN, 0.7)
				draw_line(_pos(nid), _pos(l), col, 2.0)
	for nid in visible:
		var n: Dictionary = model.node(nid)
		var p := _pos(nid)
		var t: String = n.get("type", "lieu")
		if model.is_refuge(nid):
			t = "refuge"
		var col: Color = TYPE_COLOR.get(t, Color.WHITE)
		var open: bool = model.node_open(nid)
		draw_circle(p, R, Color(col, 0.18 if open else 0.06))
		draw_arc(p, R, 0, TAU, 40, col if open else Color(col, 0.35), 2.5)
		if nid == model.node_id():
			draw_arc(p, R + 7, 0, TAU, 40, UI.CYAN, 3.5)
		elif model.can_move(nid):
			draw_arc(p, R + 5, 0, TAU, 40, Color(UI.CYAN, 0.4), 1.5)
		var icon: String = "🔒" if not open else TYPE_ICON.get(t, "◆")
		var iw := font.get_string_size(icon, HORIZONTAL_ALIGNMENT_LEFT, -1, 22).x
		draw_string(font, p + Vector2(-iw / 2.0, 8), icon, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, col)
		var name: String = n.get("name", nid)
		if name.length() > 26:
			name = name.substr(0, 25) + "…"
		var nw := font.get_string_size(name, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x
		draw_string(font, p + Vector2(-nw / 2.0, R + 20), name, HORIZONTAL_ALIGNMENT_LEFT, -1, 15,
			UI.TEXT if nid == hovered or nid == model.node_id() else UI.DIM)


func _gui_input(event: InputEvent) -> void:
	if model == null:
		return
	if event is InputEventMouseMotion:
		var h := _hit(event.position)
		if h != hovered:
			hovered = h
			queue_redraw()
	var pressed: bool = (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) \
		or (event is InputEventScreenTouch and event.pressed)
	if pressed:
		var nid := _hit(event.position)
		if nid != "":
			node_clicked.emit(nid)


func _hit(pos: Vector2) -> String:
	for nid in model.visible_nodes(model.sector_id()):
		if _pos(nid).distance_to(pos) <= R + 6:
			return nid
	return ""
