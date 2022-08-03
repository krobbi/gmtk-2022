extends Control

var has_returned: bool = false

func _ready() -> void:
	$BackButton.grab_focus()


func _on_back_button_pressed() -> void:
	if has_returned:
		return
	
	has_returned = true
	GameData.save_settings()
	# warning-ignore: RETURN_VALUE_DISCARDED
	get_tree().change_scene("res://scenes/title_screen/title_screen.tscn")
