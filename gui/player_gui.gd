extends Control

signal open_bio()
signal round_ended
signal scooched_out
signal scooched_in

onready var profile_button: TextureButton = $face/TextureButton
onready var speech_bubble: Sprite = $textBox
onready var chip_sprites: Array = $Chips.get_children()
onready var credit_sprites: Array = $Score.get_children()
onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	display_credit(0)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var bio: Control = get_node("../bio")
		
		if bio.is_visible_in_tree():
			bio._on_close_button_pressed()
		else:
			_on_TextureButton_pressed()


func display_win_lose(value: bool) -> void:
	speech_bubble.hide()
	
	if value:
		$AnimationPlayer.play("win")
	else:
		$AnimationPlayer.play("lose")


func display_player(value: String) -> void:
	profile_button.texture_normal = load("res://resources/textures/npcs/%s.png" % GameData.get_profile_key(value))


func display_higher_lower(is_higher: bool) -> void:
	if is_higher:
		speech_bubble.texture = preload("res://resources/textures/speech_box_higher.png")
	else:
		speech_bubble.texture = preload("res://resources/textures/speech_box_lower.png")
	
	speech_bubble.show()


func display_chips(value: int) -> void:
	for i in range(3):
		chip_sprites[i].visible = i < value


func display_credit(value: int) -> void:
	var is_positive: bool = value > 0
	var abs_value: int = int(abs(value))
	
	for i in range(15):
		if is_positive:
			credit_sprites[i].texture = preload("res://resources/textures/positive_coin.png")
		else:
			credit_sprites[i].texture = preload("res://resources/textures/negative_coin.png")
		
		credit_sprites[i].visible = i < abs_value


func display_new_info() -> void:
	$Bio/NewInfoIcon.show()


func _on_TextureButton_pressed():
	emit_signal("open_bio")
	$Bio/NewInfoIcon.hide()


func _on_AnimationPlayer_animation_finished(anim_name:String) -> void:
	if anim_name == "win" or anim_name == "lose":
		emit_signal("round_ended")
	elif anim_name == "scooch_out":
		emit_signal("scooched_out")
	elif anim_name == "scooch_in":
		emit_signal("scooched_in")
