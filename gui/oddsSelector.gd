extends Control

onready var floating_number: FloatingNumber = $HBoxContainer/FloatingNumber

var number: int = 14 setget set_number

func _ready():
	set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		set_number(number - 1)
	elif event.is_action_pressed("ui_right"):
		set_number(number + 1)


func set_number(value: int) -> void:
	if value < 4:
		value = 4
	elif value > 24:
		value = 24
	
	if value == number:
		return
	
	number = value
	floating_number.number = value
