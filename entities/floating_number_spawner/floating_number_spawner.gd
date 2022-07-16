extends YSort

signal number_rolled(number)

const FloatingNumberScene: PackedScene = preload(
		"res://entities/floating_number/floating_number.tscn"
)

const CENTER: Vector2 = Vector2(960.0, 540.0)

var floating_numbers: Array = []

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


func spawn_numbers(positions: Array) -> void:
	for position in positions:
		var floating_number: FloatingNumber = FloatingNumberScene.instance()
		floating_number.position = position
		floating_numbers.push_back(floating_number)
		add_child(floating_number)
		floating_number.set_number(randi() % 6 + 1)
	
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
