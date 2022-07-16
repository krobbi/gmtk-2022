class_name FloatingNumber
extends Node2D

signal despawned(number)

const TEXTURE: Texture = preload("res://resources/textures/numbers.png")

export(int) var number: int = 0 setget set_number

var sprites: Array = []

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var area: Area2D = $Area

func _ready() -> void:
	if number > 0:
		set_number(number)


func set_number(value: int) -> void:
	number = value
	
	for sprite in sprites:
		sprite.queue_free()
	
	sprites.clear()
	
	var string: String = String(value)
	var length: int = string.length()
	var offset: float = (length - 1) * -100.0
	
	for i in range(length):
		var sprite: Sprite = Sprite.new()
		sprite.texture = TEXTURE
		sprite.hframes = 10
		sprite.frame = int(string[i])
		sprite.position.x = offset + i * 200.0
		sprite.scale = Vector2(0.8, 0.8)
		sprites.push_back(sprite)
		add_child(sprite)
	
	animation_player.play("floop")


func get_ease(to: Vector2, weight: float) -> bool:
	position = position.linear_interpolate(to, weight)
	return position.distance_to(to) < 10.0


func despawn() -> void:
	$Area/CollisionShape.set_deferred("disabled", true)
	yield(get_tree().create_timer(1.0), "timeout")
	animation_player.play_backwards("floop")
	yield(animation_player, "animation_finished")
	queue_free()
	emit_signal("despawned", number)
