extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var mana: int = 20

var manaNodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	manaNodes = get_children()
	changeMana(mana)

func changeMana(value):
	mana = value
	
	for i in range(20):
		if i+1 <= mana:
			manaNodes[i].enable()
		else:
			manaNodes[i].disable()
			

	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
