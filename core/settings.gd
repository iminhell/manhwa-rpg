extends Node
## Autoload : réglages du joueur, persistés dans user://settings.cfg.

signal changed

const PATH := "user://settings.cfg"
const VOICE_LANGS := ["ko", "ja"]

var voice_enabled: bool = true      ## commutateur global On/Off des voix IA
var voice_lang: String = "ko"       ## "ko" (coréen) ou "ja" (japonais)
var voice_volume: float = 0.9
var music_volume: float = 0.7
var hide_pacte_p3: bool = false     ## préférence de confort (§11.4.5)


func _ready() -> void:
	load_settings()


func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return
	voice_enabled = cfg.get_value("audio", "voice_enabled", voice_enabled)
	voice_lang = cfg.get_value("audio", "voice_lang", voice_lang)
	voice_volume = cfg.get_value("audio", "voice_volume", voice_volume)
	music_volume = cfg.get_value("audio", "music_volume", music_volume)
	hide_pacte_p3 = cfg.get_value("contenu", "hide_pacte_p3", hide_pacte_p3)
	if not VOICE_LANGS.has(voice_lang):
		voice_lang = "ko"


func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "voice_enabled", voice_enabled)
	cfg.set_value("audio", "voice_lang", voice_lang)
	cfg.set_value("audio", "voice_volume", voice_volume)
	cfg.set_value("audio", "music_volume", music_volume)
	cfg.set_value("contenu", "hide_pacte_p3", hide_pacte_p3)
	cfg.save(PATH)
	changed.emit()
