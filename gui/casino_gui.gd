extends Control

export var profit: int = 0
export var target: int = 3

onready var player_count_sprites: Array = $player_count.get_children()


func _ready():
	target = GameData.TARGETS[GameData.night - 1]
	update_profit(profit)

func display_player_count(value: int) -> void:
	for i in range(player_count_sprites.size()):
		player_count_sprites[i].visible = i < value

func update_profit(val):
	profit = val
	$Label_BAD.text = String(profit)
	$Label_GOOD.text = String(profit)
	if profit < target:
		$Label_BAD.show()
		$Label_GOOD.hide()
	else:
		$Label_BAD.hide()
		$Label_GOOD.show()
