extends Node
## Autoload : état global de la partie (boucle en cours + méta-progression).

const StateStore := preload("res://core/state_store.gd")

signal regressed(loop: int)

var store: StateStore = StateStore.new()
var day: int = 1
var phase: int = 0  ## 0 Aube · 1 Jour · 2 Crépuscule · 3 Nuit

const PHASE_NAMES := ["Aube", "Jour", "Crépuscule", "Nuit"]


func _ready() -> void:
	new_game()


func new_game() -> void:
	store = StateStore.new()
	store.set_var("loop", 1)
	day = 1
	phase = 0


func phase_name() -> String:
	return PHASE_NAMES[phase]


func advance_phase(count: int = 1) -> void:
	for i in count:
		phase += 1
		if phase > 3:
			phase = 0
			day += 1


## Régression : retour au J1. Les souvenirs et le compteur de boucle persistent (§4 du GDD).
func regress() -> void:
	var kept_souvenirs := store.souvenirs.duplicate()
	var loop := store.loop() + 1
	store = StateStore.new()
	store.souvenirs = kept_souvenirs
	store.set_var("loop", loop)
	day = 1
	phase = 0
	regressed.emit(loop)


## Composition du groupe : Elias + les héroïnes dont le drapeau "party.<id>" est posé.
func party_ids() -> Array:
	var ids := ["elias"]
	for id in DataDB.characters:
		if id != "elias" and store.has_flag("party." + id):
			ids.append(id)
	return ids


func rewrite_charges() -> int:
	## La Réécriture se débloque après la première régression (§10.6).
	return 1 if store.loop() >= 2 else 0
