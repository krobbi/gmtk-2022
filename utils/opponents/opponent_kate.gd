extends Opponent

func _get_profile_key() -> String:
	return "kate"


func _get_should_appear(_night_number: int) -> bool:
	return true


func _get_bio(_night_number: int, round_number: int) -> String:
	match round_number:
		1:
			return "$Kate,18,Middle"
		2:
			return "Visibly uncomfortable and doesn't want to be here."
		3:
			return "She's trying to earn money to pay for a life-saving surgery that her insurance won't cover."
	
	return "Kate is wondering why this bugged message appears."


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.RANDOM


func _get_ending() -> Array:
	if GameData.get_night_balance("kate", 5) >= 3:
		return ["Due to her lucky break, Kate was able to afford the costs of her surgery, making a full recovery."]
	else:
		return [
			"Unable to make the money she needed, Kate did not live to see the next month.",
			"Her family and friends miss her dearly, and wish they could have done more to support her in her time of need."
		]
