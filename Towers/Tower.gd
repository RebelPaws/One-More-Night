extends Node3D

var tower_blocks : Node3D
#hit_box = get_node("Health_Manager/HitBox")
#health = get_node("Health")
#armor = get_node("Armor")
#tower_blocks = get_node("Blocks")

#This gets the last tower blocks available aka the top of the tower
func get_last_tower():
	var last_index = tower_blocks.get_child_count()-1
	return tower_blocks.get_child(last_index)

func setup():
	tower_blocks = get_node("Blocks")

