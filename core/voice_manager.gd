extends Node
## Autoload : voix IA (coréen / japonais) avec commutateur global On/Off.
##
## Règles de déclenchement (GDD §18.3) :
##   - première réplique d'un personnage principal dans une scène (apparition) ;
##   - répliques marquées "v": true (scènes clés, scènes intimes).
## Fichiers : res://assets/voice/<langue>/<personnage>/<id_réplique>.ogg|.mp3
## (id « prologue_j1:start:3 » → « prologue_j1__start__3 »). Fichier absent = silence.

var _player: AudioStreamPlayer
var _seen_in_scene: Dictionary = {}


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)


## À appeler au début de chaque scène de dialogue.
func begin_scene() -> void:
	_seen_in_scene.clear()


static func file_key(line_id: String) -> String:
	return line_id.replace(":", "__")


func should_voice(line: Dictionary) -> bool:
	var speaker: String = line.get("speaker", "")
	if not DataDB.characters.has(speaker):
		return false
	return bool(line.get("voiced", false)) or not _seen_in_scene.has(speaker)


func path_for(line: Dictionary) -> String:
	var base := "res://assets/voice/%s/%s/%s" % [Settings.voice_lang, line.get("speaker", ""), file_key(line.get("id", ""))]
	for ext in [".ogg", ".mp3"]:
		if ResourceLoader.exists(base + ext):
			return base + ext
	return ""


## Joue la voix d'une réplique si l'option est active et le fichier présent.
func on_line(line: Dictionary) -> void:
	stop()
	var voiced := should_voice(line)
	_seen_in_scene[line.get("speaker", "")] = true
	if not Settings.voice_enabled or not voiced:
		return
	var path := path_for(line)
	if path == "":
		return
	_player.stream = load(path)
	_player.volume_db = linear_to_db(max(0.001, Settings.voice_volume))
	_player.play()


func stop() -> void:
	if _player.playing:
		_player.stop()
