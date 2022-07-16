extends Node

signal number_changed(number)
signal round_finished(was_won)

export(NodePath) var die_spawner_path: NodePath = NodePath()
export(NodePath) var floating_number_spawner_path: NodePath = NodePath()
export(NodePath) var mana_bar_path: NodePath = NodePath()
export(NodePath) var odds_selector_path: NodePath = NodePath()

var number: int = 14
var mana: int = 15
var odds: int = 14
var is_expecting_higher: bool = false

onready var die_spawner: DieSpawer = get_node(die_spawner_path)
onready var floating_number_spawner: FloatingNumberSpawner = get_node(floating_number_spawner_path)
onready var mana_bar: Control = get_node(mana_bar_path)
onready var odds_selector: Control = get_node(odds_selector_path)

func _ready() -> void:
	var error: int = floating_number_spawner.connect("number_rolled", self, "_on_number_rolled")
	
	if error and floating_number_spawner.is_connected("number_rolled", self, "_on_number_rolled"):
		floating_number_spawner.disconnect("number_rolled", self, "_on_number_rolled")
	
	error = odds_selector.connect("odds_selected", self, "_on_odds_selected")
	
	if error and odds_selector.is_connected("odds_selected", self, "_on_odds_selected"):
		odds_selector.disconnect("odds_selected", self, "_on_odds_selected")
	
	error = odds_selector.connect("odds_hovered", self, "_on_odds_hovered")
	
	if error and odds_selector.is_connected("odds_hovered", self, "_on_odds_hovered"):
		odds_selector.disconnect("odds_hovered", self, "_on_odds_hovered")


# Gets the AI's choice of higher or lower:
func get_ai_choice() -> bool:
	randomize()
	return bool(randi() % 2)


# Begins a new game of higher or lower:
func begin_game() -> void:
	mana = 20
	mana_bar.changeMana(mana)
	number = 14
	
	emit_signal("number_changed", number)
	begin_round()


# Runs when the round begins:
func begin_round() -> void:
	is_expecting_higher = get_ai_choice()
	odds = 14
	odds_selector.set_number(odds)
	odds_selector.min_value = odds - mana
	odds_selector.max_value = odds + mana
	select_odds()


# Let the player select the odds:
func select_odds() -> void:
	odds_selector.set_process_input(true)


func _on_odds_hovered(new_odds: int) -> void:
	var cost: int = int(abs(new_odds - odds))
	mana_bar.highlight_cost(cost)


# Runs when the player selects odds:
func _on_odds_selected(new_odds: int) -> void:
	var cost: int = int(abs(new_odds - odds))
	odds = new_odds
	mana -= cost
	mana_bar.changeMana(mana)
	mana_bar.unhighlight_cost()
	floating_number_spawner.odds = odds
	print("Selected odds of %d" % new_odds)
	die_spawner.spawn_dice()


# Runs when a numnber is finished rolling:
func _on_number_rolled(new_number: int) -> void:
	if new_number == number:
		die_spawner.spawn_dice() # Reroll:
		return
	
	var was_higher: bool = new_number > number
	number = new_number
	emit_signal("number_changed", number)
	
	if is_expecting_higher == was_higher:
		emit_signal("round_finished", true)
	else:
		emit_signal("round_finished", false)
