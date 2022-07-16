extends Node

var opponents: Dictionary = {
	"sue": Opponent.new(),
	"albert": Opponent.new(),
	"johnny": Opponent.new(),
}

func get_profile_key(key: String) -> String:
	return opponents[key]._get_profile_key()


func get_night_balance(key: String, night_number: int) -> int:
	return opponents[key].scores[night_number - 1]


func get_total_balance(key: String, night_number: int) -> int:
	var balance: int = 0
	
	for i in range(night_number):
		balance += get_night_balance(key, i + 1)
	
	return balance


func get_strategy(key: String, night_number: int) -> int:
	return opponents[key]._get_strategy(night_number)


func add_balance(key: String, night_number: int, amount: int) -> void:
	opponents[key].scores[night_number - 1] += amount
