extends Camera2D

const SHAKE_SPEED: float = 60.0
const SHAKE_DECAY: float = 0.8
const SHAKE_ROLL: float = 0.1
const SHAKE_OFFSET: Vector2 = Vector2(300.0, 300.0)

var noise: OpenSimplexNoise = OpenSimplexNoise.new()
var noise_pos: float = 0.0
var trauma: float = 0.0

func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.period = 4.0
	noise.octaves = 2
	EventBus.safe_connect("shake_camera_request", self, "shake")


func _exit_tree() -> void:
	EventBus.safe_disconnect("shake_camera_request", self, "shake")


func _process(delta: float) -> void:
	if trauma != 0.0:
		if not GameData.setting_screenShake:
			trauma = 0.0
		
		trauma = max(0.0, trauma - SHAKE_DECAY * delta)
		var shake: float = trauma * trauma
		noise_pos += SHAKE_SPEED * delta
		rotation = SHAKE_ROLL * shake * noise.get_noise_2d(noise.seed, noise_pos)
		offset.x = SHAKE_OFFSET.x * shake * noise.get_noise_2d(noise.seed * 2.0, noise_pos)
		offset.y = SHAKE_OFFSET.y * shake * noise.get_noise_2d(noise.seed * 3.0, noise_pos)


func shake(amount: float) -> void:
	trauma = min(1.0, trauma + amount)
