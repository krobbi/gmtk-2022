extends Control

func _ready() -> void:
	GameData.load_settings()
	$Timer.start()


func _on_timer_timeout() -> void:
	# warning-ignore: RETURN_VALUE_DISCARDED
	get_tree().change_scene("res://scenes/title_screen/title_screen.tscn")
