extends Control

var old_bio: Dictionary = {}

signal toggle_control(status)
signal new_bio

# Called when the node enters the scene tree for the first time.
func _ready():
	var casino_gui = get_node("../PlayerGui")
	casino_gui.connect("open_bio", self, "_on_open_bio")


func _on_open_bio():
	show()
	emit_signal("toggle_control", true)

func _on_close_button_pressed():
	hide()
	emit_signal("toggle_control", false)


func are_bios_equal(a: Dictionary, b: Dictionary) -> bool:
	for key in a.keys():
		if not b.has(key):
			return false
		
		if a[key] != b[key]:
			return false
	
	for key in b.keys():
		if not a.has(key):
			return false
	
	return true


func display_bio(bio: Dictionary) -> void:
	if are_bios_equal(old_bio, bio):
		return
	
	old_bio = bio.duplicate(true)
	
	if bio.has("name"):
		$name_set.text = bio["name"]
	else:
		$name_set.text = "Unknown"
	
	if bio.has("age"):
		$age_set.text = bio["age"]
	else:
		$name_set.text = "Unknown"
	
	if bio.has("class"):
		$status_set.text = "%s Class" % bio["class"]
	else:
		$status_set.text = "Unknown class"
	
	if bio.has("bio"):
		$ibo_set.text = bio["bio"]
	else:
		$ibo_set.text = "You can not read who this is..."
	
	if bio.has("status"):
		$status_set2.text = bio["status"]
	else:
		$status_set2.text = "You can not read what they are doing..."
	
	emit_signal("new_bio")
