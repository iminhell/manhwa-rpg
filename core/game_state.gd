extends Node
## Autoload : état global de la partie (boucle en cours + méta-progression).

const StateStore := preload("res://core/state_store.gd")
const WorldModel := preload("res://world/world_model.gd")

signal regressed(loop: int)

var store: StateStore = StateStore.new()
var world: WorldModel

## 0 Aube · 1 Jour · 2 Crépuscule · 3 Nuit — le temps vit dans le store (sérialisable, testable)
var day: int:
	get:
		return store.day()
var phase: int:
	get:
		return store.phase()

const PHASE_NAMES := ["Aube", "Jour", "Crépuscule", "Nuit"]


func _ready() -> void:
	new_game()


func new_game() -> void:
	store = StateStore.new()
	store.set_var("loop", 1)
	_build_world()


## Restaure une sauvegarde (contenu de StateStore.to_dict()).
func load_store(data: Dictionary) -> void:
	store = StateStore.new()
	store.from_dict(data)
	_build_world()
	world.refresh()


func _build_world() -> void:
	world = WorldModel.new(store, DataDB.world, DataDB.events, DataDB.refuge)


func phase_name() -> String:
	return PHASE_NAMES[phase]


func advance_phase(count: int = 1) -> void:
	store.advance_ticks(count * StateStore.TICKS_PER_PHASE - store.ticks() % StateStore.TICKS_PER_PHASE)


## Régression : retour au J1. Les souvenirs et le compteur de boucle persistent (§4 du GDD).
func regress() -> void:
	var kept_souvenirs := store.souvenirs.duplicate()
	var loop := store.loop() + 1
	store = StateStore.new()
	store.souvenirs = kept_souvenirs
	store.set_var("loop", loop)
	_build_world()
	regressed.emit(loop)


## Composition du groupe : Elias + les héroïnes dont le drapeau "party.<id>" est posé.
func party_ids() -> Array:
	var ids := ["elias"]
	for id in DataDB.characters:
		if id != "elias" and store.has_flag("party." + id):
			ids.append(id)
	return ids


## Modificateur de combat lié à la Fatigue (§3.1) : 5e phase éveillé −15 %, 6e −30 %.
func fatigue_modifier() -> float:
	var f := int(store.get_var("fatigue", 0))
	if f >= 6 * StateStore.TICKS_PER_PHASE:
		return 0.7
	if f >= 5 * StateStore.TICKS_PER_PHASE:
		return 0.85
	return 1.0


func rewrite_charges() -> int:
	## La Réécriture se débloque après la première régression (§10.6).
	return 1 if store.loop() >= 2 else 0
