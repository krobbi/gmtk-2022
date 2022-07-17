extends Control

func _ready() -> void:
	GameData.night += 1
	
	var is_ending: bool = not GameData.is_on_target or GameData.night >= 6
	
	if is_ending:
		$Label.text = "Epilogue"
		$TargetLabel.hide()
	else:
		$Label.text = "Night %d" % GameData.night
		$TargetLabel.text = "House Target: %d" % GameData.TARGETS[GameData.night - 1]
		$TargetLabel.show()
	
	yield(get_tree().create_timer(3.0), "timeout")
	
	if is_ending:
		get_tree().change_scene("res://scenes/ending/ending.tscn")
	else:
		get_tree().change_scene("res://scenes/test_table/test_table.tscn")
