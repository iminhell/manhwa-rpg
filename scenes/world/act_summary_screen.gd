extends Control
## Écran de fin d'acte : conséquences (data/world/act_summary.json), alignement, Fins.

signal closed
signal regress_requested

const UI := preload("res://ui/ui_style.gd")


const TITLES := {1: "ÉVEIL", 2: "CONSOLIDATION", 3: "LA GUERRE DES SCEAUX", 4: "LA GRANDE DESCENTE"}


func setup(act: int, can_continue: bool = false) -> void:
	UI.full_rect(self)
	var bg := ColorRect.new()
	bg.color = Color(0.02, 0.02, 0.04)
	add_child(UI.full_rect(bg))
	var v := VBoxContainer.new()
	UI.full_rect(v)
	v.offset_left = 160
	v.offset_right = -160
	v.offset_top = 60
	v.offset_bottom = -60
	v.add_theme_constant_override("separation", 10)
	add_child(v)
	v.add_child(UI.label("FIN DE L'ACTE %d — %s" % [act, TITLES.get(act, "")], 48, UI.GOLD))
	var st = GameState.store
	v.add_child(UI.label("Boucle %d · Jour %d · Pression %d · Protéger/Dominer %+d · Lien/Solitude %+d · Groupe : %s" % [
		st.loop(), st.day(), int(st.pressure()), int(st.get_var("align.protect")), int(st.get_var("align.bond")),
		", ".join(GameState.party_ids().map(func(id): return DataDB.display_name(id)))], 20, UI.CYAN))
	var text := RichTextLabel.new()
	text.bbcode_enabled = true
	text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text.add_theme_font_size_override("normal_font_size", 20)
	v.add_child(text)
	for line in DataDB.act_summary.get("act%d" % act, []):
		if st.check(str(line.get("if", ""))):
			text.append_text("• %s\n" % line["text"])
	if not can_continue:
		# Fin de boucle : régresser en gardant les Échos (ce qu'Elias a accompli), ou revenir au titre.
		var echoes := UI.label("Échos gravés pour la prochaine boucle : %d" % GameState.Echoes.after_loop(st, DataDB.echoes).size(), 20, UI.CYAN)
		v.add_child(echoes)
		var r := UI.button("Régresser — boucle %d (Échos et souvenirs conservés)" % (st.loop() + 1), 26, UI.GOLD)
		r.pressed.connect(func(): regress_requested.emit())
		v.add_child(r)
	var b := UI.button("Continuer vers l'Acte %d" % (act + 1) if can_continue else "Retour au titre", 26)
	b.pressed.connect(func(): closed.emit())
	v.add_child(b)
