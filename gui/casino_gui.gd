extends Control

onready var player_count_sprites: Array = $player_count.get_children()

func display_player_count(value: int) -> void:
	for i in range(player_count_sprites.size()):
		player_count_sprites[i].visible = i < value
