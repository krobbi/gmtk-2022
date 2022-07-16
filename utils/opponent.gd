class_name Opponent
extends Reference

var scores: Array = [0, 0, 0, 0, 0]

func _get_profile_key() -> String:
	return "you"


func _get_should_appear(_night_number: int) -> bool:
	return true


func _get_bio(_night_number: int, _round_number: int) -> String:
	return "$John Doe,123,Lower/Middle/Upper"


func _get_strategy(_night_number: int) -> int:
	return GameManager.AI_STRATEGY.RANDOM


func _get_ending() -> Array:
	return [
		"Ending message 1!",
		"Ending message 2!",
	]
