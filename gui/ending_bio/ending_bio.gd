class_name EndingBio
extends HBoxContainer

signal finished

onready var timer: Timer = $Timer
onready var label: Label = $Label

var has_finished: bool = false
var lines: Array = []

func display_profile(name: String) -> void:
	$TextureRect.texture = load("res://resources/textures/npcs/%s.png" % name)


func display_lines(lines_ref: Array) -> void:
	lines = lines_ref
	next()


func next() -> void:
	if label.percent_visible < 1.0:
		timer.stop()
		label.percent_visible = 1.0
	elif not lines.empty():
		label.text = lines[0]
		label.visible_characters = 0
		lines.remove(0)
		timer.start()
	elif not has_finished:
		has_finished = true
		emit_signal("finished")


func _on_timer_timeout() -> void:
	label.visible_characters += 1
	
	if label.percent_visible < 1.0:
		timer.start()
