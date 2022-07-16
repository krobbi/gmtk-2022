extends Node2D

func _ready() -> void:
	$GameManager.begin_game()


func _on_game_manager_round_finished(_was_won: bool) -> void:
	$GameManager.begin_round()
