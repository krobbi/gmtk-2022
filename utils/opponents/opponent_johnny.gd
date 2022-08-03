extends Opponent

func _get_profile_key() -> String:
	return "johnny"


func _get_should_appear(night_number: int) -> bool:
	if night_number == 1:
		return true
	else:
		return GameData.get_total_balance("johnny", night_number - 1) >= 0


func _get_bio(night_number: int, round_number: int) -> String:
	if night_number == 1:
		match round_number:
			1:
				return "$Johnny,27,Middle"
			2:
				return "Here on his honeymoon. Very visibly intoxicated."
			3:
				return "His husband made him promise not to go to the casino, but Johnny wants to win him something."
	elif night_number == 2:
		return "He's never gambled until now, but he's already hooked and reveling in the previous win."
	
	var has_won: bool = GameData.get_total_balance("johnny", night_number - 1) >= GameData.get_total_balance("johnny", night_number - 2)
	
	match night_number:
		3:
			if has_won:
				return "His mind is clouded with money. He's managing to pamper his husband, but his true intentions are set on winning cash."
			else:
				return "He's frustrated at losing his winnings, but has strengthened his resolve and is determined to make them back."
		4:
			if has_won:
				return "His husband is begging him to take his winnings, quit while he's ahead, and not return to the casino. Johnny thinks this is ridiculous."
			else:
				return "He's worried his husband's warnings were correct. He's sure he will make it up to him and make it big again."
		5:
			return "He's upset. His husband has returned from their honeymoon early thanks to Johnny's frequent visits to the casino."
	
	return "Johnny's not sure what he's doing here. It's probably a bug."


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.RANDOM


func _get_ending() -> Array:
	if _get_should_appear(5):
		if GameData.get_total_balance("johnny", 5) >= 6:
			return [
				"Using his winnings, Johnny took his husband on a second honeymoon and this time spent it all with him.",
				"Their marriage stayed rocky for several years, but they eventually moved on from the incident."
			]
		else:
			return [
				"Johnny returned home at the expected time to an empty home and divorce papers.",
				"He was never seen at this casino again, but became a regular at the casinos near his hometown."
			]
	
	return ["Having lost money at the casino, Johnny had to face up to his husband with nothing to show for it."]
