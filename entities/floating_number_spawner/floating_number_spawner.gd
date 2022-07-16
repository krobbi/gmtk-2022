class_name FloatingNumberSpawner
extends YSort

signal number_rolled(number)

const FloatingNumberScene: PackedScene = preload(
		"res://entities/floating_number/floating_number.tscn"
)

const CENTER: Vector2 = Vector2(960.0, 540.0)
const STANDARD_DEVIATION: float = 4.0

var floating_numbers: Array = []

onready var reveal_player: AudioStreamPlayer = $RevealPlayer

func _process(_delta: float) -> void:
	if floating_numbers.empty():
		set_process(false)
		return
	
	for floating_number in floating_numbers:
		if not floating_number.get_ease(CENTER, 0.2):
			break
	
	merge_numbers()
	
	if floating_numbers.size() == 1 and floating_numbers[0].position.distance_to(CENTER) < 10.0:
		var last: FloatingNumber = floating_numbers[0]
		var error: int = last.connect("despawned", self, "_on_last_despawned", [], CONNECT_ONESHOT)
		
		if error and last.is_connected("despawned", self, "_on_last_despawned"):
			last.disconnect("despawned", self, "_on_last_despawned")
		
		last.despawn()
		floating_numbers.clear()


func get_weighted_roll(mean: int) -> int:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var result: int = 0
	
	while result < 4 or result > 24:
		rng.randomize()
		result = int(round(rng.randfn(mean, STANDARD_DEVIATION)))
	
	return result


func get_rolls(target: int, dice: int, sides: int) -> PoolIntArray:
	var rolls: PoolIntArray = PoolIntArray()
	var available: PoolIntArray = PoolIntArray()
	available.resize(dice)
	
	for i in range(dice):
		available[i] = 1
	
	var remainder: int = target - dice
	
	while remainder > 0 and not available.empty():
		var index: int = randi() % available.size()
		
		if available[index] >= sides:
			rolls.push_back(sides)
			available.remove(index)
		else:
			available[index] += 1
			remainder -= 1
	
	while not available.empty():
		rolls.push_back(available[0])
		available.remove(0)
	
	return rolls


func spawn_numbers(positions: Array) -> void:
	var rolls: PoolIntArray = get_rolls(get_weighted_roll(14), positions.size(), 6)
	
	for i in range(positions.size()):
		var floating_number: FloatingNumber = FloatingNumberScene.instance()
		floating_number.position = positions[i]
		floating_numbers.push_back(floating_number)
		add_child(floating_number)
		floating_number.set_number(rolls[i])
	
	set_process(true)


func merge_numbers() -> void:
	for i in range(floating_numbers.size() - 1, -1, -1):
		var a: FloatingNumber = floating_numbers[i]
		
		for j in range(floating_numbers.size() - 1, i, -1):
			var b: FloatingNumber = floating_numbers[j]
			
			if a == b or not a.area.get_overlapping_areas().has(b.area):
				continue
			
			a.position = (a.position + b.position) * 0.5
			a.set_number(a.number + b.number)
			floating_numbers.remove(j)
			b.queue_free()


func _on_last_despawned(number: int) -> void:
	emit_signal("number_rolled", number)
	reveal_player.play()
