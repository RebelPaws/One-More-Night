extends Node3D

#This is the tower controller

#This updates the health visual of the tower
func update_health(_health):
	$Health/Count.text = str(_health)

#This updates the armor visual of the tower
func update_armor(_armor):
	$Armor/Count.text = str(_armor)

#This gets the last tower blocks available aka the top of the tower
func get_last_tower():
	var last_index = $Blocks.get_child_count()-1
	return $Blocks.get_child(last_index)
