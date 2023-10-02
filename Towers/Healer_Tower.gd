extends "res://Towers/Tower_Core.gd"

@export var heal_amount : float

@export var heal_rate_default : float
@export var chance_to_mega_heal : float
@export var chance_to_quick_cast : float

func heal():
	var chance_roll = randf_range(0, 100)
	var health_manager = get_parent().get_parent().get_node("Health_Manager")
	
	if chance_roll <= chance_to_mega_heal:
		health_manager._heal(heal_amount * 2)
	else:
		health_manager._heal(heal_amount)
	
	chance_roll = randf_range(0, 100)
	if chance_roll <= chance_to_quick_cast:
		$Heal_Rate.wait_time = heal_rate_default * 0.5
	else:
		$Heal_Rate.wait_time = heal_rate_default
	
	$CPUParticles3D.emitting = true
	$Heal_Rate.start()

