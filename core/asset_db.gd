extends Node
## Autoload : accès aux visuels générés par le pipeline (tools/art_pipeline).
## Renvoie null si l'image n'existe pas encore : l'UI affiche alors un placeholder.

const ROOT := "res://assets"
var _cache: Dictionary = {}


func _load(path: String) -> Texture2D:
	if _cache.has(path):
		return _cache[path]
	var tex: Texture2D = null
	if ResourceLoader.exists(path):
		tex = load(path)
	_cache[path] = tex
	return tex


func portrait(char_id: String, expression: String = "neutral") -> Texture2D:
	var tex := _load("%s/portraits/%s/%s.png" % [ROOT, char_id, expression])
	if tex == null and expression != "neutral":
		tex = _load("%s/portraits/%s/neutral.png" % [ROOT, char_id])
	return tex


func sprite(id: String) -> Texture2D:
	return _load("%s/sprites/%s.png" % [ROOT, id])


func background(id: String) -> Texture2D:
	return _load("%s/backgrounds/%s.png" % [ROOT, id])


func cg(id: String) -> Texture2D:
	return _load("%s/cg/%s.png" % [ROOT, id])
