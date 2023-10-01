extends Node3D

func _update_currency(_new_amount):
	$Count.text = str(_new_amount)

