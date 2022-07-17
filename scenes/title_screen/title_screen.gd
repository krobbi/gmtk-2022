extends Node2D

var menu_option: int = 0 # Play: 0, Tutorial:1, Options: 2, Credits: 3 
onready var options = [$play, $tutorial, $options, $credits]
onready var scenes = ["res://scenes/intro/intro.tscn",
					  "res://scenes/tutorial/tutorial.tscn",
					  "res://scenes/options/options.tscn",
					  "res://scenes/credits/credits.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
	move_cursor()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move_cursor():
	$cursor.position.y = options[menu_option].position.y
	$cursor.frame = randi() % 8
	
	$ClackPlayer.stream = ClackCache.get_light_clack()	
	$ClackPlayer.pitch_scale = rand_range(0.9, 1.1)
	$ClackPlayer.play()

func load_scene():
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
	

func _on_play_mouse_entered():
	menu_option = 0
	move_cursor()
	
func _on_tutorial_mouse_entered():
	menu_option = 1
	move_cursor()

func _on_optioins_mouse_entered():
	menu_option = 2
	move_cursor()

func _on_credits_mouse_entered():
	menu_option = 3
	move_cursor()

func _on_texturebutton_pressed():
	load_scene() # Replace with function body.
