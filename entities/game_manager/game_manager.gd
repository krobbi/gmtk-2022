extends Node

signal odds_selected
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


# Begins a new game of higher or lower:
func begin_game() -> void:
	mana = 20
	mana_bar.changeMana(mana)
	number = 14
	
	emit_signal("number_changed", number)


# Let the player select the odds:
func select_odds() -> void:
	odds_selector.set_process_input(true)


# Runs when higher or lower is decided by the opponent:
func begin_round(is_higher: bool) -> void:
	is_expecting_higher = is_higher
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
