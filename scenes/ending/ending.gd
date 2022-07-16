extends Control

const EndingBioScene: PackedScene = preload("res://gui/ending_bio/ending_bio.tscn")

var events: Array = [
	"sue",
	"&", "albert",
	"&", "johnny", "jimmy",
	"&", "karen",
	"&", "marcus",
	"&", "kate",
	"&", "you",
]

var event_counter: int = 0
var bios: Array = []
var active_bio: EndingBio = null

func _ready() -> void:
	next()
	$NextButton.grab_focus()


func get_character_lines(character: String) -> Array:
	if character == "you":
		return ["This text shows at the end of the things", "It will eventually changed based on something"]
	
	return [
		"Example line for %s!" % character,
		"Second line for %s!" % character,
	]


func has_seen_character(_character: String) -> bool:
	return true


func next() -> void:
	if active_bio:
		active_bio.next()
		
		if active_bio.has_finished:
			active_bio = null
			next()
	elif event_counter >= events.size():
		get_tree().change_scene_to(preload("res://scenes/test_table/test_table.tscn"))
	elif events[event_counter] == "&":
		for bio in bios:
			bio.queue_free()
		
		bios.clear()
		event_counter += 1
		next()
	elif has_seen_character(events[event_counter]):
		var bio: EndingBio = EndingBioScene.instance()
		$VBoxContainer.add_child(bio)
		bio.display_profile(events[event_counter])
		bio.display_lines(get_character_lines(events[event_counter]))
		bios.push_back(bio)
		active_bio = bio
		event_counter += 1
	else:
		event_counter += 1
		next()


func _on_next_button_pressed() -> void:
	next()
