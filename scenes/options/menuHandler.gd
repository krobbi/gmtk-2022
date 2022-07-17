extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	if GameData.setting_screenShake:
		$screenshake.show()
	if GameData.setting_quickRoll:
		$Fastroll.show()
	if GameData.setting_music:
		$Music.show()


func _on_screenshake_button_pressed():
	GameData.setting_screenShake = not GameData.setting_screenShake
	if GameData.setting_screenShake:
		$screenshake.show()
	else:
		$screenshake.hide()


func _on_fastroll_button_pressed():
	GameData.setting_quickRoll = not GameData.setting_quickRoll
	if GameData.setting_quickRoll:
		$Fastroll.show()
	else:
		$Fastroll.hide()


func _on_music_button_pressed():
	GameData.setting_music = not GameData.setting_music
	if GameData.setting_music:
		$Music.show()
	else:
		$Music.hide()
