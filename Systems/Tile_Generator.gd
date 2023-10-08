extends Node3D

@export var can_decorate = true

func _ready():
	var decor_node = Node.new()
	add_child(decor_node)
	
	var biome = get_node("Biome/" + GameInfo.biome)
	
	for b in $Biome.get_children():
		b.hide()
	
	biome.show()
	
	
	if not can_decorate: return
	
	if randf_range(0, 100) <= biome.chance_of_decor:
		var new_decor = biome.decor.pick_random().instantiate()
		decor_node.add_child(new_decor)
		new_decor.global_position = self.global_position + Vector3(0, 0.4, 0)
		new_decor.scale = Vector3(0.7, 0.7, 0.7)

