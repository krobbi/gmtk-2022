extends Opponent

func _get_profile_key() -> String:
	return "jimmy"


func _get_should_appear(night_number: int) -> bool:
	if night_number == 1 or GameData.get_total_balance("jimmy", night_number - 1) >= 0:
		return false
	
	return true


func _get_bio(night_number: int, round_number: int) -> String:
	var relative_night_number: int = get_relative_night_number(night_number)
	
	match relative_night_number:
		1:
			match round_number:
				1:
					return "$Jimmy,29,Middle"
				2:
					return "Here on his honeymoon with his husband Johnny."
				3:
					return "He can no longer afford to travel home thanks to Johnny's losses. He's here to make up the lost savings."
		2:
			return "He's frustrated with Johnny for forcing him into this."
		3:
			return "He's deeply concerned about being able to make back the money."
		4:
			return "It's the last night of his honeymoon, and his last chance to make back the money."
	
	return "Jimmy doesn't know what he's doing here, it's probably a bug."


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.GOOD


func _get_ending() -> Array:
	var balance: int = int(sign(GameData.get_total_balance("jimmy", 5)))
	
	match balance:
		1:
			return [
				"Thanks to Jimmy's winnings he managed to return home with Johnny and money to spare, but their marriage was off to a rocky start.",
				"Eventually, they got over the incident. Jimmy admits he had fun, despite being forced to play."
			]
		0:
			return [
				"Jimmy managed to scrape back the lost money, but it was far closer than he was comfortable with.",
				"The relationship eventually recovered, but the incident left a long lasting strain on it."
			]
		-1:
			return [
				"Jimmy hitchhiked home with Johnny having been unable to recuperate his losses.",
				"Their marriage did not last a year from the proposal."
			]
	
	return ["Jimmy somehow found a bugged ending."]


func get_johnny_loss_night_number() -> int:
	for i in range(5):
		if GameData.get_total_balance("johnny", i + 1) < 0:
			return i + 1
	
	return 0


func get_relative_night_number(night_number: int) -> int:
	return night_number - get_johnny_loss_night_number()
