extends Control

signal odds_hovered(odds)
signal odds_selected(odds)

onready var floating_number: FloatingNumber = $HBoxContainer/FloatingNumber

var controls_disabled: bool = false
var number: int = 14 setget set_number
var min_value: int = 4
var max_value: int = 24

func _ready():
	set_process_input(false)
	var bio = get_node("../bio")
	bio.connect("toggle_control", self, "set_controls")


func _input(event: InputEvent) -> void:
	if controls_disabled:
		return
	if event.is_action_pressed("ui_left"):
		set_number(number - 1)
	elif event.is_action_pressed("ui_right"):
		set_number(number + 1)
	elif event.is_action_pressed("ui_accept"):
		set_process_input(false)
		emit_signal("odds_selected", number)


func set_controls(value):
	controls_disabled = value

func set_number(value: int) -> void:
	if value < 4:
		value = 4
	elif value > 24:
		value = 24
	
	if value < min_value:
		value = min_value
	elif value > max_value:
		value = max_value
	
	if value == number:
		return
	
	number = value
	floating_number.number = value
	emit_signal("odds_hovered", number)
