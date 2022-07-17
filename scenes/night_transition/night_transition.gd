extends Control

func _ready() -> void:
	GameData.night += 1
	
	if GameData.night >= 6:
		$Label.text = "Epilogue"
	else:
		$Label.text = "Night %d" % GameData.night
	
	yield(get_tree().create_timer(3.0), "timeout")
	
	if GameData.night >= 6:
		get_tree().change_scene("res://scenes/ending/ending.tscn")
	else:
		get_tree().change_scene("res://scenes/test_table/test_table.tscn")
