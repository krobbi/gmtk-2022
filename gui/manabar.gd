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


func highlight_cost(value: int) -> void:
	unhighlight_cost()
	
	for i in range(mana - value, mana):
		manaNodes[i].modulate = Color(2.0, 2.0, 2.0, 1.0)


func unhighlight_cost() -> void:
	for mana_node in manaNodes:
		mana_node.modulate = Color.white
