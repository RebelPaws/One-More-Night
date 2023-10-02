extends Node3D

func _ready():
	
	for tree in get_children():
		var roll = randi_range(0, 10)
		
		if roll <= 4:
			tree.hide()
