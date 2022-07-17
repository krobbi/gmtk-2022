extends Node

const TARGETS: Array = [2, 4, 6, 8, 10]

var night: int = 0
var house_balance: int = 0
var is_on_target: bool = true

#Settigs
var setting_screenShake: bool = true
var setting_quickRoll: bool = false
var setting_music: bool = true setget set_setting_music

var opponents: Dictionary = {
	"sue": load("res://utils/opponents/opponent_sue.gd").new(),
	"albert": load("res://utils/opponents/opponent_albert.gd").new(),
	"johnny": load("res://utils/opponents/opponent_johnny.gd").new(),
	"jimmy": load("res://utils/opponents/opponent_jimmy.gd").new(),
	"karen": load("res://utils/opponents/opponent_karen.gd").new(),
	"marcus": load("res://utils/opponents/opponent_marcus.gd").new(),
	"kate": load("res://utils/opponents/opponent_kate.gd").new(),
}
var bios: Dictionary = {}

# New game:
func reset() -> void:
	night = 0
	house_balance = 0
	is_on_target = true
	opponents = {
		"sue": load("res://utils/opponents/opponent_sue.gd").new(),
		"albert": load("res://utils/opponents/opponent_albert.gd").new(),
		"johnny": load("res://utils/opponents/opponent_johnny.gd").new(),
		"jimmy": load("res://utils/opponents/opponent_jimmy.gd").new(),
		"karen": load("res://utils/opponents/opponent_karen.gd").new(),
		"marcus": load("res://utils/opponents/opponent_marcus.gd").new(),
		"kate": load("res://utils/opponents/opponent_kate.gd").new(),
	}
	bios = {}


func set_setting_music(value: bool) -> void:
	setting_music = value
	
	if setting_music:
		$MusicPlayer.play()
	else:
		$MusicPlayer.stop()


func get_profile_key(key: String) -> String:
	return opponents[key]._get_profile_key()


func get_night_balance(key: String, night_number: int) -> int:
	return opponents[key].scores[night_number - 1]


func get_total_balance(key: String, night_number: int) -> int:
	var balance: int = 0
	
	for i in range(night_number):
		balance += get_night_balance(key, i + 1)
	
	return balance


func get_should_appear(key: String, night_number: int) -> bool:
	return opponents[key]._get_should_appear(night_number)


func get_strategy(key: String, night_number: int) -> int:
	return opponents[key]._get_strategy(night_number)


func get_ending(key: String) -> Array:
	return opponents[key]._get_ending()


func get_bio(key: String) -> Dictionary:
	return bios.get(key, {})


func add_balance(key: String, night_number: int, amount: int) -> void:
	opponents[key].scores[night_number - 1] += amount


func update_bio(key: String, night_number: int, round_number: int) -> void:
	var message: String = opponents[key]._get_bio(night_number, round_number)
	
	if not bios.has(key):
		bios[key] = {}
	
	if message.begins_with("$"):
		var sections: PoolStringArray = message.substr(1).split(",")
		bios[key]["name"] = sections[0]
		bios[key]["age"] = sections[1]
		bios[key]["class"] = sections[2]
		return
	
	if not bios[key].has("bio"):
		bios[key]["bio"] = message
	else:
		bios[key]["status"] = message
