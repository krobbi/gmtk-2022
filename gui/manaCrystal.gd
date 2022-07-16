extends Control

const ON_TEXTURE: Texture = preload("res://resources/textures/mana-full.png")
const OFF_TEXTURE: Texture = preload("res://resources/textures/mana-empty.png")

export(bool) var enabled: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
		if enabled:
			$Sprite.texture = ON_TEXTURE
		else:
			$Sprite.texture = OFF_TEXTURE
			
func enable():
	enabled = true
	$Sprite.texture = ON_TEXTURE
	
func disable():
	enabled = false
	$Sprite.texture = OFF_TEXTURE


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
