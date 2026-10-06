extends Node
## Autoload : musique par contexte (secteur, nuit, combat, boss, danger, Registre, intime).
## Fondu enchaîné entre deux lecteurs. Pistes absentes = silence, sans erreur (data/audio/music.json).

const FADE := 1.2

var current_context: String = ""
var current_track: String = ""
var _players: Array[AudioStreamPlayer] = []
var _active := 0
var _missing_logged: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in 2:
		var p := AudioStreamPlayer.new()
		p.volume_db = -80.0
		add_child(p)
		_players.append(p)
	Settings.changed.connect(_apply_volume)


## Joue la piste associée à un contexte (ex. "sector.yongsan", "combat", "night").
func play_context(context: String) -> void:
	current_context = context
	var track: String = DataDB.music.get("contexts", {}).get(context, "")
	if track == "" or track == current_track:
		return
	current_track = track
	var stream := _load_track(track)
	var old := _players[_active]
	_active = 1 - _active
	var new := _players[_active]
	_fade(old, -80.0, true)
	if stream == null:
		return
	new.stream = stream
	new.volume_db = -80.0
	new.play()
	_fade(new, _target_db(), false)


## Combat : bascule sur la couche « danger » quand un allié passe sous 30 % de PV.
func set_danger(on: bool) -> void:
	play_context("combat.danger" if on else "combat")


func stop() -> void:
	current_track = ""
	for p in _players:
		_fade(p, -80.0, true)


func _load_track(track: String) -> AudioStream:
	var base: String = DataDB.music.get("tracks", {}).get(track, {}).get("file", "")
	for path in [base, base.get_basename() + ".mp3"]:
		if path != "" and ResourceLoader.exists(path):
			var s: AudioStream = load(path)
			if s is AudioStreamOggVorbis:
				s.loop = true
			elif s is AudioStreamMP3:
				s.loop = true
			return s
	if not _missing_logged.has(track):
		_missing_logged[track] = true
		print_verbose("[musique] piste absente : %s" % track)
	return null


func _fade(p: AudioStreamPlayer, db: float, stop_after: bool) -> void:
	var tw := create_tween()
	tw.tween_property(p, "volume_db", db, FADE)
	if stop_after:
		tw.tween_callback(p.stop)


func _target_db() -> float:
	return linear_to_db(max(0.001, Settings.music_volume))


func _apply_volume() -> void:
	if _players[_active].playing:
		_players[_active].volume_db = _target_db()
