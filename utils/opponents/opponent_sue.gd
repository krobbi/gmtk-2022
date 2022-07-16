extends Opponent

func _get_profile_key() -> String:
	return "sue"


func _get_should_appear(night_number: int) -> bool:
	if night_number == 1:
		return true
	
	return GameData.get_night_balance("sue", 1) > 0


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.GOOD


func _get_ending() -> Array:
	return [
		"Sue's ending message is not implemented yet."
	]
