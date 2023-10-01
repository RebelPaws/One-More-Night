extends "res://Towers/Tower_Core.gd"

@export var heal_amount : float

func heal():
	var health_manager = get_parent().get_parent().get_node("Health_Manager")
	health_manager._heal(heal_amount)
	$CPUParticles3D.emitting = true

