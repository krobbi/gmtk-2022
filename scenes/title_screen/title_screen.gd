extends Control

const SCENES: PoolStringArray = PoolStringArray([
	"res://scenes/intro/intro.tscn",
	"res://scenes/tutorial/tutorial.tscn",
	"res://scenes/options/options.tscn",
	"res://scenes/credits/credits.tscn",
])

var selected_option: int = -1

onready var options: Array = $Options.get_children()
onready var cursor: Sprite = $Cursor
onready var clack_player: AudioStreamPlayer = $ClackPlayer

func _ready() -> void:
	for i in range(options.size()):
		var option: Button = options[i]
		
		if option.connect("focus_entered", self, "set_selected_option", [i]) != OK:
			print("Failed to connect focus_entered on option %d!" % i)
		
		if option.connect("mouse_entered", self, "set_selected_option", [i]) != OK:
			print("Failed to connect mouse_entered on option %d!" % i)
		
		if option.connect("pressed", self, "_on_option_pressed", [i]) != OK:
			print("Failed to connect pressed on option %d!" % i)
	
	set_selected_option(0)


func set_selected_option(value: int) -> void:
	if value < 0:
		value = options.size() - 1
	elif value >= options.size():
		value = 0
	
	var is_initial_selection: bool = selected_option == -1
	
	if selected_option == value:
		return
	
	selected_option = value
	
	var option: Button = options[selected_option]
	option.grab_focus()
	cursor.position.y = option.rect_global_position.y + option.rect_size.y * 0.5
	cursor.frame = randi() % 8
	cursor.rotation = float(randi() % 3) * (TAU / 3.0)
	
	if not is_initial_selection:
		clack_player.stream = ClackCache.get_light_clack()
		clack_player.pitch_scale = rand_range(0.9, 1.1)
		clack_player.play()


func _on_option_pressed(index: int) -> void:
	if index < 0 or index >= SCENES.size():
		return
	
	# warning-ignore: RETURN_VALUE_DISCARDED
	get_tree().change_scene(SCENES[index])
