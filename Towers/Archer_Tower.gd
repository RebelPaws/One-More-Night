extends "res://Towers/Tower_Core.gd"

var can_attack = true

func _ready():
	attack()

func create_target_list():
	var targets = []
	
	for target in $Detection_Range.get_overlapping_bodies():
		if target.is_in_group("Enemy"):
			targets.append(target)
	
	return targets

func attack():
	var new_targets = create_target_list()
	
	if new_targets.size() <= 0: 
		$Attack_Timer.start()
		return
	
	can_attack = false
	
	var target_index = 0
	for target in target_list:
		if target.active == false:
			target_list.remove_at(target_index)
		target_index += 1
	
	for archer in $Units.get_children():
		archer.shoot(new_targets.pick_random())
	
	$Attack_Timer.start()

func attack_reset():
	can_attack = true
	
	attack()

