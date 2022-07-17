extends Node


func _ready() -> void:
	if $back:
		$back.grab_focus()


func _on_back_pressed():
	get_tree().change_scene("res://scenes/title_screen/title_screen.tscn") # Replace with function body.
