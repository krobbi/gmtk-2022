extends Node2D

func _ready() -> void:
	$GameManager.begin_night(GameData.night)
