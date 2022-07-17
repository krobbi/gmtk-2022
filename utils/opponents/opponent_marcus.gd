extends Opponent

func _get_profile_key() -> String:
	return "marcus"


func _get_should_appear(night_number: int) -> bool:
	return night_number >= 4


func _get_bio(night_number: int, round_number: int) -> String:
	match night_number:
		4:
			match round_number:
				1:
					return "$Marcus,21,Upper"
				2:
					return "New in town, starting at the local college."
				3:
					return "He was given money from his father to support himself here. He intends to multiply those savings this evening."
		5:
			if GameData.get_night_balance("marcus", 4) >= 0:
				return "Marcus is riding high on his win, thinking about what he can spend this extra income on."
			else:
				return "Marcus is worried about his losses, if his father finds out he could be cut off. The risk excites him."
	
	return "Marcus doesn't know what he's doing here. It's probably a bug."


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.GOOD


func _get_ending() -> Array:
	var balance: int = GameData.get_total_balance("marcus", 5)
	
	if balance == 0:
		return ["Marcus enjoyed his time and visited again on occasion. He kept on top of his studies and graduated without incident."]
	elif balance >= 1:
		return ["Marcus invested his winnings into all sorts of other activities, his studies quickly fading to the back of his mind."]
	elif balance >= -3 and balance <= -1:
		return ["Marcus never let his parents find out about his losses. He had a horrible time in college due to the lack of savings, never going out and unable to stay in the nicer accommodation he had arranged."]
	elif balance <= -4:
		return [
			"After his drastic losses, Marcus had to tell his parents he was out of money to live on. They immediately cut him off.",
			"A few years later, Marcus ends up on the streets, never coming close to what he was capable of achieving."
		]
	
	return ["Marcus found a bugged ending!"]
