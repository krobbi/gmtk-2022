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
					return "Wants to afford a nice birthday gift for her grandson."
				3:
					return "Former gambling addict."
		2:
			return "Feels that if she wins big again she can treat her grandson to a nice Christmas too."
		3:
			match balance:
				1:
					return "She's getting so lucky, no reason stopping now!"
				-1:
					return "She knows she can't get lucky every night. She's just wants to make up for her losses and buy that gift. Then she will call it, win or lose..."
				0:
					return "She's thinking that she is neither lucky or unlucky. She will just try to make back the money she lost yesterday and call it, win or lose..."
		4:
			match balance:
				1:
					return "She hasn't had this much fun in years! No stopping now, even if she loses sometimes she can always claw her wy back up."
				-1:
					return "She feels she shouldn't be back here. It's no longer going like night one, but here she is and she doesn't know why."
				0:
					return "She's feeling tension hasn't felt in years, day 4 and striking it neutral! The only thing on her mind is how tonight will go."
		5:
			return "The only things on her mind are the dice..."
	
	return "Sue is not sure what she's doing here. It's probably a bug."


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.GOOD


func _get_ending() -> Array:
	var balance: int = GameData.get_total_balance("sue", 5)
	
	if GameData.get_night_balance("sue", 1) > 0:
		if balance >= 8:
			return [
				"Sue's grandson was overjoyed at getting everything he wanted for his birthday. His parents were furious at Sue after figuring out just where she got all this money.",
				"Eventually, they managed to convince Sue to go back into rehab."
			]
		elif balance >= 4 and balance <= 7:
			return ["Sue's grandson got the gift he wanted, but for many years Sue's face became a very common appearance at the casino."]
		elif balance >= 0 and balance <= 3:
			return ["Sue continued trying to earn enough for that gift, but eventually slipped further and further in debt she could not afford."]
		elif balance >= -7 and balance <= -1:
			return [
				"Determined to make up her new debt, Sue fell further and further into her old addiction, never getting that gift.",
				"When she eventually passed her children were left with debt collectors chasing them for years to come."
			]
		elif balance <= -8:
			return [
				"The casino made a massive profit off of Sue that week, but were sad after she stopped coming.",
				"A few days after her final appearance a group of police arrived asking what they knew about her."
			]
	else:
		if balance == -1:
			return [
				"Having lost, Sue realised the mistake she was making coming back here.",
				"Her grandson never got his expensive gift, but her children managed to support her and stop her habit reforming."
			]
		elif balance >= -3 and balance <= -2:
			return [
				"Sue took a massive loss on her first night and never returned.",
				"She never managed to face her children and grandchildren about what happened, eventually picking up online gambling to try and make up for her losses."
			]
	
	return ["Sue found a bugged ending, please report this in the comments!"]
