class_name GameManager
extends Node

signal higher_lower_chosen(is_higher)
signal number_changed(number)
signal balance_changed(balance)
signal house_balance_changed(house_balance)
signal round_count_changed(round_count)
signal player_changed(player_name)
signal player_count_changed(player_count)
signal bio_changed(bio)
signal round_finished(was_won)

enum AI_STRATEGY {GOOD, BAD, RANDOM}

export(NodePath) var die_spawner_path: NodePath = NodePath()
export(NodePath) var floating_number_spawner_path: NodePath = NodePath()
export(NodePath) var mana_bar_path: NodePath = NodePath()
export(NodePath) var odds_selector_path: NodePath = NodePath()
export(NodePath) var player_gui_path: NodePath = NodePath()

var opponent_queue: Array = []
var current_opponent: String = "sue"
var night_number: int = 1
var round_count: int = 3
var number: int = 14
var mana: int = 15
var odds: int = 14
var is_expecting_higher: bool = false

onready var die_spawner: DieSpawer = get_node(die_spawner_path)
onready var floating_number_spawner: FloatingNumberSpawner = get_node(floating_number_spawner_path)
onready var mana_bar: Control = get_node(mana_bar_path)
onready var odds_selector: Control = get_node(odds_selector_path)
onready var player_gui: Control = get_node(player_gui_path)

func _ready() -> void:
	var error: int = floating_number_spawner.connect("number_rolled", self, "_on_number_rolled")
	
	if error and floating_number_spawner.is_connected("number_rolled", self, "_on_number_rolled"):
		floating_number_spawner.disconnect("number_rolled", self, "_on_number_rolled")
	
	error = odds_selector.connect("odds_selected", self, "_on_odds_selected")
	
	if error and odds_selector.is_connected("odds_selected", self, "_on_odds_selected"):
		odds_selector.disconnect("odds_selected", self, "_on_odds_selected")
	
	error = odds_selector.connect("odds_hovered", self, "_on_odds_hovered")
	
	if error and odds_selector.is_connected("odds_hovered", self, "_on_odds_hovered"):
		odds_selector.disconnect("odds_hovered", self, "_on_odds_hovered")


# Gets the opponent queue for the current night:
func get_opponent_queue() -> Array:
	var queue: Array = []
	
	for i in range(night_number):
		match i + 1:
			1:
				queue.append_array(["sue", "albert", "johnny"])
			2:
				queue.append_array(["jimmy", "karen"])
			4:
				queue.push_back("marcus")
			5:
				queue.push_back("kate")
	
	for i in range(queue.size() - 1, -1, -1):
		if not GameData.get_should_appear(queue[i], night_number):
			queue.remove(i)
	
	return queue


# Gets the AI's current strategy:
func get_ai_strategy() -> int:
	return GameData.get_strategy(current_opponent, night_number)


# Gets whether the AI chooses higher on its strategy:
func get_ai_choice() -> bool:
	var strategy: int = get_ai_strategy()
	randomize()
	
	match strategy:
		AI_STRATEGY.GOOD:
			if number > 14:
				return false
			elif number < 14:
				return true
			else:
				return bool(randi() % 2)
		AI_STRATEGY.BAD:
			if number > 14:
				return true
			elif number < 14:
				return false
			else:
				return bool(randi() % 2)
		AI_STRATEGY.RANDOM, _:
			return bool(randi() % 2)


# Begins a new night:
func begin_night(night_number_val: int) -> void:
	night_number = night_number_val
	night_number = GameData.night
	mana = 20
	mana_bar.changeMana(mana)
	opponent_queue = get_opponent_queue()
	begin_game()


# Begins a new game of higher or lower:
func begin_game() -> void:
	if opponent_queue.empty():
		if GameData.house_balance < GameData.TARGETS[night_number - 1]:
			GameData.is_on_target = false
		
		# warning-ignore: RETURN_VALUE_DISCARDED
		get_tree().change_scene("res://scenes/night_transition/night_transition.tscn")
		return
	
	current_opponent = opponent_queue[0]
	opponent_queue.remove(0)
	emit_signal("player_changed", current_opponent)
	
	player_gui.animation_player.play("scooch_in")
	yield(player_gui, "scooched_in")
	
	emit_signal("balance_changed", GameData.get_total_balance(current_opponent, night_number))
	emit_signal("player_count_changed", opponent_queue.size())
	
	round_count = 3
	emit_signal("round_count_changed", round_count)
	number = 14
	
	emit_signal("number_changed", number)
	begin_round()


# Runs when the round begins:
func begin_round() -> void:
	is_expecting_higher = get_ai_choice()
	emit_signal("higher_lower_chosen", is_expecting_higher)
	
	var round_number: int = (3 - round_count) + 1
	GameData.update_bio(current_opponent, night_number, round_number)
	emit_signal("bio_changed", GameData.get_bio(current_opponent))
	
	odds = 14
	odds_selector.set_number(odds)
	odds_selector.min_value = odds - mana * 2
	odds_selector.max_value = odds + mana * 2
	select_odds()


# Let the player select the odds:
func select_odds() -> void:
	odds_selector.set_process_input(true)


# Finishes the round with a win or loss:
func finish_round(was_won: bool) -> void:
	GameData.add_balance(current_opponent, night_number, 1 if was_won else -1)
	emit_signal("balance_changed", GameData.get_total_balance(current_opponent, night_number))
	
	if was_won:
		GameData.house_balance -= 1
	else:
		GameData.house_balance += 1
	
	# Special case for Johnny and Jimmy:
	if round_count <= 0 and current_opponent == "johnny":
		var johnny_balance: int = GameData.get_total_balance("johnny", night_number)
		GameData.opponents["jimmy"].scores[night_number - 1] = johnny_balance
	
	emit_signal("house_balance_changed", GameData.house_balance)
	emit_signal("round_finished", was_won)


func _on_round_end() -> void:
	if round_count > 0:
		begin_round()
	else:
		player_gui.animation_player.play("scooch_out")
		yield(player_gui, "scooched_out")
		
		begin_game()


func _on_odds_hovered(new_odds: int) -> void:
	var cost: int = int(abs(new_odds - odds) / 2.0)
	mana_bar.highlight_cost(cost)


# Runs when the player selects odds:
func _on_odds_selected(new_odds: int) -> void:
	var cost: int = int(abs(new_odds - odds) / 2.0)
	odds = new_odds
	mana -= cost
	mana_bar.changeMana(mana)
	mana_bar.unhighlight_cost()
	floating_number_spawner.odds = odds
	round_count -= 1
	emit_signal("round_count_changed", round_count)
	die_spawner.spawn_dice(GameData.setting_quickRoll)


# Runs when a numnber is finished rolling:
func _on_number_rolled(new_number: int) -> void:
	if new_number == number:
		die_spawner.spawn_dice(GameData.setting_quickRoll) # Reroll:
		return
	
	var was_higher: bool = new_number > number
	number = new_number
	emit_signal("number_changed", number)
	
	finish_round(is_expecting_higher == was_higher)
