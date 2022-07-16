extends Node2D

func _ready() -> void:
	$GameManager.begin_game()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		print("You chose lower!")
		$GameManager.begin_round(false)
	elif Input.is_action_just_pressed("ui_right"):
		print("You chose higher!")
		$GameManager.begin_round(true)


func _on_game_manager_round_finished(was_won: bool) -> void:
	if was_won:
		print("You won!")
	else:
		print("You lost!")
