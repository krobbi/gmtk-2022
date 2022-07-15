class_name Die
extends KinematicBody2D

const PERSPECTIVE_SCALE: float = 0.003
const BOUNCE_FRICTION: float = 0.8
const AIR_FRICTION: float = 300.0
const ENERGY_TRANSFER: float = 0.3

export(float) var gravity: float = 20.0
export(float) var bounciness: float = 0.7

var height: float = 0.0
var v_velocity: float = 0.0
var velocity: Vector2 = Vector2.ZERO

onready var sprite: Sprite = $Sprite

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		v_velocity = rand_range(10.0, 12.0)
		var angle: float = rand_range(0.0, TAU)
		velocity = Vector2(cos(angle), sin(angle)) * rand_range(2500.0, 3000.0)
		update_frame()
		update_height()


func _physics_process(delta: float) -> void:
	var is_grounded: bool = get_bounce(delta)
	update_height()
	
	if is_grounded and not is_stopped():
		velocity *= BOUNCE_FRICTION
		update_frame()
	
	apply_velocity(delta)


# Gets whether the die is stopped:
func is_stopped() -> bool:
	return v_velocity == 0.0 and height == 0.0 and velocity == Vector2.ZERO


# Bounces the die on the floor and returns whether it is grounded:
func get_bounce(delta: float) -> bool:
	if height == 0.0 and v_velocity == 0.0:
		return true
	
	v_velocity -= gravity * delta
	height += v_velocity
	
	if height <= 0.0:
		height = 0.0
		v_velocity *= -bounciness
		
		if abs(v_velocity) < 1.0:
			v_velocity = 0.0
		
		return true
	
	return false


func apply_velocity(delta: float) -> void:
	if velocity == Vector2.ZERO:
		return
	
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if not collision:
		velocity = velocity.move_toward(Vector2.ZERO, AIR_FRICTION * delta)
		
		if velocity.length_squared() < 1.0:
			velocity = Vector2.ZERO
		
		return
	
	var collider: Object = collision.collider
	
	if collider is Node and collider.is_in_group("dice"):
		var exchange: Vector2 = velocity * ENERGY_TRANSFER
		collider.velocity += exchange
		velocity -= exchange
		collider.update_frame()
	
	velocity = velocity.bounce(collision.normal)
	velocity = move_and_slide(velocity)
	update_frame()


# Update the die's visual height:
func update_height() -> void:
	var scale: float = 1.0 + height * PERSPECTIVE_SCALE
	sprite.position.y = -height
	sprite.scale = Vector2(scale, scale)


# Set the die to a random frame and rotation:
func update_frame() -> void:
	sprite.frame = randi() % 8
	sprite.rotation = float(randi() % 3) * (TAU / 3.0)
