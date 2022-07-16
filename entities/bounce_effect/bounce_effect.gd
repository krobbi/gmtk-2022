class_name BounceEffect
extends Particles2D

func _ready() -> void:
	set_emitting(true)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
