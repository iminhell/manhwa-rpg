extends HBoxContainer
## Barre d'actions de la boîte de dialogue : Sauver, Charger, Auto, Passer, Masquer, Journal, Menu.
## Raccourcis (gérés par la scène de dialogue) : A auto, Tab passer, H masquer, L journal, Échap menu.

signal action(name: String)

const UI := preload("res://ui/ui_style.gd")
const ENTRIES := [
	["save", "Sauver", "Sauvegarder (reprise sur la carte, juste avant cette scène)"],
	["load", "Charger", "Charger une partie"],
	["auto", "Auto", "Lecture automatique (A)"],
	["skip", "Passer", "Avancer rapidement jusqu'au prochain choix (Tab)"],
	["hide", "Masquer", "Masquer l'interface (H, ou clic pour la réafficher)"],
	["log", "Journal", "Historique des répliques (L)"],
	["menu", "Menu", "Menu (Échap)"],
]

var _buttons: Dictionary = {}


func _ready() -> void:
	alignment = BoxContainer.ALIGNMENT_END
	add_theme_constant_override("separation", 6)
	for e in ENTRIES:
		var b := UI.button(e[1], 17, UI.GOLD if e[0] in ["auto", "skip"] else UI.CYAN)
		b.tooltip_text = e[2]
		b.custom_minimum_size = Vector2(92, 34)
		b.focus_mode = Control.FOCUS_NONE
		b.toggle_mode = e[0] in ["auto", "skip"]
		b.pressed.connect(func(): action.emit(e[0]))
		add_child(b)
		_buttons[e[0]] = b


## Reflète l'état des modes Auto et Passer, et la possibilité de sauvegarder.
func set_state(auto_on: bool, skip_on: bool, can_save: bool) -> void:
	_buttons["auto"].set_pressed_no_signal(auto_on)
	_buttons["skip"].set_pressed_no_signal(skip_on)
	_buttons["save"].disabled = not can_save
	_buttons["save"].tooltip_text = ENTRIES[0][2] if can_save else "Sauvegarde possible une fois arrivé sur la carte"


func button(name: String) -> Button:
	return _buttons.get(name)
