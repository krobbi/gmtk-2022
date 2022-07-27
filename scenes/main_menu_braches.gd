extends Node


func _ready() -> void:
	if has_node("back"):
		get_node("back").grab_focus()


func _on_back_pressed():
	# warning-ignore: RETURN_VALUE_DISCARDED
	get_tree().change_scene("res://scenes/title_screen/title_screen.tscn")
