extends Node3D

func update_health(_health):
	print("Update Health: " + str(_health))
	$Health/Count.text = str(_health)

func update_armor(_armor):
	$Armor/Count.text = str(_armor)

