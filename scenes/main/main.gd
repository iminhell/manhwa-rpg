extends Control
## Racine du jeu : titre → prologue → carte ↔ dialogues/combats → fin d'acte, avec la régression.
##
## Outils (arguments après « -- ») :
##   --autotest          joue automatiquement le prologue puis l'Acte I sur la carte (tests/autopilot.json)
##   --autotest-regress  force une défaite au premier combat pour tester la régression
##   --alt               avec --autotest : embranchements alternatifs (tests/autopilot.json → choices_alt)
##   --capture           enregistre des captures d'écran dans user://captures/

const TitleScreen := preload("res://scenes/title/title_screen.gd")
const DialogueScene := preload("res://scenes/dialogue/dialogue_scene.gd")
const CombatScene := preload("res://scenes/combat/combat_scene.gd")
const WorldMapScene := preload("res://scenes/world/world_map_scene.gd")
const ActSummary := preload("res://scenes/world/act_summary_screen.gd")
const OptionsPanel := preload("res://scenes/options_panel.gd")
const SavePanel := preload("res://scenes/save_panel.gd")
const UI := preload("res://ui/ui_style.gd")

const STORY := "prologue_j1"
const LAST_ACT := 3
const AUTOTEST_MAX_STEPS := 12000

var _screen: Control        ## écran principal (titre, prologue, carte, résumé)
var _overlay: Control       ## dialogue/combat lancé par-dessus la carte
var _dialogue: Control      ## dialogue en cours (prologue ou événement)
var _map: Control
var _autotest := false
var _autotest_regressed := false
var _choices: Dictionary = {}
var _steps := 0
var _overlay_combat: Control


func _ready() -> void:
	UI.full_rect(self)
	var args := OS.get_cmdline_user_args()
	_autotest = args.has("--autotest")
	if args.has("--capture"):
		_capture_tour()
		return
	if _autotest:
		print("[autotest] démarrage")
		var auto := DataDB.load_json("res://tests/autopilot.json")
		_choices = auto.get("choices_alt" if args.has("--alt") else "choices", {})
		_start_story()
	else:
		_show_title()


func _set_screen(node: Control) -> void:
	_clear_overlay()
	if _screen != null:
		_screen.queue_free()
	_map = null
	_screen = node
	add_child(node)


func _clear_overlay() -> void:
	if _overlay != null:
		_overlay.queue_free()
		_overlay = null


func _show_title() -> void:
	MusicManager.play_context("title")
	var t := TitleScreen.new()
	t.new_loop.connect(_start_story.bind(true))
	t.continue_game.connect(_load_slot.bind(""))
	t.load_game.connect(_show_load)
	t.combat_test.connect(_start_combat_test)
	t.options.connect(_show_options)
	t.quit_game.connect(func(): get_tree().quit())
	_set_screen(t)


func _show_options() -> void:
	add_child(OptionsPanel.new())


func _show_load() -> void:
	var p := SavePanel.new()
	p.mode = "load"
	p.slot_chosen.connect(_load_slot)
	add_child(p)


## Charge un emplacement ("" = le plus récent) et ouvre la carte.
func _load_slot(slot: String) -> void:
	if slot == "":
		slot = SaveManager.latest_slot()
	if SaveManager.load_slot(slot):
		_open_map()


# --- Prologue ------------------------------------------------------------------------

## fresh = false après une régression : l'état de boucle (compteur, souvenirs) est conservé.
func _start_story(fresh: bool = true) -> void:
	if fresh:
		GameState.new_game()
	_dialogue = _make_dialogue()
	_set_screen(_dialogue)
	_dialogue.finished.connect(_on_prologue_finished)
	_dialogue.start(STORY)


func _make_dialogue() -> Control:
	var d := DialogueScene.new()
	d.auto_advance = _autotest
	d.choice_overrides = _choices
	d.event_requested.connect(_on_dialogue_event)
	return d


func _on_prologue_finished() -> void:
	if GameState.world.node_id() == "":
		GameState.world.place("yeouido.camp")
	_open_map()


# --- Carte ---------------------------------------------------------------------------------

func _open_map() -> void:
	_map = WorldMapScene.new()
	_set_screen(_map)
	_map = _screen
	_map.dialogue_requested.connect(_on_map_dialogue)
	_map.combat_requested.connect(_on_map_combat)
	_map.options_requested.connect(_show_options)
	MusicManager.play_context(GameState.world.sector(GameState.world.sector_id()).get("music", ""))


func _on_map_dialogue(ref: String) -> void:
	_map.visible = false
	_dialogue = _make_dialogue()
	_overlay = _dialogue
	add_child(_dialogue)
	_dialogue.finished.connect(_return_to_map)
	_dialogue.start(ref)


func _on_map_combat(encounter: String, win_fx: Array) -> void:
	_map.visible = false
	_overlay = _start_combat(encounter, func(result: String):
		if result == "win":
			GameState.store.apply_effects(win_fx)
			_return_to_map()
		else:
			_defeat())


func _return_to_map() -> void:
	_clear_overlay()
	if _map == null:
		return
	MusicManager.play_context(GameState.world.sector(GameState.world.sector_id()).get("music", ""))
	_map.resume()


# --- Événements de dialogue ------------------------------------------------------------------

func _on_dialogue_event(name: String, args: Dictionary) -> void:
	match name:
		"combat":
			_dialogue.visible = false
			var dlg := _dialogue
			var c := _start_combat(args.get("encounter", ""), func(result: String):
				GameState.store.set_var("combat.last", result)
				dlg.visible = true
				dlg.resume())
			_overlay_combat = c
		"regress":
			_regress()
		"world", "move":
			GameState.world.place(str(args.get("node", "")))
			_dialogue.resume()
		"end_act":
			_end_act(int(args.get("act", 1)))
		_:
			push_warning("Événement inconnu : %s" % name)
			_dialogue.resume()


func _start_combat(encounter: String, on_done: Callable) -> Control:
	var c := CombatScene.new()
	c.auto_battle = _autotest
	add_child(c)
	c.setup(encounter, GameState.party_ids())
	c.finished.connect(func(result: String):
		if OS.get_cmdline_user_args().has("--autotest-regress") and not _autotest_regressed:
			result = "lose"
		if _autotest:
			print("[autotest] J%d %s — combat %s : %s" % [GameState.day, GameState.phase_name(), encounter, result])
		c.queue_free()
		on_done.call(result))
	return c


## Défaite sur la carte : scène de mort puis régression.
func _defeat() -> void:
	_clear_overlay()
	_dialogue = _make_dialogue()
	_overlay = _dialogue
	add_child(_dialogue)
	_dialogue.start("act1_world:defeat")


func _regress() -> void:
	GameState.regress()
	SaveManager.update_meta(GameState.store)
	if _autotest:
		print("[autotest] régression → boucle %d" % GameState.store.loop())
		_autotest_regressed = true
	_start_story(false)


func _end_act(act: int) -> void:
	SaveManager.record_act(act)
	if _autotest:
		var st = GameState.store
		var lines: Array = DataDB.act_summary.get("act%d" % act, []).filter(func(l): return st.check(str(l.get("if", ""))))
		print("[autotest] FIN DE L'ACTE %d — boucle %d, J%d, groupe %s, Pression %d" % [
			act, st.loop(), st.day(), GameState.party_ids(), int(st.pressure())])
		print("[autotest] temps libre de l'Acte %d : %.1f phases de jour sur l'itinéraire" % [act, _map.idle_ticks / 4.0])
		_map.idle_ticks = 0
		for l in lines:
			print("[autotest]   • ", l["text"])
		if act >= LAST_ACT or OS.get_cmdline_user_args().has("--act1-only"):
			get_tree().quit(0)
			return
		_dialogue.resume()
		return
	var s := ActSummary.new()
	s.setup(act, act < LAST_ACT)
	s.closed.connect(_after_summary.bind(act, s))
	add_child(s)


## Après le résumé d'un acte : on continue sur la carte (actes intermédiaires) ou on revient au titre.
func _after_summary(act: int, summary: Control) -> void:
	summary.queue_free()
	if act >= LAST_ACT:
		_show_title()
	else:
		SaveManager.autosave()
		_dialogue.resume()


# --- Boucle de l'autopilote ---------------------------------------------------------------------

func _process(_delta: float) -> void:
	if not _autotest:
		return
	_steps += 1
	if _steps > AUTOTEST_MAX_STEPS * 10:
		printerr("[autotest] délai dépassé : J%d %s, nœud %s" % [GameState.day, GameState.phase_name(), GameState.world.node_id()])
		get_tree().quit(2)
		return
	if _map != null and is_instance_valid(_map) and _map.visible and _overlay == null and _steps % 3 == 0 \
			and (_overlay_combat == null or not is_instance_valid(_overlay_combat)):
		_map.autopilot_step()


func _start_combat_test() -> void:
	GameState.new_game()
	GameState.store.set_var("loop", 2)  # Réécriture disponible pour tester
	var c := CombatScene.new()
	_set_screen(c)
	c.setup("portier", ["elias", "seo_yeon", "haneul", "hae_in"])
	c.finished.connect(func(_r): _show_title())


# --- Captures d'écran ---------------------------------------------------------------------------

func _capture_tour() -> void:
	DirAccess.make_dir_recursive_absolute("user://captures")
	_show_title()
	await _snap("01_titre")
	GameState.new_game()
	GameState.store.set_time(3, 1)
	GameState.world.place("yeouido.ifc")
	GameState.store.apply_effects(["join seo_yeon", "souvenir s1_bunker_b6", "flag haein_rencontree", "flag event.j3_vision", "money 120", "item ration 2"])
	_open_map()
	await _snap("02_carte_yeouido")
	GameState.world.place("yongsan.rue_itaewon")
	_map.refresh()
	await _snap("03_carte_yongsan")
	_on_map_dialogue("act1_haein:bureau")
	for i in 3:
		_dialogue._typing = false
		_dialogue._advance()
		await get_tree().process_frame
	_dialogue._text.visible_ratio = 1.0
	await _snap("04_dialogue_haein")
	_clear_overlay()
	_start_combat_test()
	await _snap("05_combat")
	get_tree().quit(0)


func _snap(name: String) -> void:
	for i in 30:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var path := "user://captures/%s.png" % name
	img.save_png(path)
	print("[capture] ", ProjectSettings.globalize_path(path))
