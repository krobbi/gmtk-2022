class_name DieSpawer
extends YSort

const DieScene: PackedScene = preload("res://entities/die/die.tscn")

# Spawns dice:
func spawn_dice() -> void:
	for i in range(4):
		var die: Die = DieScene.instance()
		die.position = Vector2(480.0 + float(i * 320), 540.0)
		add_child(die)
		die.roll()
