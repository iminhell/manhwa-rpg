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
const Echoes := preload("res://core/echoes.gd")

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
	test_systems_v09()
	test_refuge_voies()
	test_scene_matrix()
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
	var vs := StateStore.new()
	check(vs.voie() == "", "voie indéterminée au départ")
	vs.set_var("argent", 450)
	check(vs.voie() == "mercenaire" and vs.check("voie() == 'mercenaire'"), "voie du Mercenaire")
	vs.set_var("align.protect", -25)
	check(vs.voie() == "tyran", "le Tyran prime sur le Mercenaire")
	vs.set_var("align.protect", 30)
	check(vs.voie() == "heros", "voie du Héros")


func test_dialogue_runner() -> void:
	var dlg := {"id": "t", "start": "a", "blocks": {
		"a": [{"s": "elias", "t": "Salut"}, {"fx": ["add x 1"]}, {"if": "v('x') >= 1", "then": "b"}, {"t": "jamais"}],
		"b": [{"choice": [{"t": "Option cachée", "if": "false", "goto": "c"}, {"t": "Option 1", "goto": "c", "fx": ["flag pris"]}]}],
		"c": [{"event": "combat", "args": {"encounter": "e"}}, {"t": "Après"}, {"end": true}]}}
	var s := StateStore.new()
	var r := DialogueRunner.new(s)
	var entered: Array = []
	r.on_enter = func(ref): entered.append(ref)
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
	check(entered == ["t:a", "t:b", "t:c"], "entrée de chaque bloc signalée (déblocage de la galerie)")
	var wd := {"id": "w", "start": "a", "blocks": {"a": [{"t": "toujours"}, {"t": "si x", "when": "flag('x')"}, {"t": "fin"}]}}
	var ws := StateStore.new()
	var wr := DialogueRunner.new(ws)
	wr.start(wd)
	check(wr.next()["text"] == "toujours" and wr.next()["text"] == "fin", "étape « when » sautée si fausse")
	ws.set_flag("x")
	wr.start(wd)
	wr.next()
	check(wr.next()["text"] == "si x", "étape « when » jouée si vraie")
	check(DialogueRunner.validate({"start": "a", "blocks": {"a": [{"goto": "zz"}]}}).size() == 1, "validate détecte un bloc inconnu")
	# Passages P3 : joués sur place, sautés s'ils sont vides ou masqués
	var slot_dlg := {"id": "p", "start": "a", "blocks": {"a": [{"t": "avant"},
		{"text_p3_slot": [{"s": "narrator", "t": "p3 un"}, {"s": "seo_yeon", "t": "p3 deux", "e": "desire"}]},
		{"text_p3_slot": []}, {"t": "après"}, {"end": true}]}}
	r = DialogueRunner.new(s)
	r.start(slot_dlg)
	var seen := []
	for i in 10:
		step = r.next()
		if step["kind"] != "line":
			break
		seen.append(step["text"])
		if step["text"] == "p3 deux":
			check(step["id"] == "p:a:1:p3:1" and step["speaker"] == "seo_yeon" and not step["voiced"], "passage P3 : id et locuteur")
	check(seen == ["avant", "p3 un", "p3 deux", "après"], "passage P3 joué dans la continuité %s" % [seen])
	r = DialogueRunner.new(s)
	r.show_p3 = false
	r.start(slot_dlg)
	seen = []
	for i in 10:
		step = r.next()
		if step["kind"] != "line":
			break
		seen.append(step["text"])
	check(seen == ["avant", "après"], "passage P3 masqué par la préférence %s" % [seen])


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
		"hote_affame": ["elias", "seo_yeon", "haneul", "aoi", "maricel", "ryeon", "xiaoyu"],
		"nadia_toit": ["elias"], "machine_inversion": ["elias", "haneul", "aoi", "maricel", "ryeon", "nadia"],
		"silo_unite0": ["elias", "seo_yeon", "haneul", "ryeon", "xiaoyu", "nadia"],
		"minotaure": ["elias", "seo_yeon", "haneul", "ryeon", "nadia", "minh_anh"],
		"bourreau_fort": ["elias", "seo_yeon", "haneul", "ryeon", "simone", "minh_anh"],
		"juge": ["elias", "seo_yeon", "haneul", "ryeon", "simone", "nadia"], "champion_hier": ["elias"],
		"jardiniere": ["elias", "seo_yeon", "haneul", "aoi", "ryeon", "simone"],
		"front_final": ["elias", "seo_yeon", "haneul", "ryeon", "simone", "nadia"],
		"prophete": ["elias", "seo_yeon", "haneul", "ryeon", "simone", "nadia"],
		"administratrice": ["elias", "seo_yeon", "ryeon", "simone", "nadia", "minh_anh"],
		"epreuve_dix": ["elias", "seo_yeon", "haneul", "ryeon", "simone", "nadia"]}
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
## v0.9 : modes de difficulté, jours de répit, cadeaux, échos inter-boucles, Indice de Résilience.
func test_systems_v09() -> void:
	var dif: Dictionary = DataDB.load_json("res://data/world/difficulty.json")["modes"]
	# Combat : le mode multiplie l'attaque et les PV des ennemis
	var st := _load_combat("tunnels", ["elias"], 3)
	var e = st.alive("enemy")[0]
	var atk: float = e.atk
	var hp: int = e.max_hp
	st.apply_difficulty(float(dif["histoire"]["enemy_atk"]), float(dif["histoire"]["enemy_hp"]))
	check(e.atk < atk and e.max_hp < hp and e.hp == e.max_hp, "mode Histoire : ennemis affaiblis")
	# Refuge : besoin en rations et famine selon le mode
	var s := StateStore.new()
	var r := RefugeModel.new(s, DataDB.load_json("res://data/world/refuge.json"))
	s.set_flag("party.seo_yeon")
	s.set_flag("party.haneul")
	r.establish("yeouido.parking")
	var need := r.daily_need()
	r.difficulty = dif["survie"]
	check(r.daily_need() > need, "mode Survie : plus de rations par jour")
	r.difficulty = dif["histoire"]
	s.set_var("refuge.rations", 0)
	var t := s.trust("seo_yeon")
	s.set_time(12, 0)
	r.daily_upkeep()
	check(s.trust("seo_yeon") == t, "mode Histoire : la famine ne coûte rien")
	# Jour de répit : pas d'Ancre, le temps revient au matin, repos de nouveau possibles
	var s2 := StateStore.new()
	var w := WorldModel.new(s2, DataDB.load_json("res://data/world/sectors.json"), DataDB.load_json("res://data/world/events.json"),
		DataDB.load_json("res://data/world/refuge.json"), dif["normal"], DataDB.load_json("res://data/world/gifts.json"))
	s2.set_flag("souvenir_dummy")
	s2.souvenirs["s1_bunker_b6"] = true
	s2.set_flag("bunker_ouvert")
	s2.set_flag("party.haneul")
	s2.set_time(8, 0)
	w.place("yeouido.parking")
	while not w.take_event().is_empty():
		pass
	w.refuge.establish("yeouido.parking")
	check(not w.actions().any(func(a): return a.get("repit", false)), "répit : impossible sans sablier (mode Normal)")
	s2.apply_effects(["item sablier 1", "item cadeau_pain_au_lait 1"])
	var rep := w.actions().filter(func(a): return a.get("repit", false))
	check(rep.size() == 1, "répit : proposé au Refuge avec un sablier")
	var morning: int = s2.ticks()
	w.do_action(rep[0])
	check(w.in_repit() and s2.item("sablier") == 0, "répit : déclaré, sablier consommé")
	check(w.next_event().is_empty() and not w._check_events(), "répit : aucune Ancre ne se déclenche")
	var rest := w.actions().filter(func(a): return a.get("rest", false))
	check(not rest.is_empty(), "répit : moments de repos dès le matin")
	w.do_action(rest[0])
	var gift := w.actions().filter(func(a): return a.has("gift"))
	check(gift.size() == 1, "cadeau : un cadeau proposé pour Haneul")
	var aff := s2.aff("haneul")
	w.do_action(gift[0])
	check(s2.aff("haneul") == aff + 8 and s2.item("cadeau_pain_au_lait") == 0, "cadeau adoré : Affinité +8")
	w.advance(16)
	check(not w.in_repit() and s2.ticks() == morning and int(s2.get_var("fatigue")) == 0, "répit : à la nuit, retour au matin")
	check(s2.aff("haneul") >= aff + 8, "répit : les liens tissés restent")
	check(w.actions().any(func(a): return a.get("id", "") == "_rest_haneul") or s2.phase() < 2, "répit : la journée réelle reste à vivre")
	w.difficulty = dif["histoire"]
	check(w.can_start_repit(), "mode Histoire : répit illimité")
	# Échos : gravés à la régression, cumulatifs
	var old := StateStore.new()
	old.set_flag("aoi_sauvee")
	old.set_flag("echo.seo_morte")
	var ech: Array = Echoes.after_loop(old, DataDB.load_json("res://data/world/echoes.json")["echoes"])
	check(ech.has("echo.aoi_sauvee") and ech.has("echo.seo_morte") and not ech.has("echo.ryeon_morte"), "échos : acquis et nouveaux, rien d'autre")
	# Indice de Résilience
	var s3 := StateStore.new()
	s3.resilience = DataDB.load_json("res://data/world/resilience.json")
	var base := s3.ir()
	s3.set_flag("treve_signee")
	s3.set_var("eau.controle", "rats")
	check(s3.ir() == base + 16, "IR : Trêve +10, eau partagée +6")


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


## Parcourt un bloc en prenant toujours le premier choix ; renvoie les répliques vues.
func _play(s, dlg: Dictionary, block: String) -> Array:
	var r := DialogueRunner.new(s)
	r.start(dlg, block)
	var seen := []
	for i in 200:
		var st := r.next()
		match st["kind"]:
			"line": seen.append(st["text"])
			"choice": r.choose(0)
			"end": break
	return seen


func test_refuge_voies() -> void:
	var dlg: Dictionary = DataDB.load_dir("res://data/dialogues")["refuge"]
	# Voie du Mercenaire : la nuit de Seo-Yeon passe par le registre de dettes
	var s := StateStore.new()
	s.apply_effects(["set argent 450", "set repos.seo_yeon 1", "flag refuge.dortoir", "set aff.seo_yeon 30"])
	var seen := _play(s, dlg, "seo_yeon")
	check(seen.size() > 0 and seen[0].begins_with("Seo-Yeon tient un registre") and s.has_flag("seo_nuit"), "Refuge : nuit du Mercenaire (Seo-Yeon)")
	# Même état, voie du Héros : la scène d'origine
	s = StateStore.new()
	s.apply_effects(["set align.protect 25", "set repos.seo_yeon 1", "flag refuge.dortoir", "set aff.seo_yeon 30"])
	seen = _play(s, dlg, "seo_yeon")
	check(seen.size() > 0 and seen[0].begins_with("Le dortoir, tard"), "Refuge : nuit du Héros inchangée")
	# Pacte en Ressentiment : clause de rupture, puis porte froide
	s = StateStore.new()
	s.apply_effects(["flag pacte.seo_yeon", "set ambivalence.seo_yeon -70"])
	_play(s, dlg, "seo_yeon")
	check(not s.has_flag("pacte.seo_yeon") and s.has_flag("seo_rupture"), "Pacte : rupture invoquée")
	seen = _play(s, dlg, "seo_yeon")
	check(seen.size() == 1 and seen[0].begins_with("Seo-Yeon refait tes points sans un mot"), "Pacte : après la rupture, la porte reste froide")
	# Pacte en Dévotion : renouvellement libre, puis nuit directe aux visites suivantes
	for pre in ["seo", "xiaoyu", "haein", "simone", "nadia"]:
		var cid: String = {"seo": "seo_yeon", "haein": "hae_in"}.get(pre, pre)
		var pflag: String = "nadia_pactisee" if pre == "nadia" else "pacte." + cid
		s = StateStore.new()
		s.apply_effects(["flag " + pflag, "set ambivalence.%s 65" % cid, "set aff.%s 75" % cid])
		_play(s, dlg, "%s_pacte" % pre)
		check(s.has_flag(pre + "_devotion") and s.has_flag(pflag), "Pacte : Dévotion de %s (Pacte renouvelé)" % cid)
	# Après la Dévotion, le Pacte est renouvelé librement : plus de nuit de Pacte en boucle, retour aux moments ordinaires
	s = StateStore.new()
	s.apply_effects(["flag pacte.seo_yeon", "flag seo_devotion", "flag seo_nuit", "set ambivalence.seo_yeon 70", "set aff.seo_yeon 75",
		"set repos.seo_yeon 3", "flag refuge.dortoir"])
	seen = _play(s, dlg, "seo_yeon")
	check(seen.size() > 0 and seen[0].begins_with("Elle a pris l'habitude"), "Pacte : après la Dévotion, seconde nuit ordinaire (pas de boucle)")
	# Aoi rachetée à Mirae : le contrat prime à chaque repos, même après le premier
	s = StateStore.new()
	s.apply_effects(["flag aoi_dominee", "set repos.aoi 3", "flag refuge.dortoir", "set aff.aoi 40", "flag aoi_nuit"])
	seen = _play(s, dlg, "aoi")
	check(seen.size() > 0 and seen[0].begins_with("Vous voulez que je chante") and not s.has_flag("aoi_devotion"), "Pacte : Aoi dominée, le contrat est vérifié en premier")
	# Pacte évolutif : ambivalence → contrat renégocié par l'héroïne → nuit consentie → moments ordinaires
	for pre in ["seo", "xiaoyu", "haein", "simone", "nadia", "aoi"]:
		var cid: String = {"seo": "seo_yeon", "haein": "hae_in"}.get(pre, pre)
		var pflag: String = {"nadia": "nadia_pactisee", "aoi": "aoi_dominee"}.get(pre, "pacte." + cid)
		s = StateStore.new()
		s.apply_effects(["flag " + pflag, "set ambivalence.%s 35" % cid, "set aff.%s 45" % cid, "set repos.%s 1" % cid, "flag refuge.dortoir"])
		_play(s, dlg, cid)
		check(s.has_flag(pre + "_pacte_accepte") and s.has_flag({"seo": "seo_nuit", "haein": "haein_nuit"}.get(pre, cid + "_nuit")),
			"Pacte : %s renégocie le contrat, nuit consentie" % cid)
		var r2 := DialogueRunner.new(s)
		r2.start(dlg, cid)
		var k2 := r2.next()
		while k2.get("kind", "") != "line" and k2.get("kind", "") != "choice" and k2.get("kind", "") != "end":
			k2 = r2.next()
		check(not r2.block.contains("pacte") and not r2.block.contains("dominee"), "Pacte : %s, contrat renégocié → moments ordinaires (%s)" % [cid, r2.block])
	s = StateStore.new()
	s.apply_effects(["flag pacte.seo_yeon", "set ambivalence.seo_yeon 10"])
	var seen3 := _play(s, dlg, "seo_pacte")
	check(seen3.any(func(t): return t.begins_with("Pacte de Vassalité — Ambivalence : elle ne sait plus")) and not seen3.any(func(t): return t.contains("elle te hait et elle a peur")),
		"Pacte : le texte du Registre suit l'ambivalence")
	# Scènes à plusieurs : jamais verrouillées ; héroïne sous contrat imposé → variante sans intimité
	var grp: Dictionary = DataDB.load_dir("res://data/dialogues")["refuge_groupe"]
	s = StateStore.new()
	s.apply_effects(["flag pacte.seo_yeon", "join seo_yeon", "join aoi"])
	var r3 := DialogueRunner.new(s)
	r3.start(grp, "paire_seo_yeon_aoi")
	var first := r3.next()
	while first.get("kind", "") != "line" and first.get("kind", "") != "end":
		first = r3.next()
	check(r3.block == "pacte_groupe_seo_yeon" and first.get("kind", "") == "line", "Groupe : variante de Pacte (Seo-Yeon sous contrat imposé)")
	s.apply_effects(["flag seo_pacte_accepte"])
	r3.start(grp, "paire_seo_yeon_aoi")
	first = r3.next()
	while first.get("kind", "") != "line" and first.get("kind", "") != "end":
		first = r3.next()
	check(r3.block == "paire_seo_yeon_aoi", "Groupe : contrat renégocié, scène normale")
	# Nuit de Pacte : rapport de force, sans scène intime ni passage P3
	for blk in ["seo_pacte_reste", "xiaoyu_pacte_reste", "haein_pacte_reste", "nadia_pacte_ici", "simone_pacte_reste"]:
		var has_slot := false
		for st in dlg["blocks"][blk]:
			has_slot = has_slot or st.has("text_p3_slot") or st.has("cg")
		check(not has_slot, "Pacte : %s sans passage P3 ni CG intime" % blk)


# --- Matrice des scènes : chaque voie et chaque état de Pacte mène à une scène cohérente, rien n'est bloqué ---------

## Joue un bloc (premier choix à chaque fois) ; renvoie les blocs traversés.
func _route(s, dlg: Dictionary, block: String) -> Array:
	var r := DialogueRunner.new(s)
	var seen: Array = []
	r.on_enter = func(ref): seen.append(str(ref).get_slice(":", 1))
	r.start(dlg, block)
	for i in 300:
		var st := r.next()
		if st["kind"] == "choice":
			r.choose(0)
		elif st["kind"] == "end":
			break
	return seen


func _intimate(dlg: Dictionary, blocks: Array) -> bool:
	for b in blocks:
		for st in dlg["blocks"].get(b, []):
			if st.has("text_p3_slot"):
				return true
	return false


func test_scene_matrix() -> void:
	var all: Dictionary = DataDB.load_dir("res://data/dialogues")
	var dlg: Dictionary = all["refuge"]
	var grp: Dictionary = all["refuge_groupe"]
	var H := ["seo_yeon", "haneul", "aoi", "maricel", "ryeon", "xiaoyu", "hae_in", "nadia", "simone", "minh_anh"]
	var PRE := {"seo_yeon": "seo", "hae_in": "haein"}
	var PACT := {"seo_yeon": "pacte.seo_yeon", "xiaoyu": "pacte.xiaoyu", "hae_in": "pacte.hae_in", "simone": "pacte.simone",
		"nadia": "nadia_pactisee", "aoi": "aoi_dominee"}
	var ECHO := {"seo_yeon": "seo_morte", "haneul": "haneul_capturee", "aoi": "aoi_sauvee", "maricel": "maricel_morte",
		"ryeon": "ryeon_morte", "xiaoyu": "xiaoyu_sauvee", "hae_in": "haein_sauvee", "nadia": "nadia_tir",
		"simone": "simone_sauvee", "minh_anh": "minh_anh_sauvee"}
	for h in H:
		var p: String = PRE.get(h, h)
		var nf := p + "_nuit"
		var base := ["set repos.%s 1" % h, "flag refuge.dortoir", "set aff.%s 45" % h]
		# Voies, héroïne libre : chaque voie a sa nuit
		for v in [["heros", "set align.protect 25", p + "_intime"], ["tyran", "set align.protect -25", p + "_ombre"],
				["loup", "set align.bond -25", p + "_loup"], ["mercenaire", "set argent 450", p + "_merc"]]:
			var s := StateStore.new()
			s.apply_effects(base + [v[1]])
			var seen := _route(s, dlg, h)
			check(seen.size() > 1 and seen[1] == v[2] and _intimate(dlg, seen) and s.has_flag(nf),
				"Matrice : %s, voie %s → %s %s" % [h, v[0], v[2], seen])
		# Seconde nuit, puis Écho (récurrence 2)
		var s2 := StateStore.new()
		s2.apply_effects(base + ["set align.protect 25", "flag " + nf, "set repos.%s 3" % h])
		var seen2 := _route(s2, dlg, h)
		check(seen2.size() > 1 and seen2[1] == p + "_nuit2", "Matrice : %s, seconde nuit %s" % [h, seen2])
		var s3 := StateStore.new()
		s3.apply_effects(base + ["set loop 2", "flag echo." + ECHO[h]])
		var seen3 := _route(s3, dlg, h)
		var echo_b: String = {"seo_yeon": "seo_yeon_echo", "hae_in": "hae_in_echo"}.get(h, h + "_echo")
		check(seen3.size() > 1 and seen3[1] == echo_b and s3.has_flag("echo_vu." + h), "Matrice : %s, Écho %s" % [h, seen3])
		if not PACT.has(h):
			continue
		var F: String = PACT[h]
		# Pacte imposé (contrainte puis ambivalence), même sur la voie du Tyran : jamais d'intimité
		for amb in [-30, 10]:
			for side in ["set align.protect -25", "set align.protect 25"]:
				var sp := StateStore.new()
				sp.apply_effects(base + ["flag " + F, "set ambivalence.%s %d" % [h, amb], side])
				var seenp := _route(sp, dlg, h)
				check(not _intimate(dlg, seenp) and not sp.has_flag(nf), "Matrice : %s sous Pacte (ambivalence %d), sans intimité %s" % [h, amb, seenp])
		# Contrat renégocié : nuit consentie, puis moments ordinaires (seconde nuit), puis Dévotion possible
		var sr := StateStore.new()
		sr.apply_effects(base + ["flag " + F, "set ambivalence.%s 35" % h])
		var seenr := _route(sr, dlg, h)
		check(seenr.has(p + "_pacte_renegocie") and seenr.has(p + "_pacte_consentie") and sr.has_flag(nf), "Matrice : %s, contrat renégocié %s" % [h, seenr])
		sr.apply_effects(["set repos.%s 3" % h, "set align.protect 25"])
		var seenr2 := _route(sr, dlg, h)
		check(seenr2.size() > 1 and seenr2[1] == p + "_nuit2", "Matrice : %s, après le contrat renégocié → seconde nuit %s" % [h, seenr2])
		sr.apply_effects(["set ambivalence.%s 70" % h, "set aff.%s 75" % h])
		var seenr3 := _route(sr, dlg, h)
		check(seenr3.has(p + "_devotion") or seenr3.has(p + "_devotion_nuit"), "Matrice : %s, contrat renégocié → Dévotion %s" % [h, seenr3])
	# Tyran : la nuit d'Ombre ne se rejoue pas ; entre la première et la seconde nuit, un repos ordinaire
	for h in H:
		var p: String = PRE.get(h, h)
		var st := StateStore.new()
		st.apply_effects(["set repos.%s 1" % h, "flag refuge.dortoir", "set aff.%s 45" % h, "set align.protect -25"])
		_route(st, dlg, h)
		var gap := _route(st, dlg, h)
		check(gap.size() > 1 and gap[1] == p + "_court" and not _intimate(dlg, gap), "Matrice : %s, Tyran, repos suivant ordinaire %s" % [h, gap])
		st.apply_effects(["set repos.%s 3" % h])
		var again := _route(st, dlg, h)
		check(again.size() > 1 and again[1] == p + "_nuit2", "Matrice : %s, Tyran, seconde nuit (pas d'Ombre rejouée) %s" % [h, again])
	# Liens libres : une héroïne sous contrat imposé ne compte pas ; contrat renégocié ou Dévotion, si
	var sb := StateStore.new()
	for h in H:
		sb.apply_effects(["join " + h, "set aff.%s 70" % h])
	sb.apply_effects(["flag pacte.seo_yeon"])
	check(sb.bonds() == 10 and sb.bonds_libres() == 9 and sb.imposed_pact("seo_yeon"), "Liens libres : contrat imposé exclu")
	sb.apply_effects(["flag seo_pacte_accepte"])
	check(sb.bonds_libres() == 10 and not sb.imposed_pact("seo_yeon"), "Liens libres : contrat renégocié compté")
	# Finale : l'Aube des Dix (palier P3) exige dix liens libres ; sinon la Maison des Dix, sans la nuit
	var fin: Dictionary = all["act4_finale"]
	sb.apply_effects(["unflag seo_pacte_accepte", "set align.protect 25"])
	var hf := _route(sb, fin, "harem")
	check(hf.has("harem_maison") and not hf.has("aube_dix") and sb.has_flag("issue.maison_des_dix"), "Finale : Maison des Dix sans la nuit si un contrat est imposé %s" % [hf])
	sb.apply_effects(["flag seo_pacte_accepte"])
	hf = _route(sb, fin, "harem")
	check(hf.has("aube_dix") and _intimate(fin, hf), "Finale : Aube des Dix avec dix liens libres %s" % [hf])
	# Scènes à plusieurs : toutes accessibles sur au moins une voie ; jamais verrouillées par un Pacte imposé
	var gs: Array = DataDB.load_json("res://data/world/group_scenes.json")["scenes"]
	for g in gs:
		var ok := false
		var any_store = null
		for voie in ["set align.protect 25", "set align.protect -25", "set argent 450"]:
			var s := StateStore.new()
			s.set_time(25, 2)
			s.apply_effects(["set loop 2", "flag refuge.dortoir", "flag concil.reines", voie])
			for h in H:
				s.apply_effects(["join " + h, "set aff.%s 70" % h, "flag " + PRE.get(h, h) + "_nuit"])
			if s.check(str(g.get("if", ""))):
				ok = true
				any_store = s
				break
		check(ok, "Groupe : « %s » accessible" % g["id"])
		if not ok:
			continue
		var blk: String = str(g["dialogue"]).get_slice(":", 1)
		var pacted: Array = g.get("members", []).filter(func(m): return PACT.has(m))
		if g["id"] == "portrait_dix":
			any_store.apply_effects(["flag pacte.seo_yeon"])
			var seenpd := _route(any_store, grp, blk)
			check(any_store.check(str(g.get("if", ""))) and seenpd.has("portrait_dix_pacte") and not _intimate(grp, seenpd.slice(1)),
				"Groupe : Portrait des Dix avec une héroïne sous contrat imposé → portrait seul, sans la nuit %s" % [seenpd])
			any_store.apply_effects(["unflag pacte.seo_yeon"])
		elif pacted.is_empty() and g.get("members", []).is_empty() and _intimate(grp, [blk]):
			any_store.apply_effects(["flag pacte.seo_yeon"])
			check(any_store.check(str(g.get("if", ""))), "Groupe : « %s » reste accessible avec une héroïne sous Pacte" % g["id"])
			var r := DialogueRunner.new(any_store)
			r.start(grp, blk)
			var note := false
			for i in 40:
				var st := r.next()
				if st["kind"] == "line" and st["text"].begins_with("Celles qui portent encore un contrat"):
					note = true
				if st["kind"] == "end" or st["kind"] == "choice":
					break
			check(note, "Groupe : « %s », absence de l'héroïne sous contrat imposé mentionnée" % g["id"])
		for m in pacted:
			any_store.apply_effects(["flag " + PACT[m]])
			check(any_store.check(str(g.get("if", ""))), "Groupe : « %s » non verrouillée par le Pacte de %s" % [g["id"], m])
			var seen := _route(any_store, grp, blk)
			if _intimate(grp, [blk]):
				check(seen.size() > 1 and seen[1] == "pacte_groupe_" + m and not _intimate(grp, seen.slice(1)),
					"Groupe : « %s » avec %s sous contrat imposé → variante sans intimité %s" % [g["id"], m, seen])
			else:
				check(not _intimate(grp, seen), "Groupe : soirée « %s » jouable avec %s sous Pacte, sans intimité" % [g["id"], m])
			any_store.apply_effects(["unflag " + PACT[m]])

