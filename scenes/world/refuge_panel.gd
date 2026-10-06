extends PanelContainer
## Gestion du Refuge : stock de rations, améliorations, atelier.

signal time_spent(ticks: int)
signal closed

const UI := preload("res://ui/ui_style.gd")

var refuge  ## RefugeModel
var _body: VBoxContainer


func _ready() -> void:
	anchor_left = 0.18
	anchor_right = 0.82
	anchor_top = 0.08
	anchor_bottom = 0.92
	add_theme_stylebox_override("panel", UI.box(Color(0.03, 0.07, 0.05, 0.98), Color("#5bd18b"), 3))
	var v := VBoxContainer.new()
	add_child(v)
	var head := HBoxContainer.new()
	v.add_child(head)
	var t := UI.label("LE REFUGE", 30, Color("#5bd18b"))
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(t)
	var close := UI.button("Fermer", 20)
	close.pressed.connect(func(): closed.emit())
	head.add_child(close)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(scroll)
	_body = VBoxContainer.new()
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.add_theme_constant_override("separation", 8)
	scroll.add_child(_body)
	refresh()


func refresh() -> void:
	for c in _body.get_children():
		c.queue_free()
	var st = GameState.store
	var info: Dictionary = refuge.type_info()
	_body.add_child(UI.label("%s — %s" % [info.get("name", "Refuge"), GameState.world.node(refuge.node_id()).get("name", "")], 24, UI.TEXT))
	var d := UI.label(info.get("desc", ""), 16, UI.DIM)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body.add_child(d)
	_body.add_child(UI.label("Stock : %d rations · Sur toi : %d · Résidents : %d (besoin : %d/jour) · Argent : %d%s" % [
		refuge.rations(), st.item("ration"), refuge.residents(), refuge.daily_need(), st.money(),
		"   ⚠ FAIM" if int(st.get_var("refuge.faim", 0)) > 0 else ""], 18, UI.GOLD))
	var row := HBoxContainer.new()
	_body.add_child(row)
	var dep := UI.button("Déposer toutes mes rations", 18)
	dep.disabled = st.item("ration") == 0
	dep.pressed.connect(_deposit)
	row.add_child(dep)
	var wd := UI.button("Prendre 2 rations", 18)
	wd.disabled = refuge.rations() == 0
	wd.pressed.connect(_withdraw)
	row.add_child(wd)
	if refuge.has("atelier"):
		var sell := UI.button("Atelier : vendre les fragments de strate", 18, UI.GOLD)
		sell.disabled = st.item("fragment_strate") == 0
		sell.pressed.connect(_sell)
		row.add_child(sell)
	_body.add_child(UI.label("Améliorations", 22, Color("#5bd18b")))
	for id in refuge.data.get("upgrades", {}):
		var u: Dictionary = refuge.data["upgrades"][id]
		var cost: Dictionary = u.get("cost", {})
		var price := "%d ¥" % int(cost.get("argent", 0))
		if int(cost.get("ration", 0)) > 0:
			price += " + %d rations" % int(cost["ration"])
		var label := "%s%s — %s   [%s · %d/4 ph.]" % ["✔ " if refuge.has(id) else "", u["name"], u["desc"], price, int(u.get("ticks", 4))]
		var b := UI.button(label, 16, Color("#5bd18b"))
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.disabled = not refuge.can_build(id)
		b.pressed.connect(_build.bind(id))
		_body.add_child(b)


func _build(id: String) -> void:
	var ticks: int = refuge.build(id)
	if ticks > 0:
		time_spent.emit(ticks)
	refresh()


func _deposit() -> void:
	refuge.deposit(99)
	refresh()


func _withdraw() -> void:
	refuge.withdraw(2)
	refresh()


func _sell() -> void:
	refuge.sell_fragments()
	refresh()
