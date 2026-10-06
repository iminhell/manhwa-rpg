extends RefCounted
## Format des sauvegardes (pur, sans autoload) — utilisé par SaveManager et par les tests.

const VERSION := 1


static func build_save(store, party: Array) -> Dictionary:
	return {
		"version": VERSION,
		"saved_at": Time.get_datetime_string_from_system(),
		"summary": {
			"day": store.day(), "phase": store.phase(), "loop": store.loop(),
			"node": str(store.get_var("pos.node", "")), "party": party, "money": store.money(),
		},
		"store": store.to_dict(),
	}
