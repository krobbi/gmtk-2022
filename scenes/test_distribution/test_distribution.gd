extends Control

onready var floating_number_spawner: FloatingNumberSpawner = $FloatingNumberSpawner

var test_mean: int = 14
var rects: Array = []

func _ready() -> void:
	draw(test_mean)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		test_mean -= 1
		
		if test_mean < 4:
			test_mean = 4
		
		draw(test_mean)
	elif event.is_action_pressed("ui_right"):
		test_mean += 1
		
		if test_mean > 24:
			test_mean = 24
		
		draw(test_mean)


func draw(mean: int) -> void:
	var results: Dictionary = debug(mean, 100000)
	
	for rect in rects:
		rect.queue_free()
	
	rects.clear()
	
	for i in range(4, 25):
		var rect: ColorRect = ColorRect.new()
		
		if i == test_mean:
			rect.color = Color.red
		elif i % 2:
			rect.color = Color.gray
		
		rect.rect_position.x = float(16 * i)
		rect.rect_position.y = 16.0
		rect.rect_size.x = 16.0
		rect.rect_size.y = results.get(i, 0) * 0.05
		add_child(rect)
		rects.push_back(rect)


func debug(mean: int, iterations: int) -> Dictionary:
	var results: Dictionary = {}
	
	for _i in range(iterations):
		var result: int = floating_number_spawner.get_weighted_roll(mean)
		
		if result < 4:
			result = 4
		elif result > 24:
			result = 24
		
		if results.has(result):
			results[result] += 1
		else:
			results[result] = 1
	
	return results
