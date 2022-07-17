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
		if not GameData.is_on_target:
			return ["Your performance was too low. The casino is not happy, and you won't be around to see the next shift."]
		elif GameData.house_balance >= 25:
			return [
				"You earned more than just your freedom, you excelled! The money was rolling in throughout the entire week.",
				"You are free now, but you like it here. The money. The fame. The attention.",
				"Perhaps you will stay, just for one more week."
			]
		elif GameData.house_balance >= 20:
			return [
				"You did well. While you may not have been able to help all those who needed it, you have earned your freedom.",
				"You are free to spend your days as you wish."
			]
		else:
			return [
				"While you have passed, the casino is not too pleased with your performance.",
				"You are forced to stay in servitude."
			]
	
	return GameData.get_ending(character)


func has_seen_character(character: String) -> bool:
	if character == "you":
		return true
	elif not GameData.is_on_target:
		return false
	elif character == "jimmy":
		var has_inherited_loss: bool = false
		
		for score in GameData.opponents["jimmy"].scores:
			if score != 0:
				if has_inherited_loss:
					return true
				else:
					has_inherited_loss = true
	
	for score in GameData.opponents[character].scores:
		if score != 0:
			return true
	
	return false


func next() -> void:
	if active_bio:
		active_bio.next()
		
		if active_bio.has_finished:
			active_bio = null
			next()
	elif event_counter >= events.size():
		get_tree().change_scene_to(preload("res://scenes/title_screen/title_screen.tscn"))
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
