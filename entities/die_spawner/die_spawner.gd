class_name DieSpawer
extends YSort

signal roll_finished(die_positions)

const DieScene: PackedScene = preload("res://entities/die/die.tscn")

var dice: Array = []

onready var spawn_player: AudioStreamPlayer = $SpawnPlayer
onready var despawn_player: AudioStreamPlayer = $DespawnPlayer

# Dodgy check for finished roll:
func _physics_process(_delta: float) -> void:
	if dice.empty():
		set_physics_process(false)
		return
	
	for die in dice:
		if not die.is_stopped():
			return
	
	despawn_player.play()
	var positions: Array = []
	
	for die in dice:
		positions.push_back(die.position)
		die.despawn()
	
	dice.clear()
	emit_signal("roll_finished", positions)


# Spawns dice:
func spawn_dice(is_fast: bool = false) -> void:
	for i in range(4):
		var die: Die = DieScene.instance()
		dice.push_back(die)
		die.position = Vector2(480.0 + float(i * 320), 800.0)
		add_child(die)
	
	if is_fast:
		for die in dice:
			die.state = Die.State.ROLLING
	else:
		for die in dice:
			die.spawn()
		
		spawn_player.play()
	
	set_physics_process(true)
