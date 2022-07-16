class_name DieSpawer
extends YSort

signal roll_finished(die_positions)

const DieScene: PackedScene = preload("res://entities/die/die.tscn")

var dice: Array = []

# Dodgy check for finished roll:
func _physics_process(_delta: float) -> void:
	if dice.empty():
		set_physics_process(false)
	
	for die in dice:
		if not die.is_stopped():
			return
	
	var positions: Array = []
	
	for die in dice:
		positions.push_back(die.position)
		die.unspawn()
	
	dice.clear()
	emit_signal("roll_finished", positions)


# Spawns dice:
func spawn_dice() -> void:
	for i in range(4):
		var die: Die = DieScene.instance()
		dice.push_back(die)
		die.position = Vector2(480.0 + float(i * 320), 540.0)
		add_child(die)
		die.spawn()
	
	set_physics_process(true)
