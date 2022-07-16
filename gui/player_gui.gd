extends Control

onready var speech_bubble: Sprite = $textBox

func display_higher_lower(is_higher: bool) -> void:
	if is_higher:
		speech_bubble.texture = preload("res://resources/textures/speech_box_higher.png")
	else:
		speech_bubble.texture = preload("res://resources/textures/speech_box_lower.png")
	
	speech_bubble.show()
