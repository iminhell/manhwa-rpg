extends Control
## Tutoriel de combat pas à pas (premier combat de la première boucle). Il commence par un choix explicite :
## « Activer le tutoriel de combat » ou « Ignorer » (mémorisé dans Settings.combat_tutorial). Les étapes attendent
## l'action du joueur (choisir une compétence, une cible) ou un clic sur « Suivant » ; un cadre doré désigne
## l'élément concerné. La scène de combat attend la fin de l'introduction pour lancer le premier tour.

signal intro_done      ## le combat peut commencer
signal closed

const UI := preload("res://ui/ui_style.gd")

## [id, titre, texte, élément désigné ("timeline", "allies", "enemies", "skills", ""), attente ("next" ou un événement)]
const STEPS := [
	["frise", "La frise", "En haut, la FRISE montre l'ordre des prochains tours. La Vitesse décide qui agit, et dans quel ordre.", "timeline", "next"],
	["grilles", "Les deux grilles", "À gauche, ton groupe ; à droite, les ennemis. Chaque grille a trois rangées : avant, milieu, arrière. La mêlée ne touche que la rangée avant ennemie ; certaines compétences ne partent que de certaines rangées.", "enemies", "next"],
	["competence", "À toi : une compétence", "C'est le tour d'Elias. Clique sur une compétence, en bas. Le chiffre entre parenthèses est son coût en mana ; survole un bouton pour lire son effet.", "skills", "skill"],
	["cible", "Puis une cible", "Les cases dorées sont les cibles possibles. Clique sur l'une d'elles pour frapper.", "enemies", "action"],
	["pressentiment", "Le Pressentiment", "Les cases magenta montrent ce que l'ennemi prépare pour son prochain tour : le Registre te laisse lire ses intentions. Frappe avant, ou mets-toi hors de portée.", "enemies", "next"],
	["eveil", "Mana et Éveil", "Sur chaque carte : la barre bleue est le mana, la barre dorée l'Éveil. L'Éveil se remplit à chaque action ; plein, il libère la technique ultime (bouton doré). À partir de la deuxième boucle, la Réécriture rejoue ta dernière action une fois par combat.", "allies", "next"],
	["fin", "À toi de jouer", "Tu sais l'essentiel. Le Guide (menu pause) reprend tout cela, page « Combat ».", "", "next"],
]

var step := -1
var targets: Dictionary = {}   ## id d'élément → Control (fourni par la scène de combat)
var _shade: ColorRect
var _box: PanelContainer
var _title: Label
var _text: Label
var _next: Button
var _frame: ReferenceRect


func _ready() -> void:
	UI.full_rect(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame = ReferenceRect.new()
	_frame.editor_only = false
	_frame.border_color = UI.GOLD
	_frame.border_width = 4.0
	_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame.visible = false
	add_child(_frame)
	_shade = ColorRect.new()
	_shade.color = Color(0, 0, 0, 0.55)
	add_child(UI.full_rect(_shade))
	_box = PanelContainer.new()
	_box.name = "Tutoriel"
	_box.anchor_left = 0.27
	_box.anchor_right = 0.73
	_box.anchor_top = 0.555
	_box.anchor_bottom = 0.555
	_box.add_theme_stylebox_override("panel", UI.box(Color(0.05, 0.04, 0.02, 0.97), UI.GOLD, 3))
	add_child(_box)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	_box.add_child(v)
	_title = UI.label("", 26, UI.GOLD)
	v.add_child(_title)
	_text = UI.label("", 20)
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text.custom_minimum_size = Vector2(700, 0)
	v.add_child(_text)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_theme_constant_override("separation", 12)
	v.add_child(row)
	_next = UI.button("Suivant", 20, UI.GOLD)
	_next.name = "Suivant"
	_next.pressed.connect(advance)
	row.add_child(_next)
	_ask(row)


## Choix explicite avant toute explication.
func _ask(row: HBoxContainer) -> void:
	add_to_group("modal")
	_title.text = "Premier combat"
	_text.text = "Veux-tu un tutoriel pas à pas pour ce premier combat ? Tu pourras le revoir dans le Guide (menu pause)."
	_next.visible = false
	var yes := UI.button("Activer le tutoriel de combat", 20, UI.GOLD)
	yes.name = "Activer"
	var no := UI.button("Ignorer", 20)
	no.name = "Ignorer"
	row.add_child(yes)
	row.add_child(no)
	yes.pressed.connect(func():
		Settings.combat_tutorial = "on"
		Settings.save_settings()
		yes.queue_free()
		no.queue_free()
		_next.visible = true
		advance())
	no.pressed.connect(func():
		Settings.combat_tutorial = "off"
		Settings.save_settings()
		close())


func current_id() -> String:
	return STEPS[step][0] if step >= 0 and step < STEPS.size() else ""


func advance() -> void:
	step += 1
	if step >= STEPS.size():
		close()
		return
	var s: Array = STEPS[step]
	_title.text = "%s   (%d/%d)" % [s[1], step + 1, STEPS.size()]
	_text.text = s[2]
	var waits: bool = s[4] != "next"
	_next.visible = not waits
	_next.text = "Terminer" if step == STEPS.size() - 1 else "Suivant"
	# Pendant une étape qui attend une action, la scène reste cliquable : pas de voile, panneau en haut.
	_shade.visible = not waits
	_box.anchor_top = 0.10 if waits else 0.555
	_box.anchor_bottom = _box.anchor_top
	if waits:
		remove_from_group("modal")
	else:
		add_to_group("modal")
	if s[0] == "competence":
		intro_done.emit()


## Événements envoyés par la scène de combat : "skill" (compétence choisie), "action" (action jouée).
func notify(event: String) -> void:
	if step >= 0 and step < STEPS.size() and STEPS[step][4] == event:
		advance()
	elif event == "action" and current_id() == "competence":
		step += 1   # compétence sans cible (soin, garde) : on saute l'étape « cible »
		advance()


func close() -> void:
	if step < 3:
		intro_done.emit()
	remove_from_group("modal")
	closed.emit()
	queue_free()


func _process(_delta: float) -> void:
	var key: String = STEPS[step][3] if step >= 0 and step < STEPS.size() else ""
	var c: Control = targets.get(key, null)
	_frame.visible = c != null and is_instance_valid(c)
	if _frame.visible:
		var r := c.get_global_rect().grow(6)
		_frame.global_position = r.position
		_frame.size = r.size
		_frame.modulate.a = 0.6 + 0.4 * sin(Time.get_ticks_msec() / 200.0)
