extends Opponent

func _get_profile_key() -> String:
	return "karen"


func _get_should_appear(night_number: int) -> bool:
	if night_number == 1:
		return false
	
	var balance: int = GameData.get_total_balance("karen", night_number - 1)
	
	if night_number == 4 and balance >= 5:
		return false
	
	if night_number == 5 and balance >= 3:
		return false
	
	return true


func _get_bio(night_number: int, round_number: int) -> String:
	var balance: int = GameData.get_total_balance("karen", night_number - 1)
	
	match night_number:
		2:
			match round_number:
				1:
					return "$Karen,39,Upper"
				2:
					return "Going through a divorce."
				3:
					return "Seems to be going out of her way to lose money."
		3:
			if balance > 0:
				return "Despite her winnings yesterday, she is even more frustrated sitting down to play today."
			else:
				return "Despite losing yesterday, she is in an even better mood."
		4:
			if balance >= 3:
				return "She is visibly annoyed at her continued winnings. She is trying to burn her income to reduce the child support she will be assigned to pay at an upcoming court date."
			elif balance >= 0:
				return "She is annoyed, and determined to reduce her saved assets. She is preparing for a court case by reducing the amount of child support she will be assigned to pay."
			elif balance >= -5 and balance <= -1:
				return "She is visibly happy with her losses. The lower her assets, the less child support she will need to pay."
			elif balance <= -6:
				return "She is ecstatic about the amount she has managed to burn, and wants to keep going."
		5:
			if balance >= 0:
				return "She is visibly angry at her profits after all the time she has spent at the table, and is making a scene with any and all nearby staff."
			elif balance >= -7 and balance <= -1:
				return "She continues to be ecstatic at her losses. While it's not at a maximum, she's clearly getting what she wants."
			elif balance <= -8:
				return "Karen has a face of pure satisfaction and malice looking at the losses she has made."
	
	return "Karen doesn't know what she's doing here. It's probably a bug."


func _get_strategy(_night_numebr: int) -> int:
	return GameManager.AI_STRATEGY.BAD


func _get_ending():
	if GameData.get_total_balance("karen", 3) >= 5 or GameData.get_total_balance("karen", 4) >= 3:
		return [
			"Despite her best efforts, Karen not only failed to lose money, but managed to make some.",
			"Her high assets meant she failed to reduce the child support she owed her ex.",
			"Due to her winnings, it instead increased, allowing her child to live a privileged and abuse-free life away from her."
		]
	
	var balance: int = GameData.get_total_balance("karen", 5)
	
	if balance <= -6:
		return [
			"Karen lost a lot over the week and is ecstatic about it, as are your management.",
			"Thanks to suddenly being \"fired\" from her job and losing all of her assets, her ex had to pay her alimony and does not receive any form of child support.",
			"Her child eventually ends up back with her after her father is deemed unfit to meet their needs."
		]
	elif balance >= -5 and balance <= -3:
		return [
			"While she could have lost more, Karen's plan was a success.",
			"With her limited financial support her ex struggles to give their child the good life they deserve."
		]
	elif balance >= -2 and balance <= 0:
		return [
			"For the most part, Karen's plan failed. She didn't lose enough and had to pay the money that her child rightfully deserved."
		]
	elif balance >= 1:
		return [
			"Despise her best efforts, Karen somehow made money over her time at the casino.",
			"Thanks to this, the courts mandated an even higher child support payment, allowing her child and ex to live more than comfortably over the following years."
		]
	
	return ["Karen found a bugged ending and complained about it in the comments."]
