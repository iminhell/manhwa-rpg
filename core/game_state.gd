extends Node
## Autoload : état global de la partie (boucle en cours + méta-progression).

const StateStore := preload("res://core/state_store.gd")
const WorldModel := preload("res://world/world_model.gd")
const Echoes := preload("res://core/echoes.gd")

signal regressed(loop: int)

var store: StateStore = StateStore.new()
var world: WorldModel
## Point de reprise : l'état juste avant que la carte lance une scène (action, Ancre, combat). Une sauvegarde faite
## pendant un dialogue ou un combat enregistre ce point : au chargement, on revient sur la carte juste avant la scène.
## Vide pendant le prologue (aucune sauvegarde possible avant d'arriver sur la carte).
var checkpoint: Dictionary = {}

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


func new_game(mode: String = "") -> void:
	checkpoint = {}
	store = StateStore.new()
	store.set_var("loop", 1)
	store.set_var("difficulte", mode if mode != "" else str(DataDB.difficulty.get("default", "normal")))
	_build_world()


func difficulty() -> Dictionary:
	return DataDB.difficulty.get("modes", {}).get(store.mode(), {})


## Restaure une sauvegarde (contenu de StateStore.to_dict()).
func load_store(data: Dictionary) -> void:
	checkpoint = {}
	store = StateStore.new()
	store.from_dict(data)
	_build_world()
	world.refresh()


func _build_world() -> void:
	store.resilience = DataDB.resilience
	world = WorldModel.new(store, DataDB.world, DataDB.events, DataDB.refuge, difficulty(), DataDB.gifts, DataDB.group_scenes)


func phase_name() -> String:
	return PHASE_NAMES[phase]


func advance_phase(count: int = 1) -> void:
	store.advance_ticks(count * StateStore.TICKS_PER_PHASE - store.ticks() % StateStore.TICKS_PER_PHASE)


## Régression : retour au J1. Persistent : les souvenirs, le compteur de boucle, le mode de difficulté,
## et les Échos (data/world/echoes.json) — ce qu'Elias a accompli dans les boucles précédentes.
func regress() -> void:
	checkpoint = {}
	var kept_souvenirs := store.souvenirs.duplicate()
	var loop := store.loop() + 1
	var kept_echoes := Echoes.after_loop(store, DataDB.echoes)
	var mode := store.mode()
	store = StateStore.new()
	store.souvenirs = kept_souvenirs
	store.set_var("loop", loop)
	store.set_var("difficulte", mode)
	for e in kept_echoes:
		store.set_flag(e)
	_build_world()
	regressed.emit(loop)


## Composition du groupe : Elias + les héroïnes dont le drapeau "party.<id>" est posé.
func party_ids(from = null) -> Array:
	var st = from if from != null else store
	var ids := ["elias"]
	for id in DataDB.characters:
		if id != "elias" and st.has_flag("party." + id):
			ids.append(id)
	return ids


## Mémorise le point de reprise (appelé par la carte juste avant une action ou une Ancre qui lance une scène).
func mark_checkpoint(snapshot: Dictionary) -> void:
	checkpoint = snapshot


## État à enregistrer maintenant : l'état courant sur la carte, sinon le point de reprise (pendant une scène).
## null pendant le prologue.
func saveable_store(on_map: bool):
	if on_map:
		return store
	if checkpoint.is_empty():
		return null
	var s := StateStore.new()
	s.from_dict(checkpoint)
	return s


## Escouade de combat : Elias + les 5 héroïnes les plus liées (la grille 3×3 ne tient pas 11 personnes).
const SQUAD_MAX := 6

func squad(ids: Array) -> Array:
	if ids.size() <= SQUAD_MAX:
		return ids
	var others := ids.filter(func(id): return id != "elias")
	others.sort_custom(func(a, b): return store.aff(a) > store.aff(b))
	return ["elias"] + others.slice(0, SQUAD_MAX - 1)


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
