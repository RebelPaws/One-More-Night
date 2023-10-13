extends MeshInstance3D

@export var disable_default = false ##This will decide if it's disabled by default or not

@export var random_chance : float ##This is the chance it can disable on load (0 means it won't)

func _ready():
	var roll = randf_range(0, 1)
	if random_chance <= roll:
		hide()
	else:
		show()

