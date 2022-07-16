class_name Die
extends KinematicBody2D

enum State {IDLE, SPAWNING, ROLLING}

const PERSPECTIVE_SCALE: float = 0.003
const GRAVITY: float = 20.0
const BOUNCINESS: float = 0.6
const BOUNCE_FRICTION: float = 0.8
const AIR_FRICTION: float = 500.0
const FLOOR_FRICTION: float = 1000.0
const ENERGY_TRANSFER: float = 0.3
const ROLL_SPEED_MIN: float = 2500.0
const ROLL_SPEED_MAX: float = 3000.0
const ROLL_LIFT_MIN: float = 10.0
const ROLL_LIFT_MAX: float = 12.0
const WALL_POWER_MIN: float = 0.9
const WALL_POWER_MAX: float = 1.2
const WALL_POWER_DECAY: float = 0.05

var state: int = State.IDLE
var height: float = 0.0
var v_velocity: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var wall_power: float = WALL_POWER_MIN

onready var frame_timer: Timer = $FrameTimer
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite

func _physics_process(delta: float) -> void:
	match state:
		State.SPAWNING:
			if not animation_player.is_playing():
				roll()
		State.ROLLING:
			var is_grounded: bool = get_bounce(delta)
			update_height()
			
			if is_grounded and not is_stopped():
				velocity *= BOUNCE_FRICTION
				update_frame()
			
			apply_velocity(delta, is_grounded)


# Bounces the die on the floor and returns whether it is grounded:
func get_bounce(delta: float) -> bool:
	if height == 0.0 and v_velocity == 0.0:
		return true
	
	v_velocity -= GRAVITY * delta
	height += v_velocity
	
	if height <= 0.0:
		height = 0.0
		v_velocity *= -BOUNCINESS
		
		if abs(v_velocity) < 1.0:
			v_velocity = 0.0
		
		return true
	
	return false


# Gets whether the die is stopped:
func is_stopped() -> bool:
	return (
			state == State.ROLLING and v_velocity == 0.0 and height == 0.0
			and velocity == Vector2.ZERO
	)


# Applies the die's velocity:
func apply_velocity(delta: float, is_grounded: bool) -> void:
	if velocity == Vector2.ZERO:
		return
	
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if not collision:
		if is_grounded:
			velocity = velocity.move_toward(Vector2.ZERO, FLOOR_FRICTION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, AIR_FRICTION * delta)
			
			if frame_timer.is_stopped():
				update_frame()
				frame_timer.start()
		
		if velocity.length_squared() < 1.0:
			velocity = Vector2.ZERO
		
		return
	
	var collider: Object = collision.collider
	
	if collider is Node and collider.is_in_group("dice"):
		var transferred_velocity: Vector2 = velocity * ENERGY_TRANSFER
		collider.velocity += transferred_velocity
		velocity -= transferred_velocity
		collider.update_frame()
	
	velocity = velocity.bounce(collision.normal) * wall_power
	wall_power = max(WALL_POWER_MIN, wall_power - WALL_POWER_DECAY)
	velocity = move_and_slide(velocity)
	update_frame()


# Spawns the die:
func spawn() -> void:
	update_frame()
	animation_player.play("spawn")
	state = State.SPAWNING


# Unspawns the die:
func unspawn() -> void:
	animation_player.play_backwards("spawn")
	yield(animation_player, "animation_finished")
	queue_free()


# Rolls the die:
func roll() -> void:
	randomize()
	var angle: float = rand_range(0.0, TAU)
	velocity = Vector2(cos(angle), sin(angle)) * rand_range(ROLL_SPEED_MIN, ROLL_SPEED_MAX)
	v_velocity = rand_range(ROLL_LIFT_MIN, ROLL_LIFT_MAX)
	update_frame()
	update_height()
	state = State.ROLLING


# Updates the die's visual height:
func update_height() -> void:
	var scale: float = 1.0 + height * PERSPECTIVE_SCALE
	sprite.position.y = -height
	sprite.scale = Vector2(scale, scale)


# Updates the die to a random frame and rotation:
func update_frame() -> void:
	randomize()
	sprite.frame = randi() % 8
	sprite.rotation = float(randi() % 3) * (TAU / 3.0)
