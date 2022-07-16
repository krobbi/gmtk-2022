extends Control

onready var speech_bubble: Sprite = $textBox
onready var chip_sprites: Array = $Chips.get_children()
onready var credit_sprites: Array = $Score.get_children()


func _ready():
	display_credit(0)

func display_higher_lower(is_higher: bool) -> void:
	if is_higher:
		speech_bubble.texture = preload("res://resources/textures/speech_box_higher.png")
	else:
		speech_bubble.texture = preload("res://resources/textures/speech_box_lower.png")
	
	speech_bubble.show()


func display_chips(value: int) -> void:
	for i in range(3):
		chip_sprites[i].visible = i < value


func display_credit(value: int) -> void:
	var is_positive: bool = value >= 0
	var abs_value: int = int(abs(value))
	
	for i in range(15):
		if is_positive:
			credit_sprites[i].texture = preload("res://resources/textures/positive_coin.png")
		else:
			credit_sprites[i].texture = preload("res://resources/textures/negative_coin.png")
		
		credit_sprites[i].visible = i < abs_value


func _on_TextureButton_pressed():
	print("PENIS") # Replace with function body.
