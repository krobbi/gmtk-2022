extends Node2D

var menu_option: int = 0 # Play: 0, Tutorial:1, Options: 2, Credits: 3 
onready var options: Array = [$play, $tutorial, $options, $credits]
onready var scenes: Array = ["res://scenes/intro/intro.tscn",
					  "res://scenes/tutorial/tutorial.tscn",
					  "res://scenes/options/options.tscn",
					  "res://scenes/credits/credits.tscn"]


func _ready() -> void:
	move_cursor()


func move_cursor() -> void:
	$cursor.position.y = options[menu_option].position.y
	$cursor.frame = randi() % 8
	
	$ClackPlayer.stream = ClackCache.get_light_clack()	
	$ClackPlayer.pitch_scale = rand_range(0.9, 1.1)
	$ClackPlayer.play()


func load_scene() -> void:
	# warning-ignore: RETURN_VALUE_DISCARDED
	get_tree().change_scene(scenes[menu_option])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		menu_option = menu_option - 1
		if menu_option == -1:
			menu_option = 3
		move_cursor()
	elif event.is_action_pressed("ui_down"):
		menu_option = menu_option + 1
		if menu_option == 4:
			menu_option = 0
		move_cursor()
	elif event.is_action_pressed("ui_accept"):
		load_scene()
	

func _on_play_mouse_entered() -> void:
	menu_option = 0
	move_cursor()

	
func _on_tutorial_mouse_entered() -> void:
	menu_option = 1
	move_cursor()


func _on_optioins_mouse_entered() -> void:
	menu_option = 2
	move_cursor()


func _on_credits_mouse_entered() -> void:
	menu_option = 3
	move_cursor()


func _on_texturebutton_pressed() -> void:
	load_scene()
