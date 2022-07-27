extends Node2D

func _ready() -> void:
	$Button.grab_focus()


func _on_Button_pressed() -> void:
	GameData.reset()
	# warning-ignore: RETURN_VALUE_DISCARDED
	get_tree().change_scene("res://scenes/night_transition/night_transition.tscn")
