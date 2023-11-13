extends Node3D

func update_health(_health):
	$Health/Count.text = str(_health)

func update_armor(_armor):
	$Armor/Count.text = str(_armor)

func get_last_tower():
	var last_index = $Blocks.get_child_count()-1
	return $Blocks.get_child(last_index)
