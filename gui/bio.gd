extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var casino_gui = get_node("../CasinoGui")
	casino_gui.connect("open_gui", self, "_on_open_bio")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_open_bio():
	show()

func _on_close_button_pressed():
	hide()

