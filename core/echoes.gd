extends RefCounted
## Échos inter-boucles (pur, testable) : ce qu'Elias a accompli et qui survit à la régression.
## Définitions : data/world/echoes.json → {"<id>": {"if": "<condition>", "text": "…"}} ; drapeaux « echo.<id> ».


## Échos gravés à la fin d'une boucle : ceux déjà acquis, plus ceux dont la condition est vraie.
static func after_loop(old_store, echo_defs: Dictionary) -> Array:
	var out := []
	for f in old_store.flags.keys():
		if str(f).begins_with("echo.") and old_store.has_flag(f):
			out.append(str(f))
	for id in echo_defs:
		var key := "echo." + str(id)
		if not out.has(key) and old_store.check(str(echo_defs[id].get("if", "false"))):
			out.append(key)
	return out
