extends RefCounted
## Moteur de dialogue JSON (logique pure, sans UI).
##
## Format d'un fichier data/dialogues/*.json :
## {
##   "id": "prologue_j1", "start": "start",
##   "blocks": { "start": [ <étape>, ... ], "autre_bloc": [ ... ] }
## }
## Étapes :
##   {"s": "elias", "t": "Texte", "e": "anger"}        réplique (s = locuteur, e = expression)
##   {"s": "system", "t": "..."}                         fenêtre du Système ; "narrator" = narration
##   {"bg": "itaewon_street"}                            change le décor
##   {"cg": "cg_prologue_death"} / {"cg": ""}            affiche / masque une CG
##   {"fx": ["add align.protect 2", "flag x"]}           effets sur l'état
##   {"if": "loop() > 1", "then": "bloc", "else": "bloc"} saut conditionnel (else optionnel)
##   {"goto": "bloc"}
##   {"choice": [{"t": "...", "goto": "bloc", "fx": [...], "if": "cond"}]}
##   {"event": "combat", "args": {"encounter": "..."}}   met en pause, l'hôte appelle resume()
##   {"phase": 1}                                        avance le temps d'une phase
##   {"time": "2:1"}                                     place l'horloge sur J2, phase 1 (jamais en arrière)
##   {"music": "intimate"}                               change le contexte musical (data/audio/music.json)
##   {"text_p3_slot": [<réplique>, ...]}                  passage P3 (explicite) rédigé par l'auteur, joué sur place ;
##                                                        ignoré s'il est vide ou si le joueur masque le P3 (show_p3)
##   "v": true sur une réplique                           réplique doublée (voix IA)
##   {"end": true}
## Chaque réplique reçoit un identifiant stable "dialogue:bloc:index" (clé des voix IA).

const MAX_STEPS := 10000

var dialogue: Dictionary = {}
var store  ## StateStore (ou tout objet exposant apply_effects / check)
var block: String = ""
var index: int = 0
var finished: bool = false
var show_p3: bool = true  ## faux : les passages text_p3_slot sont sautés (préférence Settings.hide_pacte_p3)
var on_enter: Callable     ## appelé avec « dialogue:bloc » à l'entrée de chaque bloc (déblocage de la galerie)
var _pending_choices: Array = []
var _slot: Array = []      ## répliques restantes du passage P3 en cours
var _slot_id: String = ""


func _init(state_store = null) -> void:
	store = state_store


func start(dlg: Dictionary, start_block: String = "") -> void:
	dialogue = dlg
	block = start_block if start_block != "" else str(dlg.get("start", "start"))
	index = 0
	finished = false
	_pending_choices = []
	_slot = []
	_entered()


## Avance jusqu'à la prochaine étape « présentable » et la renvoie :
##   {"kind": "line", "speaker", "text", "expr", "id"}
##   {"kind": "choice", "options": [{"text", "index"}]}
##   {"kind": "bg", "id"} · {"kind": "cg", "id"} · {"kind": "phase", "count"}
##   {"kind": "time", "day", "phase"} · {"kind": "music", "context"}
##   {"kind": "event", "name", "args"} · {"kind": "end"}
func next() -> Dictionary:
	if finished:
		return {"kind": "end"}
	if not _pending_choices.is_empty():
		return _choice_view()
	while not _slot.is_empty():
		var k: int = int(_slot[0][0])
		var line: Dictionary = _slot.pop_front()[1]
		if line.has("t"):
			return {"kind": "line", "speaker": str(line.get("s", "narrator")), "text": str(line["t"]),
					"expr": str(line.get("e", "neutral")), "id": "%s:p3:%d" % [_slot_id, k], "voiced": false}
	for _guard in MAX_STEPS:
		var steps: Array = dialogue.get("blocks", {}).get(block, [])
		if index >= steps.size():
			finished = true
			return {"kind": "end"}
		var step: Dictionary = steps[index]
		var step_id := "%s:%s:%d" % [dialogue.get("id", "?"), block, index]
		index += 1
		if step.has("t"):
			return {"kind": "line", "speaker": str(step.get("s", "narrator")), "text": str(step["t"]),
					"expr": str(step.get("e", "neutral")), "id": step_id, "voiced": bool(step.get("v", false))}
		if step.has("fx"):
			store.apply_effects(step["fx"])
			continue
		if step.has("if"):
			var target: String = step.get("then", "") if store.check(str(step["if"])) else step.get("else", "")
			if target != "":
				_jump(target)
			continue
		if step.has("goto"):
			_jump(str(step["goto"]))
			continue
		if step.has("choice"):
			_pending_choices = []
			for i in step["choice"].size():
				var opt: Dictionary = step["choice"][i]
				if store.check(str(opt.get("if", ""))):
					_pending_choices.append({"opt": opt, "index": i})
			if _pending_choices.is_empty():
				continue
			return _choice_view()
		if step.has("bg"):
			return {"kind": "bg", "id": str(step["bg"])}
		if step.has("cg"):
			return {"kind": "cg", "id": str(step["cg"])}
		if step.has("phase"):
			return {"kind": "phase", "count": int(step["phase"])}
		if step.has("time"):
			var dp := str(step["time"]).split(":")
			return {"kind": "time", "day": int(dp[0]), "phase": int(dp[1])}
		if step.has("music"):
			return {"kind": "music", "context": str(step["music"])}
		if step.has("text_p3_slot"):
			var lines: Array = step["text_p3_slot"]
			if show_p3 and not lines.is_empty():
				_slot_id = step_id
				_slot = []
				for k in lines.size():
					_slot.append([k, lines[k]])
				return next()
			continue
		if step.has("event"):
			return {"kind": "event", "name": str(step["event"]), "args": step.get("args", {})}
		if step.has("end"):
			finished = true
			return {"kind": "end"}
		push_warning("Étape ignorée %s : %s" % [step_id, step])
	push_error("Boucle infinie probable dans le dialogue %s" % dialogue.get("id", "?"))
	finished = true
	return {"kind": "end"}


## Sélectionne l'option n (position dans la liste visible renvoyée par next()).
func choose(visible_index: int) -> void:
	if visible_index < 0 or visible_index >= _pending_choices.size():
		push_error("Choix hors limites : %d" % visible_index)
		return
	var opt: Dictionary = _pending_choices[visible_index]["opt"]
	_pending_choices = []
	store.apply_effects(opt.get("fx", []))
	if opt.has("goto"):
		_jump(str(opt["goto"]))


func is_waiting_choice() -> bool:
	return not _pending_choices.is_empty()


func _choice_view() -> Dictionary:
	var options := []
	for i in _pending_choices.size():
		options.append({"text": str(_pending_choices[i]["opt"].get("t", "…")), "index": i})
	return {"kind": "choice", "options": options}


func _jump(target: String) -> void:
	if not dialogue.get("blocks", {}).has(target):
		push_error("Bloc inconnu « %s » dans %s" % [target, dialogue.get("id", "?")])
		finished = true
		return
	block = target
	index = 0
	_entered()


func _entered() -> void:
	if on_enter.is_valid():
		on_enter.call("%s:%s" % [dialogue.get("id", "?"), block])


## Vérifie la cohérence d'un dialogue (blocs cibles existants). Renvoie la liste des erreurs.
static func validate(dlg: Dictionary) -> Array:
	var errors := []
	var blocks: Dictionary = dlg.get("blocks", {})
	if not blocks.has(str(dlg.get("start", "start"))):
		errors.append("bloc de départ absent")
	for b in blocks:
		for step in blocks[b]:
			var targets := []
			if step.has("goto"): targets.append(step["goto"])
			if step.has("then"): targets.append(step["then"])
			if step.has("else"): targets.append(step["else"])
			for opt in step.get("choice", []):
				if opt.has("goto"): targets.append(opt["goto"])
			for t in targets:
				if not blocks.has(t):
					errors.append("%s → bloc inconnu « %s »" % [b, t])
	return errors
