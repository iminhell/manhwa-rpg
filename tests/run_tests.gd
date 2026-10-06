extends SceneTree
## Tests headless : godot --headless --path . -s res://tests/run_tests.gd
## Couvre l'état narratif, le moteur de dialogue, la validité des données et la logique de combat.

const StateStore := preload("res://core/state_store.gd")
const DialogueRunner := preload("res://narrative/dialogue_runner.gd")
const CombatState := preload("res://combat/combat_state.gd")
const DataDB := preload("res://core/data_db.gd")
const WorldModel := preload("res://world/world_model.gd")
const RefugeModel := preload("res://world/refuge_model.gd")
const SaveFormat := preload("res://core/save_format.gd")

var _passed := 0
var _failed := 0


func _init() -> void:
	test_state_store()
	test_dialogue_runner()
	test_dialogue_data()
	test_combat_targeting()
	test_combat_full_battles()
	test_combat_rewrite()
	test_combat_fear()
	test_combat_pull_charm()
	test_time()
	test_world_model()
	test_dialogue_fuzz()
	test_save_roundtrip()
	test_refuge()
	test_refuge_midloop()
	print("\n%d réussis, %d échoués" % [_passed, _failed])
	quit(1 if _failed > 0 else 0)


func check(cond: bool, label: String) -> void:
	if cond:
		_passed += 1
	else:
		_failed += 1
		printerr("ÉCHEC : " + label)


func test_state_store() -> void:
	var s := StateStore.new()
	s.apply_effects(["add align.protect 2", "add align.protect 3", "flag aide_choi", "set loop 2", "souvenir s1"])
	check(s.get_var("align.protect") == 5.0, "add cumule")
	check(s.has_flag("aide_choi"), "flag posé")
	check(s.loop() == 2, "set int")
	check(s.check("loop() > 1 and flag('aide_choi')"), "condition composée")
	check(not s.check("v('align.protect') > 10"), "condition fausse")
	check(s.check("souvenir('s1')"), "souvenir")
	var copy := StateStore.new()
	copy.from_dict(s.to_dict())
	check(copy.loop() == 2 and copy.has_flag("aide_choi"), "sérialisation")


func test_dialogue_runner() -> void:
	var dlg := {"id": "t", "start": "a", "blocks": {
		"a": [{"s": "elias", "t": "Salut"}, {"fx": ["add x 1"]}, {"if": "v('x') >= 1", "then": "b"}, {"t": "jamais"}],
		"b": [{"choice": [{"t": "Option cachée", "if": "false", "goto": "c"}, {"t": "Option 1", "goto": "c", "fx": ["flag pris"]}]}],
		"c": [{"event": "combat", "args": {"encounter": "e"}}, {"t": "Après"}, {"end": true}]}}
	var s := StateStore.new()
	var r := DialogueRunner.new(s)
	r.start(dlg)
	var step := r.next()
	check(step["kind"] == "line" and step["text"] == "Salut" and step["id"] == "t:a:0", "première réplique + id")
	step = r.next()
	check(step["kind"] == "choice" and step["options"].size() == 1, "fx + if + choix filtré")
	r.choose(0)
	check(s.has_flag("pris"), "effet de choix")
	step = r.next()
	check(step["kind"] == "event" and step["args"]["encounter"] == "e", "événement")
	step = r.next()
	check(step["kind"] == "line" and step["text"] == "Après", "reprise après événement")
	check(r.next()["kind"] == "end", "fin")
	check(DialogueRunner.validate({"start": "a", "blocks": {"a": [{"goto": "zz"}]}}).size() == 1, "validate détecte un bloc inconnu")


func test_dialogue_data() -> void:
	var dialogues := DataDB.load_dir("res://data/dialogues")
	check(dialogues.size() > 0, "dialogues chargés")
	for id in dialogues:
		var errors := DialogueRunner.validate(dialogues[id])
		check(errors.is_empty(), "dialogue %s valide %s" % [id, errors])
	# Parcours complet du prologue en prenant toujours le premier choix, combats gagnés
	var s := StateStore.new()
	s.set_var("loop", 1)
	var r := DialogueRunner.new(s)
	r.start(dialogues["prologue_j1"])
	var lines := 0
	var events := []
	for i in 2000:
		var step := r.next()
		match step["kind"]:
			"line": lines += 1
			"choice": r.choose(0)
			"event":
				events.append(step["name"])
				s.set_var("combat.last", "win")
			"end": break
	check(lines > 60, "prologue : %d répliques parcourues" % lines)
	check(events.count("combat") == 3, "prologue : 3 combats (%s)" % [events])
	check(s.has_flag("party.seo_yeon"), "Seo-Yeon rejoint le groupe")


func _load_combat(encounter: String, party_ids: Array, seed_value: int) -> CombatState:
	var chars := DataDB.load_dir("res://data/characters")
	var party := party_ids.map(func(id): return chars[id])
	var st := CombatState.new()
	st.setup(party, DataDB.load_json("res://data/combat/encounters.json")["encounters"][encounter],
		DataDB.load_json("res://data/combat/enemies.json")["enemies"],
		DataDB.load_json("res://data/combat/skills.json")["skills"], seed_value)
	return st


func test_combat_targeting() -> void:
	var st := _load_combat("j2_camp", ["elias", "seo_yeon"], 42)
	var elias = st.unit("elias")
	var melee := st.valid_targets(elias, "frappe_recouvreur")
	check(melee.size() == 2 and melee.all(func(u): return u.row == 0), "mêlée : uniquement la ligne avant ennemie")
	check(st.valid_targets(elias, "lancer_lame").size() == 3, "distance : tous les ennemis")
	var seo = st.unit("seo_yeon")
	check(not st.can_use(seo, "adrenaline"), "Adrénaline sans allié KO : impossible")
	check(not st.can_use(elias, "dernier_recouvrement"), "Ultime verrouillée sans Éveil")
	check(st.timeline(6).size() == 6, "frise CTB")
	var visible := st.alive("enemy").filter(func(e): return st.intent_visible(e))
	check(visible.size() == 2, "Pressentiment : 2 intentions visibles")


## Joue des combats complets avec la politique automatique : ils doivent se terminer.
func test_combat_full_battles() -> void:
	var parties := {"tuto_rodeur": ["elias"], "j1_maree": ["elias"], "j2_camp": ["elias", "seo_yeon"],
		"portier_test": ["elias", "seo_yeon", "haneul", "hae_in"],
		"concert_maree": ["elias", "seo_yeon", "haneul", "aoi"], "tunnels": ["elias", "haneul", "aoi", "maricel"],
		"mere_sourde": ["elias", "seo_yeon", "haneul", "aoi", "maricel"],
		"maree_t3": ["elias", "seo_yeon", "haneul", "aoi", "maricel"],
		"duel_tae_ju": ["elias"], "duel_ryeon": ["ryeon"], "duel_ryeon_avertie": ["ryeon"], "fang": ["elias", "haneul", "aoi", "maricel", "ryeon"],
		"coup_haesong": ["elias", "seo_yeon", "haneul", "aoi", "maricel", "ryeon", "xiaoyu"],
		"maree_rouge": ["elias", "seo_yeon", "haneul", "aoi", "maricel", "ryeon", "xiaoyu", "hae_in"],
		"courtier": ["elias", "seo_yeon", "haneul", "aoi", "maricel", "ryeon"],
		"hote_affame": ["elias", "seo_yeon", "haneul", "aoi", "maricel", "ryeon", "xiaoyu"]}
	for enc in parties:
		for seed_value in [7, 11, 23]:
			var st := _load_combat(enc, parties[enc], seed_value)
			var turns := 0
			while st.result() == "" and turns < 500:
				var actor = st.begin_turn()
				turns += 1
				if st.skip_if_stunned(actor):
					continue
				if actor.side == "enemy":
					st.run_enemy_turn(actor)
					continue
				var act := st.auto_action(actor)
				check(not act.is_empty(), "%s : une action possible pour %s" % [enc, actor.name])
				if not act.is_empty():
					st.use_skill(actor, act["skill"], act["target"])
			check(st.result() != "", "%s terminé en %d tours → %s" % [enc, turns, st.result()])
			var hp: Array = st.units.filter(func(u): return u.side == "ally").map(
				func(u): return "%s %d/%d" % [u.name, u.hp, u.max_hp])
			print("  %s (seed %d) : %s en %d tours — %s" % [enc, seed_value, st.result(), turns, ", ".join(hp)])


func test_combat_rewrite() -> void:
	var st := _load_combat("tuto_rodeur", ["elias"], 3)
	st.rewrite_charges = 1
	var actor = st.begin_turn()
	while actor.side != "ally":
		st.run_enemy_turn(actor)
		actor = st.begin_turn()
	var enemy = st.alive("enemy")[0]
	var hp_before: int = enemy.hp
	st.take_snapshot()
	st.use_skill(actor, "frappe_recouvreur", enemy)
	check(st.unit(enemy.uid).hp < hp_before, "dégâts infligés")
	check(st.rewrite(), "réécriture utilisée")
	check(st.unit(enemy.uid).hp == hp_before, "réécriture : PV restaurés")
	check(st.rewrite_charges == 0 and not st.can_rewrite(), "charge consommée")


func test_combat_fear() -> void:
	var st := _load_combat("tuto_rodeur", ["elias"], 5)
	var enemy = st.alive("enemy")[0]
	st._apply(st.unit("elias"), enemy, {"type": "fear", "value": 120})
	check(enemy.fled and st.result() == "win", "Peur ≥ 100 : l'ennemi fuit")


## Acte II : Grappin (attire en première ligne) et Charme (l'ennemi frappe les siens).
## v0.8 : famine plus punitive au milieu de la boucle, pénurie d'eau.
func test_refuge_midloop() -> void:
	var s := StateStore.new()
	var r := RefugeModel.new(s, DataDB.load_json("res://data/world/refuge.json"))
	s.set_flag("party.seo_yeon")
	s.set_flag("party.haneul")
	s.set_time(11, 0)
	r.establish("yeouido.parking")
	var need := r.daily_need()
	s.set_var("eau.controle", "longwei")
	check(r.daily_need() == need + 1, "pénurie d'eau : +1 ration de besoin")
	s.set_var("refuge.rations", 0)
	s.set_var("fatigue", 0)
	var t := s.trust("seo_yeon")
	var a := s.aff("seo_yeon")
	for i in 3:
		s.set_time(12 + i, 0)
		r.daily_upkeep()
	check(s.trust("seo_yeon") == t - 12, "famine J10+ : −4 Confiance par jour")
	check(int(s.get_var("fatigue")) >= 12, "famine J10+ : fatigue accumulée")
	check(s.aff("seo_yeon") < a, "trois jours de faim : l'Affinité baisse")
	check(int(s.get_var("refuge.defense")) < 0 or int(s.get_var("refuge.defense")) <= -15, "famine J10+ : défense du Refuge en baisse")


func test_combat_pull_charm() -> void:
	var st := _load_combat("concert_maree", ["elias", "aoi", "maricel"], 9)
	var back = st.unit_at("enemy", 2, 2)
	var front = st.unit_at("enemy", 0, 2)
	check(back != null and front != null, "concert_maree : ennemis aux positions attendues")
	if back == null or front == null:
		return
	st._apply(st.unit("maricel"), back, {"type": "pull"})
	check(back.row == 0 and front.row == 2, "Grappin : la cible passe devant, l'occupant recule")
	check(st.valid_targets(st.unit("elias"), "frappe_recouvreur").has(back), "Grappin : la cible devient attaquable en mêlée")
	var charmed = st.alive("enemy")[0]
	charmed.statuses["charm"] = 2
	var allies_hp := 0
	for u in st.alive("ally"):
		allies_hp += u.hp
	var enemies_hp := 0
	for u in st.alive("enemy"):
		if u != charmed:
			enemies_hp += u.hp
	st.run_enemy_turn(charmed)
	var allies_after := 0
	for u in st.alive("ally"):
		allies_after += u.hp
	var enemies_after := 0
	for u in st.units.filter(func(x): return x.side == "enemy" and x != charmed):
		enemies_after += max(0, u.hp)
	check(allies_after == allies_hp, "Charme : aucun allié touché")
	check(enemies_after < enemies_hp, "Charme : un ennemi frappe les siens")


func test_time() -> void:
	var s := StateStore.new()
	check(s.day() == 1 and s.phase() == 0, "J1 Aube au départ")
	s.advance_ticks(5)
	check(s.day() == 1 and s.phase() == 1, "5 ticks = J1 Jour")
	s.set_time(2, 3)
	check(s.day() == 2 and s.phase() == 3, "set_time J2 Nuit")
	s.set_time(1, 0)
	check(s.day() == 2, "set_time ne remonte jamais le temps")
	s.sleep_until_dawn()
	check(s.day() == 3 and s.phase() == 0 and int(s.get_var("fatigue")) == 0, "dormir → aube suivante, fatigue 0")
	s.sleep_until_dawn()
	check(s.day() == 3 and s.phase() == 0, "dormir à l'aube ne saute pas de journée")
	check(is_equal_approx(s.pressure(), 25.0), "Pression J3 = 25 (%s)" % s.pressure())
	s.apply_effects(["pressure -10", "item ration 2", "money 30", "join seo_yeon", "fin aoi"])
	check(is_equal_approx(s.pressure(), 15.0) and s.item("ration") == 2 and s.money() == 30, "effets pression/objet/argent")
	check(s.party("seo_yeon") and s.knows_fin("aoi"), "effets groupe/Fin")


func _world(store) -> WorldModel:
	return WorldModel.new(store, DataDB.load_json("res://data/world/sectors.json"), DataDB.load_json("res://data/world/events.json"),
		DataDB.load_json("res://data/world/refuge.json"))


func test_world_model() -> void:
	var s := StateStore.new()
	s.set_time(2, 2)
	var w := _world(s)
	w.place("yeouido.camp")
	check(w.sector_id() == "yeouido" and not w.is_refuge("yeouido.camp"), "camp : pas encore un refuge")
	check(not w.node_visible("yeouido.parking"), "bunker B6 caché sans le souvenir")
	s.add_souvenir("s1_bunker_b6")
	check(w.node_visible("yeouido.parking"), "bunker B6 révélé par le souvenir n°1")
	check(not w.node_open("yeouido.labo"), "labo Haesong verrouillé sans badge")
	check(w.can_move("yeouido.ifc") and not w.can_move("yeouido.labo"), "déplacements : liens et verrous")
	var t0: int = s.ticks()
	w.move("yeouido.ifc")
	check(s.ticks() == t0 + 1 and w.node_id() == "yeouido.ifc", "déplacement = 1 tick")
	check(not w.sector_available("etage1"), "étage 1 fermé avant J5")
	check(w.travel_cost("ponts") == 3 and w.travel_cost("gangnam") == 6, "coûts de trajet (adjacent / lointain)")
	# Événement daté : le rêve du J2 interrompt l'avancée à la nuit
	w.take_event()
	w.advance(8)
	var ev := w.take_event()
	check(ev.get("id", "") == "j2_reve", "J2 Nuit : le rêve de Haneul se déclenche (%s)" % ev.get("id", "-"))
	check(s.phase() == 3 and s.day() == 2, "le temps s'arrête à la frontière de la nuit")
	check(w.take_event().get("id", "") == "maree", "puis la Marée (hors refuge)")
	check(w.take_event().is_empty(), "plus d'événement en attente")
	# Zones cachées liées au calendrier et à la boucle
	w.place("yongsan.ruelle")
	check(w.node_visible("yongsan.eclat"), "Éclat du Vestibule visible la nuit")
	check(not w.node_visible("yongsan.abri7"), "abri n°7 caché en boucle 1")
	s.set_var("loop", 2)
	check(w.node_visible("yongsan.abri7") and w.node_visible("ponts.grotte"), "boucle 2 : abri n°7 et grotte révélés")
	# Accès à l'étage 1
	s.set_time(5, 0)
	s.set_flag("passe_tour")
	w.place("yongsan.porte_tour")
	check(w.can_travel("etage1"), "étage 1 accessible depuis Yongsan au J5 avec le laissez-passer")
	w.place("ponts.banpo")
	check(not w.can_travel("etage1"), "étage 1 inaccessible hors de Yongsan")
	# Recherche de chemin
	w.place("yeouido.camp")
	check(w.path_step("etage1.porte_sans_serrure").has("travel"), "chemin inter-secteurs")
	w.place("yongsan.appart")
	var step := w.path_step("yongsan.porte_tour")
	check(step.get("move", "") == "yongsan.rue_itaewon", "chemin intra-secteur (%s)" % step)
	# Actions : une seule fois, puis disparaît
	var n_before := w.actions().size()
	for a in w.actions():
		if a.get("id") == "fouiller":
			w.do_action(a)
	check(w.actions().size() == n_before - 1 and s.item("ration") >= 2, "action « une fois » consommée")
	# Malaise d'épuisement
	var s2 := StateStore.new()
	var w2 := _world(s2)
	w2.place("hongdae.rue_clubs")
	s2.set_time(1, 2)
	s2.set_var("fatigue", 31)
	s2.set_flag("event.j2_reve")
	s2.set_flag("event.maree")
	w2.advance(2)
	check(int(s2.get_var("fatigue")) == 0 and s2.phase() == 0 and s2.day() == 2, "malaise du soir à 32 de fatigue → aube suivante")
	var s3 := StateStore.new()
	var w3 := _world(s3)
	w3.place("hongdae.rue_clubs")
	s3.set_var("fatigue", 31)
	w3.advance(2)
	check(int(s3.get_var("fatigue")) == 0 and s3.day() == 1 and s3.phase() == 2, "malaise du matin : deux phases perdues, pas une journée")


## Parcourt chaque bloc de chaque dialogue avec des choix aléatoires : aucune erreur ni boucle infinie.
func test_dialogue_fuzz() -> void:
	var dialogues := DataDB.load_dir("res://data/dialogues")
	var rng := RandomNumberGenerator.new()
	rng.seed = 1234
	var runs := 0
	for id in dialogues:
		for block in dialogues[id]["blocks"]:
			for attempt in 4:
				var s := StateStore.new()
				s.set_var("loop", 1 + attempt % 3)
				s.set_time(1 + rng.randi_range(0, 6), rng.randi_range(0, 3))
				for f in ["camp_defendu", "camp_vassal", "haneul_trouvee", "archive_copie", "haein_rencontree", "portier_vaincu"]:
					if rng.randf() < 0.4:
						s.set_flag(f)
				s.set_var("combat.last", "win" if rng.randf() < 0.8 else "lose")
				var r := DialogueRunner.new(s)
				r.start(dialogues[id], block)
				var ended := false
				for i in 400:
					var st := r.next()
					if st["kind"] == "choice":
						r.choose(rng.randi_range(0, st["options"].size() - 1))
					elif st["kind"] == "end":
						ended = true
						break
				runs += 1
				check(ended, "%s:%s se termine" % [id, block])
	print("  fuzz dialogues : %d parcours" % runs)


func test_save_roundtrip() -> void:
	var s := StateStore.new()
	s.set_var("loop", 2)
	s.set_time(6, 2)
	s.apply_effects(["flag camp_defendu", "join seo_yeon", "souvenir s1_bunker_b6", "money 75", "item ration 3", "add align.protect 12"])
	s.set_var("pos.node", "yeouido.camp")
	s.set_var("pos.sector", "yeouido")
	var data := SaveFormat.build_save(s, ["elias", "seo_yeon"])
	var text := JSON.stringify(data)
	var back: Dictionary = JSON.parse_string(text)
	var s2 := StateStore.new()
	s2.from_dict(back["store"])
	check(s2.day() == 6 and s2.phase() == 2 and s2.loop() == 2, "sauvegarde : temps et boucle restaurés")
	check(s2.has_flag("camp_defendu") and s2.party("seo_yeon") and s2.souvenir("s1_bunker_b6"), "sauvegarde : drapeaux, groupe, souvenirs")
	check(s2.money() == 75 and s2.item("ration") == 3 and int(s2.get_var("align.protect")) == 12, "sauvegarde : ressources et alignement")
	check(back["summary"]["node"] == "yeouido.camp" and int(back["summary"]["day"]) == 6, "sauvegarde : résumé de l'emplacement")
	var w := _world(s2)
	w.refresh()
	check(w.node_id() == "yeouido.camp" and w.is_refuge("yeouido.camp"), "sauvegarde : le monde se reconstruit depuis l'état")


func test_refuge() -> void:
	var s := StateStore.new()
	s.set_time(5, 2)
	s.set_var("fatigue", 0)
	s.apply_effects(["flag camp_defendu", "join seo_yeon", "join haneul", "money 200", "item ration 5", "item fragment_strate 2"])
	var w := _world(s)
	w.place("yeouido.camp")
	var ids: Array = w.actions().map(func(a): return a.get("id"))
	check(ids.has("_establish") and not ids.has("_manage"), "refuge : établir proposé, pas encore géré")
	for a in w.actions():
		if a.get("id") == "_establish":
			w.do_action(a)
	var r = w.refuge
	check(r.established() and r.node_id() == "yeouido.camp" and r.rations() == 2, "refuge établi avec 2 rations de départ")
	ids = w.actions().map(func(a): return a.get("id"))
	check(ids.has("_manage") and ids.has("_rest_seo_yeon") and ids.has("_rest_haneul"), "refuge : gestion et repos avec chaque héroïne")
	check(r.residents() == 3 and r.daily_need() == 2, "3 résidents → 2 rations par jour")
	check(r.deposit(5) == 5 and r.rations() == 7 and s.item("ration") == 0, "dépôt de rations")
	check(r.build("cuisine") == 4 and r.has("cuisine") and r.rations() == 5 and s.money() == 170, "construction : coût et effet")
	check(not r.can_build("cuisine"), "amélioration déjà construite")
	check(r.build("atelier") > 0 and r.sell_fragments() == 2 and s.money() == 160, "atelier : vente des fragments")
	s.set_time(6, 0)
	s.set_var("fatigue", 0)
	w.refresh()
	check(r.rations() == 4, "entretien : +1 cuisine −2 besoin (%d)" % r.rations())
	s.set_var("refuge.rations", 0)
	var trust_before := s.trust("seo_yeon")
	s.set_time(7, 0)
	s.set_var("fatigue", 0)
	w.refresh()
	check(int(s.get_var("refuge.faim")) == 1 and s.trust("seo_yeon") < trust_before, "famine : faim et perte de Confiance")
	r.build("infirmerie")
	for e in ["j7_classement", "j7_reve", "maree"]:
		s.set_flag("event." + e)  # la nuit ne doit pas être interrompue pour ce test
	s.set_var("refuge.rations", 10)  # pas de famine cette nuit
	var t := s.trust("haneul")
	w.place("yeouido.camp")
	while not w.take_event().is_empty():
		pass
	w.sleep()
	check(s.trust("haneul") == t + 1, "infirmerie : nuit au Refuge → +1 Confiance")
	s.set_time(s.day(), 2)
	w.take_event()
	var rest := w.actions().filter(func(a): return a.get("rest", false))
	var n_rest := rest.size()
	w.do_action(rest[0])
	var left := w.actions().filter(func(a): return a.get("rest", false))
	check(left.size() == n_rest - 1 and not left.any(func(a): return a["id"] == rest[0]["id"]),
		"un moment de repos par héroïne et par jour")
	# Vigie : pas de Marée dans le secteur du Refuge
	s.set_flag("refuge.vigie")
	w.place("yeouido.ifc")
	s.set_time(s.day(), 3)
	check(not w.next_event().get("id", "") == "maree", "vigie : pas de Marée dans le secteur du Refuge")
