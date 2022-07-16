extends Control


signal toggle_control(status)

# Called when the node enters the scene tree for the first time.
func _ready():
	var casino_gui = get_node("../PlayerGui")
	casino_gui.connect("open_bio", self, "_on_open_bio")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_open_bio():
	show()
	emit_signal("toggle_control", true)

func _on_close_button_pressed():
	hide()
	emit_signal("toggle_control", false)

