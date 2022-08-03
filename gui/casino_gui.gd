extends Control

export var profit: int = 0
export var target: int = 3

onready var player_count_sprites: Array = $player_count.get_children()
onready var good_label: Label = $Label_GOOD
onready var bad_label: Label = $Label_BAD

func _ready() -> void:
	target = GameData.TARGETS[GameData.night - 1]
	update_profit(GameData.house_balance)


func display_player_count(value: int) -> void:
	for i in range(player_count_sprites.size()):
		player_count_sprites[i].visible = i < value


func update_profit(value: int) -> void:
	profit = value
	good_label.text = "%d/%d" % [profit, target]
	bad_label.text = good_label.text
	good_label.visible = profit >= target
	bad_label.visible = not good_label.visible
