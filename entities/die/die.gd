class_name Die
extends KinematicBody2D

enum State {IDLE, ROLLING}

export(float) var speed_min: float = 2500.0
export(float) var speed_max: float = 3000.0
export(float) var friction: float = 2000.0
export(float) var bounce_min: float = 0.99
export(float) var bounce_max: float = 1.1
export(float) var bounce_decay: float = 0.01
export(float) var energy_transfer: float = 0.5

var state: int = State.IDLE
var velocity: Vector2 = Vector2.ZERO
var bounce_power: float = bounce_min

# Process the die's state machine:
func _physics_process(delta: float) -> void:
	match state:
		State.ROLLING:
			process_rolling(delta)


# Roll the die:
func roll() -> void:
	randomize()
	var angle: float = rand_range(0.0, TAU)
	velocity = Vector2(cos(angle), sin(angle)) * rand_range(speed_min, speed_max)
	bounce_power = bounce_max
	state = State.ROLLING


# Process the rolling state:
func process_rolling(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if not collision:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		return
	
	var collider: Object = collision.collider
	
	if collider is Node and collider.is_in_group("dice"):
		collider.velocity += velocity * energy_transfer
	
	velocity = velocity.bounce(collision.normal) * bounce_power
	bounce_power = max(bounce_min, bounce_power - bounce_decay)
	velocity = move_and_slide(velocity)
