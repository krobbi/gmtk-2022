extends Node

signal number_changed(number)
signal round_finished(was_won)

export(NodePath) var die_spawner_path: NodePath = NodePath()
export(NodePath) var floating_number_spawner_path: NodePath = NodePath()

var number: int = 14
var is_expecting_higher: bool = false

onready var die_spawner: DieSpawer = get_node(die_spawner_path)
onready var floating_number_spawner: FloatingNumberSpawner = get_node(floating_number_spawner_path)

func _ready() -> void:
	var error: int = floating_number_spawner.connect("number_rolled", self, "_on_number_rolled")
	
	if error and floating_number_spawner.is_connected("number_rolled", self, "_on_number_rolled"):
		floating_number_spawner.disconnect("number_rolled", self, "_on_number_rolled")


# Begins a new game of higher or lower:
func begin_game() -> void:
	number = 14
	emit_signal("number_changed", number)


# Runs when higher or lower is decided:
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
