extends Opponent

func _get_profile_key() -> String:
	return "albert"


func _get_should_appear(night_number: int) -> bool:
	match night_number:
		1:
			return true
		2:
			return GameData.get_night_balance("albert", 1) >= 2
		3:
			var balance: int = GameData.get_total_balance("albert", 2)
			return balance >= 4
		_: # Nights 4 and 5:
			var balance: int = GameData.get_total_balance("albert", 3)
			return balance >= 3


func _get_bio(night_number: int, round_number: int) -> String:
	var balance: int = GameData.get_total_balance("albert", night_number - 1)
	
	match night_number:
		1:
			match round_number:
				1:
					return "$Albert,43,Middle"
				2:
					return "Aims to pay money to the mob."
				3:
					return "The mafia is threatening to kill his brother if he does not pay up tonight."
		2:
			return "He is awash with relief and worry. The mafia are interested in his gambling habits and now have his infant son for more leverage."
		3:
			return "His fantastic results have led to the mafia relying on him to gamble their own money. Albert is nervous, but filled with unmistakable confidence."
		4:
			if balance >= 6:
				return "His confidence has swelled to new levels. He has earned the trust of his former tormentors."
			else:
				return "Some of his nervousness has returned. He needs a lucky break."
		5:
			if balance >= 8:
				return "Despite rolling in cash, he is nervous tonight, but you can't get a sense for why."
			elif balance >= 4 and balance <= 7:
				return "He is well dressed and clearly pampered. He is quickly settling into the new life he has found for himself."
			else:
				return "He once again has a nervous energy about him. He is dedicated to making his bosses money out of fear."
	
	return "Albert's not sure what he's doing here, it's probably a bug."


func _get_strategy(night_number: int) -> int:
	if night_number == 5 and GameData.get_total_balance("albert", 4) >= 8:
		return GameManager.AI_STRATEGY.BAD
	else:
		return GameManager.AI_STRATEGY.GOOD


func _get_ending() -> Array:
	if not _get_should_appear(2):
		return ["Albert's body was found in his own quarters after failing to save his brother."]
	elif not _get_should_appear(3):
		return ["Albert's body was found in his own quarters after failing to save his son."]
	elif not _get_should_appear(4):
		return ["Having lost the money so generously given to him from the mob, Albert was found shot dead in an alley several streets from the casino."]
	
	var balance: int = GameData.get_total_balance("albert", 4)
	
	if balance <= 6:
		return [
			"Albert has continued to rise in the ranks of the local mob. His family is no longer at risk.",
			"Instead, he has taken quite nicely into the business of kidnapping."
		]
	elif balance >= 8:
		return [
			"Albert's constant winnings and the mafia's explosion of wealth led to an investigation into the family opening.",
			"After his failure to lose cash, a tactical sting was performed.",
			"Several key members of the mafia were killed in this event, including Albert."
		]
	else:
		return [
			"Albert continued to meet the mafia's demands, even ditching some of the money he had earned when rumours started spreading of a police investigation.",
			"Albert has continued to curry favour in his organisation and has claimed the local title 'King of the Casino.'"
		]
