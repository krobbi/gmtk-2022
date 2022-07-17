extends Opponent

func _get_profile_key() -> String:
	return "sue"


func _get_should_appear(night_number: int) -> bool:
	if night_number == 1:
		return true
	else:
		return GameData.get_night_balance("sue", 1) > 0


func _get_bio(night_number: int, round_number: int) -> String:
	var balance: int = int(sign(GameData.get_total_balance("sue", night_number - 1)))
	
	match night_number:
		1:
			match round_number:
				1:
					return "$Sue,83,Lower"
				2:
					return "Wants to afford a nice birthday gift for her grandon."
				3:
					return "Former gambling addict."
		2:
			return "Feels that if she wins big again she can treat her granson to a nice Christmas too."
		3:
			match balance:
				1:
					return "She's getting so lucky, no reason stopping now!"
				-1:
					return "She knows she can't get lucky every night. She's telling herself she just wants to just try and make up for what she lost last night and buy that gift, then she will call it, win or lose..."
				0:
					return "She's thinking that she is neither lucky or unlucky, she is telling herself that she will just try to remake the money she lost yesterday and call it, win or lose..."
		4:
			match balance:
				1:
					return "She hasn't had this much fun in years! No stopping now, even if she loses sometimes she can always claw back up."
				-1:
					return "She should not be back here, it's no longer going like night one. But here she is, she doesn't know why."
				0:
					return "This is tension she hasn't felt in years, day 4 and striking it neutral, the only thing on her mind is how will tonight go."
		5:
			return "The only thing on her mind is the dice..."
	
	return "She's not sure what she's doing here, it's probably a bug."


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.GOOD


func _get_ending() -> Array:
	var balance: int = GameData.get_total_balance("sue", 5)
	
	if GameData.get_night_balance("sue", 1) > 0:
		if balance >= 8:
			return ["Sue's grandson got everything he wanted for his birthday this year, though his parents were furious at Sue after figuring out just where she got all this money. They managed to convince her to go back into rehab."]
		elif balance >= 4 and balance <= 7:
			return ["Sue’s grandson got the gift he wanted, but for many years her face became a very common appearance at the casino."]
		elif balance >= 0 and balance <= 3:
			return ["Sue continued trying to earn enough for that gift, but eventually slipped further and further in debt she could not afford."]
		elif balance >= -7 and balance <= -1:
			return ["Determined to make up her new debt Sue falls further and further into her old addiction, never getting that gift. When she eventually passes her children are left with debt collectors chasing them for years to come."]
		elif balance <= -8:
			return ["The casino made a massive profit off of Sue that week and were sad after she stopped coming. Though a few days after her final appearance a group of police arrived asking what they knew about her."]
	else:
		if balance == -1:
			return ["Having lost Sue realised the mistake she was making coming back here and while her grandson never did get that expensive gift her children managed to support her and stop the habit of reforming."]
		elif balance >= -3 and balance <= -2:
			return ["Sue took a massive loss on her first night, while she never returned, she never managed to face her children and grandchildren about what happened, eventually picking up online gambling to try and make up for her loses."]
	
	return ["Sue found a bugged ending, please report this in the comments!"]
