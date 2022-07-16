extends Node

const LIGHT_CLACKS: Array = [
	preload("res://resources/audio/light_clack_1.ogg"),
	preload("res://resources/audio/light_clack_2.ogg"),
	preload("res://resources/audio/light_clack_3.ogg"),
]

const HEAVY_CLACKS: Array = [
	preload("res://resources/audio/heavy_clack_1.ogg"),
	preload("res://resources/audio/heavy_clack_2.ogg"),
]

# Gets a random light clack sound:
func get_light_clack() -> AudioStreamOGGVorbis:
	randomize()
	return LIGHT_CLACKS[randi() % LIGHT_CLACKS.size()]


# Gets a random heavy clack sound:
func get_heavy_clack() -> AudioStreamOGGVorbis:
	randomize()
	return HEAVY_CLACKS[randi() % HEAVY_CLACKS.size()]
