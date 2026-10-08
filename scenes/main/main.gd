extends Control
## Racine du jeu : titre → prologue → carte ↔ dialogues/combats → fin d'acte, avec la régression.
##
## Outils (arguments après « -- ») :
##   --autotest          joue automatiquement le prologue puis l'Acte I sur la carte (tests/autopilot.json)
##   --autotest-regress  force une défaite au premier combat pour tester la régression
##   --alt               avec --autotest : embranchements alternatifs (tests/autopilot.json → choices_alt)
##   --capture           enregistre des captures d'écran dans user://captures/
##   --mode=histoire|normal|survie   mode de difficulté de l'autotest (défaut : normal)
##   --uitest            vérifie l'interface (barre d'actions du dialogue, menu pause, fiches, galerie) puis quitte

const TitleScreen := preload("res://scenes/title/title_screen.gd")
const DialogueScene := preload("res://scenes/dialogue/dialogue_scene.gd")
const CombatScene := preload("res://scenes/combat/combat_scene.gd")
const WorldMapScene := preload("res://scenes/world/world_map_scene.gd")
const ActSummary := preload("res://scenes/world/act_summary_screen.gd")
const OptionsPanel := preload("res://scenes/options_panel.gd")
const SavePanel := preload("res://scenes/save_panel.gd")
const DifficultyPanel := preload("res://scenes/difficulty_panel.gd")
const PauseMenu := preload("res://scenes/ui/pause_menu.gd")
const CharacterSheets := preload("res://scenes/ui/character_sheets.gd")
const GalleryPanel := preload("res://scenes/ui/gallery_panel.gd")
const UI := preload("res://ui/ui_style.gd")

const STORY := "prologue_j1"
const LAST_ACT := 4
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
	if args.has("--uitest"):
		_ui_test()
		return
	if _autotest:
		print("[autotest] démarrage")
		var auto := DataDB.load_json("res://tests/autopilot.json")
		_choices = auto.get("choices_alt" if args.has("--alt") else "choices", {})
		var mode := "normal"
		for a in args:
			if str(a).begins_with("--mode="):
				mode = str(a).substr(7)
		_start_story(true, mode)
	else:
		_show_title()


func _set_screen(node: Control) -> void:
	_clear_overlay()
	if _overlay_combat != null and is_instance_valid(_overlay_combat):
		_overlay_combat.queue_free()
	_overlay_combat = null
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
	t.new_loop.connect(_choose_mode)
	t.continue_game.connect(_load_slot.bind(""))
	t.load_game.connect(_show_load)
	t.combat_test.connect(_start_combat_test)
	t.options.connect(_show_options)
	t.sheets.connect(_show_sheets.bind(false))
	t.gallery.connect(_show_gallery)
	t.quit_game.connect(func(): get_tree().quit())
	_set_screen(t)


func _choose_mode() -> void:
	var p := DifficultyPanel.new()
	p.chosen.connect(func(mode: String): _start_story(true, mode))
	add_child(p)


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
func _start_story(fresh: bool = true, mode: String = "") -> void:
	if fresh:
		GameState.new_game(mode)
	_dialogue = _make_dialogue()
	_set_screen(_dialogue)
	_dialogue.finished.connect(_on_prologue_finished)
	_dialogue.start(STORY)


func _make_dialogue() -> Control:
	var d := DialogueScene.new()
	d.auto_advance = _autotest
	d.choice_overrides = _choices
	d.event_requested.connect(_on_dialogue_event)
	d.save_requested.connect(_open_save)
	d.load_requested.connect(_show_load)
	d.menu_requested.connect(_open_pause)
	d.can_save = not GameState.checkpoint.is_empty()
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
	_map.menu_requested.connect(_open_pause)
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
	s.regress_requested.connect(func():
		s.queue_free()
		_regress())
	add_child(s)


## Après le résumé d'un acte : on continue sur la carte (actes intermédiaires) ou on revient au titre.
func _after_summary(act: int, summary: Control) -> void:
	summary.queue_free()
	if act >= LAST_ACT:
		_show_title()
	else:
		SaveManager.autosave()
		_dialogue.resume()


# --- Menu pause, sauvegarde, fiches, galerie ------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if _autotest or not event.is_action_pressed("ui_cancel"):
		return
	if _screen is TitleScreen or not get_tree().get_nodes_in_group("modal").is_empty():
		return
	get_viewport().set_input_as_handled()
	_open_pause()


func _on_map_now() -> bool:
	return _map != null and is_instance_valid(_map) and _map.visible and _overlay == null \
		and (_overlay_combat == null or not is_instance_valid(_overlay_combat))


func _open_pause() -> Control:
	var p := PauseMenu.new()
	p.can_save = GameState.saveable_store(_on_map_now()) != null
	p.save_hint = "" if p.can_save else "Sauvegarde possible une fois arrivé sur la carte."
	p.chosen.connect(_on_pause)
	add_child(p)
	return p


func _on_pause(action: String) -> void:
	match action:
		"save":
			_open_save()
		"load":
			_show_load()
		"sheets":
			_show_sheets(true)
		"gallery":
			_show_gallery()
		"options":
			_show_options()
		"title":
			_show_title()


## Sur la carte : l'état courant ; pendant une scène : le point de reprise juste avant elle.
func _open_save() -> void:
	var st = GameState.saveable_store(_on_map_now())
	if st == null:
		return
	var p := SavePanel.new()
	p.mode = "save"
	p.slot_chosen.connect(func(slot: String):
		var ok := SaveManager.save(slot, st)
		_toast(("Partie sauvegardée (emplacement %s)" % slot) + ("" if _on_map_now() else " — reprise sur la carte, juste avant cette scène") if ok else "Échec de la sauvegarde"))
	add_child(p)


func _show_sheets(in_game: bool) -> Control:
	var p := CharacterSheets.new()
	p.in_game = in_game
	add_child(p)
	return p


func _show_gallery() -> Control:
	var p := GalleryPanel.new()
	add_child(p)
	return p


func _toast(text: String) -> void:
	var l := UI.label(text, 22, UI.GOLD)
	l.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	l.grow_horizontal = Control.GROW_DIRECTION_BOTH
	l.offset_top = 60
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 6)
	add_child(l)
	var tw := create_tween()
	tw.tween_interval(2.5)
	tw.tween_property(l, "modulate:a", 0.0, 0.6)
	tw.tween_callback(l.queue_free)


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
	var meta_backup: Dictionary = SaveManager.meta.duplicate(true)  # la visite ne débloque rien pour le joueur
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
	_dialogue.open_log()
	await _snap("06_journal")
	for m in get_tree().get_nodes_in_group("modal"):
		m.queue_free()
	_open_pause()
	await _snap("07_menu_pause")
	for m in get_tree().get_nodes_in_group("modal"):
		m.queue_free()
	_show_sheets(true).show_character("seo_yeon")
	await _snap("08_fiches")
	for m in get_tree().get_nodes_in_group("modal"):
		m.queue_free()
	SaveManager.unlock_cg("cg_seo_nuit")
	for id in ["seo_lien", "paire_ryeon_nadia", "trio_reines", "seo_echo"]:
		if not SaveManager.meta.has("scenes"):
			SaveManager.meta["scenes"] = []
		SaveManager.meta["scenes"].append(id)
	var gal = _show_gallery()
	await _snap("09_galerie")
	gal._set_filter("intime", "", "")
	for e in GalleryPanel.entries():
		if e["id"] == "seo_ombre":
			gal.show_hint(e)
	await _snap("10_galerie_intime")
	for m in get_tree().get_nodes_in_group("modal"):
		m.queue_free()
	_clear_overlay()
	_start_combat_test()
	await _snap("05_combat")
	SaveManager.meta = meta_backup
	SaveManager._write(SaveManager.META_PATH, meta_backup)
	get_tree().quit(0)


func _snap(name: String) -> void:
	for i in 30:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var path := "user://captures/%s.png" % name
	img.save_png(path)
	print("[capture] ", ProjectSettings.globalize_path(path))


# --- Test de l'interface (--uitest) -------------------------------------------------------------
# Joue le vrai jeu : écran titre, fiches, galerie, barre d'actions du dialogue (journal, masquer, auto, passer),
# menu pause, sauvegarde pendant une scène (point de reprise), déblocage d'une CG. Restaure ensuite la méta-sauvegarde
# et l'emplacement 3 du joueur.

var _ui_fail := 0


func _ui_check(cond: bool, label: String) -> void:
	print(("[uitest] ok    " if cond else "[uitest] ÉCHEC ") + label)
	if not cond:
		_ui_fail += 1


func _frames(n: int = 4) -> void:
	for i in n:
		await get_tree().process_frame


func _press(code: Key) -> void:
	var ev := InputEventKey.new()
	ev.keycode = code
	ev.pressed = true
	get_viewport().push_input(ev)
	await _frames(2)


func _modals() -> Array:
	return get_tree().get_nodes_in_group("modal")


func _ui_test() -> void:
	var meta_backup: Dictionary = SaveManager.meta.duplicate(true)
	var slot3 := SaveManager.slot_path("3")
	var slot3_backup := FileAccess.get_file_as_string(slot3) if FileAccess.file_exists(slot3) else ""

	# 1. Écran titre : fiches et galerie
	_show_title()
	await _frames()
	_ui_check(_screen.find_child("Fiches des personnages", true, false) != null and _screen.find_child("Galerie", true, false) != null,
		"titre : boutons « Fiches des personnages » et « Galerie »")
	var sheets = _show_sheets(false)
	await _frames()
	var listed := CharacterSheets.ids().filter(func(id): return sheets.find_child(id, true, false) != null)
	_ui_check(listed.size() == DataDB.characters.size(), "fiches : %d personnages listés" % listed.size())
	sheets.show_character("hae_in")
	_ui_check(sheets._info.text.contains("Yoon Hae-in") and sheets._info.text.contains("Haesong") and not sheets._info.text.contains("Affinité"),
		"fiches : identité et présentation, sans les liens hors partie")
	await _press(KEY_ESCAPE)
	_ui_check(_modals().is_empty(), "fiches : Échap ferme le panneau")
	var gal = _show_gallery()
	await _frames()
	var all_entries: Array = GalleryPanel.entries()
	var by_tab := func(t: String) -> int: return all_entries.filter(func(e): return e["tab"] == t).size()
	var grid: Node = gal.find_child("Grid", true, false)
	_ui_check(gal.total + gal.planned == all_entries.size() and grid.get_child_count() == by_tab.call("histoire"),
		"galerie : onglet Histoire, %d CG clés ; %d entrées dont %d prévues" % [grid.get_child_count(), all_entries.size(), gal.planned])
	gal.find_child("intime", true, false).pressed.emit()
	await _frames()
	_ui_check(gal.tab == "intime" and grid.get_child_count() == by_tab.call("intime"), "galerie : onglet Scènes intimes, %d emplacements" % grid.get_child_count())
	gal.find_child("route_mercenaire", true, false).pressed.emit()
	await _frames()
	var merc: Array = all_entries.filter(func(e): return e["tab"] == "intime" and e["route"] == "mercenaire")
	_ui_check(grid.get_child_count() == merc.size() and gal.find_child("route_mercenaire", true, false).text.contains("/"),
		"galerie : filtre Mercenaire avec compteur (%d)" % grid.get_child_count())
	gal._set_filter("intime", "", "pacte")
	await _frames()
	var hint_btn: Node = grid.get_child(0).find_child("Indice", true, false)
	if hint_btn != null:
		hint_btn.pressed.emit()
	_ui_check(hint_btn != null and gal._detail.text.contains("Forcer le contrat"), "galerie : indice d'une nuit de Pacte (« Forcer le contrat… »)")
	gal.queue_free()
	await _frames()

	# 2. Prologue : barre d'actions, journal, masquer, auto, passer, menu pause (sans sauvegarde possible)
	_start_story(true, "normal")
	await _frames(6)
	var d = _dialogue
	_ui_check(d._quick != null and d._quick.visible and d._quick.button("save").disabled, "prologue : barre d'actions visible, « Sauver » désactivé")
	var seen: int = d.history.size()
	for i in 3:
		d._typing = false
		d._advance()
		await _frames(2)
	var log = d.open_log()
	await _frames()
	_ui_check(d.history.size() >= seen + 3 and log._text.text.length() > 20, "journal : %d répliques" % d.history.size())
	await _press(KEY_L)
	_ui_check(_modals().is_empty(), "journal : L ou Échap le ferme")
	await _press(KEY_H)
	_ui_check(not d._box.visible and not d._quick.visible, "masquer (H) : boîte de dialogue et barre cachées")
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.position = get_viewport().get_visible_rect().size * Vector2(0.6, 0.4)
	var line_before: String = d._text.text
	get_viewport().push_input(click)
	await _frames(2)
	_ui_check(d._box.visible and d._quick.visible and not d.ui_hidden and d._text.text == line_before,
		"masquer : un clic réaffiche l'interface (sans avancer la réplique)")
	var before: String = d._text.text
	d._typing = false
	d._text.visible_ratio = 1.0
	await _press(KEY_A)
	_ui_check(d.auto_play and d._quick.button("auto").button_pressed, "auto (A) : activé, bouton enfoncé")
	await get_tree().create_timer(d.auto_delay(d._text.get_parsed_text()) + 0.6).timeout
	_ui_check(d._text.text != before, "auto : la réplique suivante s'affiche seule")
	d._on_quick("auto")
	d._on_quick("skip")
	for i in 400:
		await get_tree().process_frame
		if d._current.get("kind", "") != "line":
			break
	_ui_check(d._current.get("kind", "") == "choice" and not d.skipping, "passer : avance jusqu'au choix puis s'arrête")
	await _press(KEY_ESCAPE)
	var pause: Array = _modals().filter(func(m): return m is PauseMenu)
	_ui_check(pause.size() == 1, "Échap : menu pause ouvert")
	if pause.size() == 1:
		var p = pause[0]
		for b in ["resume", "save", "load", "sheets", "gallery", "options", "title"]:
			_ui_check(p.find_child(b, true, false) != null, "menu pause : bouton %s" % b)
		_ui_check(p.find_child("save", true, false).disabled, "menu pause : sauvegarde impossible pendant le prologue")
		p.find_child("sheets", true, false).pressed.emit()
		await _frames()
		var s: Array = _modals().filter(func(m): return m is CharacterSheets)
		_ui_check(s.size() == 1 and s[0].in_game, "menu pause → fiches (avec les liens de la partie)")
		for m in _modals():
			m.queue_free()
		await _frames()

	# 3. Sur la carte : une scène lancée par une action, sauvegarde au point de reprise, CG débloquée
	GameState.new_game()
	GameState.world.place("yeouido.camp")
	_open_map()
	await _frames()
	_ui_check(_map.find_child("Menu", true, false) != null or _map.get_children().size() > 0, "carte : bouton Menu")
	var checkpoint_money: int = GameState.store.money()
	GameState.mark_checkpoint(GameState.store.to_dict())
	GameState.store.apply_effects(["money 777"])  # effet appliqué pendant la scène
	_on_map_dialogue("refuge:seo_baiser")
	await _frames(4)
	_ui_check(_dialogue.can_save and not _dialogue._quick.button("save").disabled, "scène sur la carte : « Sauver » disponible")
	_ui_check(SaveManager.cg_unlocked("cg_seo_nuit"), "galerie : la CG affichée par la scène est débloquée")
	_dialogue._on_quick("save")
	await _frames()
	var panels: Array = _modals().filter(func(m): return m is SavePanel)
	_ui_check(panels.size() == 1, "Sauver : panneau des emplacements")
	if panels.size() == 1:
		panels[0].slot_chosen.emit("3")
		panels[0].queue_free()
		await _frames()
		var saved: Dictionary = SaveManager._read(slot3, {})
		_ui_check(int(saved.get("summary", {}).get("money", -1)) == checkpoint_money,
			"sauvegarde pendant une scène : état d'avant la scène (%s, pas %d)" % [saved.get("summary", {}).get("money", "?"), GameState.store.money()])
	_dialogue.start("refuge_groupe:paire_ryeon_nadia")
	await _frames()
	_ui_check(SaveManager.meta.get("scenes", []).has("paire_ryeon_nadia"), "galerie : une scène intime se débloque dès son début")
	var g = _show_gallery()
	await _frames()
	g._set_filter("intime", "solo", "lien")
	await _frames()
	var tile: Node = g.find_child("seo_lien", true, false)
	_ui_check(g.unlocked_count >= 2 and tile != null and tile.find_child("Revoir", true, false) != null, "galerie : nuit de Seo-Yeon débloquée par sa CG, bouton « Revoir »")
	g._set_filter("intime", "duo", "")
	await _frames()
	var duo: Node = g.find_child("paire_ryeon_nadia", true, false)
	var revoir: Node = duo.find_child("Revoir", true, false) if duo != null else null
	var money_before: int = GameState.store.money()
	var flags_before: int = GameState.store.flags.size()
	if revoir != null:
		revoir.pressed.emit()
		await _frames(6)
	_ui_check(g._replay != null and not g._panel.visible and g._replay._current.get("kind", "") == "line", "galerie : « Revoir » rejoue la scène")
	await _press(KEY_ESCAPE)
	_ui_check(g._replay == null and g._panel.visible and _modals().has(g), "galerie : Échap quitte la relecture et revient à la galerie")
	duo = g.find_child("paire_ryeon_nadia", true, false)
	duo.find_child("Revoir", true, false).pressed.emit()
	await _frames(4)
	if g._replay != null:
		g._replay._on_quick("skip")
		for i in 600:
			await get_tree().process_frame
			if g._replay == null:
				break
	_ui_check(g._replay == null and g._panel.visible, "galerie : la relecture terminée ramène à la galerie")
	_ui_check(GameState.store.money() == money_before and GameState.store.flags.size() == flags_before, "galerie : la relecture ne touche pas à la partie")
	g.queue_free()

	# Restauration de la méta-sauvegarde et de l'emplacement 3 du joueur
	SaveManager.meta = meta_backup
	SaveManager._write(SaveManager.META_PATH, meta_backup)
	if slot3_backup != "":
		var f := FileAccess.open(slot3, FileAccess.WRITE)
		f.store_string(slot3_backup)
		f.close()
	else:
		SaveManager.delete_slot("3")
	print("[uitest] %s" % ("INTERFACE OK" if _ui_fail == 0 else "%d ÉCHEC(S)" % _ui_fail))
	get_tree().quit(1 if _ui_fail else 0)
