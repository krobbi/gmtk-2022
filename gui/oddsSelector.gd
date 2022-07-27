extends Control

signal odds_hovered(odds)
signal odds_selected(odds)

onready var floating_number: FloatingNumber = $HBoxContainer/FloatingNumber

var controls_disabled: bool = false
var number: int = 14 setget set_number
var min_value: int = 4
var max_value: int = 24

func _ready() -> void:
	set_process_input(false)
	var bio = get_node("../bio")
	bio.connect("toggle_control", self, "set_controls")


func _input(event: InputEvent) -> void:
	if controls_disabled:
		return
	if event.is_action_pressed("ui_left"):
		set_number(number - 2)
	elif event.is_action_pressed("ui_right"):
		set_number(number + 2)
	elif event.is_action_pressed("ui_accept"):
		set_process_input(false)
		emit_signal("odds_selected", number)


func get_actual_min() -> int:
	if min_value < 4:
		return 4
	else:
		return min_value


func get_actual_max() -> int:
	if max_value > 24:
		return 24
	else:
		return max_value


func set_controls(value: bool) -> void:
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
	
	if value == get_actual_min():
		get_node("../leftButton").hide()
	else:
		get_node("../leftButton").show()

	if value == get_actual_max():
		get_node("../rightButton").hide()
	else:
		get_node("../rightButton").show()

	if value == number:
		return
	
	number = value
	floating_number.number = value
	emit_signal("odds_hovered", number)


func _on_rollButton_pressed() -> void:
	if not controls_disabled and is_processing_input():
		set_process_input(false)
		emit_signal("odds_selected", number)


func _on_leftButton_pressed() -> void:
	if not controls_disabled and is_processing_input():
		set_number(number - 2)


func _on_rightButton_pressed() -> void:
	if not controls_disabled and is_processing_input():
		set_number(number + 2)
