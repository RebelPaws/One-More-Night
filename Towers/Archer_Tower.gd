extends "res://Towers/Tower_Core.gd"

var can_attack = true
var chance_for_quickdraw = 35.0

@export var attack_time_default = 2.0

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
	
	var chance_roll = randf_range(0, 100)
	if chance_roll <= chance_for_quickdraw:
		$Attack_Timer.wait_time = attack_time_default * 0.5
	else:
		$Attack_Timer.wait_time = attack_time_default
	
	$Attack_Timer.start()

func attack_reset():
	can_attack = true
	
	attack()

