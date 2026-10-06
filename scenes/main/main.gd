extends Control
## Racine du jeu : enchaîne titre → dialogue ↔ combat → régression.
## Lancer avec « -- --autotest » pour jouer tout le prototype automatiquement (validation headless),
## et « -- --autotest --autotest-regress » pour forcer une défaite et tester la régression.

const TitleScreen := preload("res://scenes/title/title_screen.gd")
const DialogueScene := preload("res://scenes/dialogue/dialogue_scene.gd")
const CombatScene := preload("res://scenes/combat/combat_scene.gd")
const UI := preload("res://ui/ui_style.gd")

const STORY := "prologue_j1"

var _screen: Control
var _dialogue: Control
var _autotest := false
var _autotest_regressed := false


func _ready() -> void:
	UI.full_rect(self)
	_autotest = OS.get_cmdline_user_args().has("--autotest")
	if OS.get_cmdline_user_args().has("--capture"):
		_capture_tour()
		return
	if _autotest:
		print("[autotest] démarrage")
		_start_story()
	else:
		_show_title()


func _swap(node: Control) -> void:
	if _screen != null:
		_screen.queue_free()
	_screen = node
	add_child(node)


func _show_title() -> void:
	var t := TitleScreen.new()
	t.new_loop.connect(_start_story)
	t.combat_test.connect(_start_combat_test)
	t.quit_game.connect(func(): get_tree().quit())
	_swap(t)


func _start_story() -> void:
	GameState.new_game()
	_start_dialogue(STORY)


func _start_dialogue(id: String) -> void:
	_dialogue = DialogueScene.new()
	_dialogue.auto_advance = _autotest
	_swap(_dialogue)
	_dialogue.event_requested.connect(_on_event)
	_dialogue.finished.connect(_on_story_finished)
	_dialogue.start(id)


func _on_event(name: String, args: Dictionary) -> void:
	match name:
		"combat":
			_dialogue.visible = false
			var c := CombatScene.new()
			c.auto_battle = _autotest
			add_child(c)
			c.setup(args.get("encounter", ""), GameState.party_ids())
			c.finished.connect(_on_combat_finished.bind(c))
		"regress":
			GameState.regress()
			if _autotest:
				print("[autotest] régression → boucle %d" % GameState.store.loop())
				_autotest_regressed = true
			_start_dialogue(STORY)
		_:
			push_warning("Événement inconnu : %s" % name)
			_dialogue.resume()


func _on_combat_finished(result: String, combat: Control) -> void:
	if OS.get_cmdline_user_args().has("--autotest-regress") and not _autotest_regressed:
		result = "lose"  # force une défaite pour tester la régression
	GameState.store.set_var("combat.last", result)
	if _autotest:
		print("[autotest] combat terminé : %s" % result)
	combat.queue_free()
	_dialogue.resume()


func _on_story_finished() -> void:
	if _autotest:
		print("[autotest] fin du prototype atteinte (boucle %d, alignement protect=%s)" % [
			GameState.store.loop(), GameState.store.get_var("align.protect")])
		get_tree().quit(0)
		return
	_show_title()


func _start_combat_test() -> void:
	GameState.new_game()
	GameState.store.set_var("loop", 2)  # Réécriture disponible pour tester
	var c := CombatScene.new()
	_swap(c)
	c.setup("portier_test", ["elias", "seo_yeon", "haneul", "hae_in"])
	c.finished.connect(func(_r): _show_title())


## Outil de dev : « -- --capture » enregistre des captures d'écran dans user://captures/.
func _capture_tour() -> void:
	DirAccess.make_dir_recursive_absolute("user://captures")
	_show_title()
	await _snap("01_titre")
	GameState.new_game()
	_start_dialogue(STORY)
	for i in 40:
		await get_tree().process_frame
	await _snap("02_dialogue")
	var portrait_done := false
	for i in 30:
		if _dialogue._current.get("kind", "") != "line":
			break
		if not portrait_done and DataDB.characters.has(_dialogue._current.get("speaker", "")):
			portrait_done = true
			_dialogue._text.visible_ratio = 1.0
			await _snap("02b_portrait")
		_dialogue._typing = false
		_dialogue._advance()
		await get_tree().process_frame
	await _snap("03_choix")
	_start_combat_test()
	await _snap("04_combat")
	get_tree().quit(0)


func _snap(name: String) -> void:
	for i in 30:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var path := "user://captures/%s.png" % name
	img.save_png(path)
	print("[capture] ", ProjectSettings.globalize_path(path))
