extends Node3D

#At some point this Legacy script may be more useful converted to a more dynamic environment editor script

func _ready():
	#For each decor item in the scene it'll roll to see if it should be hidden or not
	for tree in get_children():
		var roll = randi_range(0, 10)
		
		if roll <= 4:
			tree.hide()
