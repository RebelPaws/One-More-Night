extends "res://Towers/Tower_Core.gd"

var can_attack = true
var chance_for_quickdraw = 35.0

@export var attack_time_default = 2.0

func _ready():
	attack()

#This creates a list of potential targets
func create_target_list():
	if target_list.size() <= 0: return
	
	var targets = {"All": [], "Closest": [], "LeastHealth": []} #The empty target array we'll fill
	
	#For each body in the detection range area gets checked
	for target in target_list:
		if target.is_in_group("Enemy"): #If the target is in the Enemy group we can move on
			if target.active: #We need to make sure the target is actually active
				targets["All"].append(target) #If we're all set then we can make it a target!
	
	#Checks for distance
	for target_1 in targets["All"]:
		var distance_to_tower = target_1.global_position.distance_to(get_parent().get_parent().global_position)
		var add_to_close = true
		var check_count = 0
		
		for target_2 in targets["All"]:
			if distance_to_tower >= target_2.global_position.distance_to(get_parent().get_parent().global_position):
				check_count += 1
		
		if check_count < 3:
			targets["Closest"].append(target_1)
	
	return targets

func attack():
	var new_targets = create_target_list()
	
	if $Detection_Range.get_overlapping_bodies().size() <= 0: 
		$Attack_Timer.start()
		return
	
	can_attack = false
	
	for archer in $Units.get_children():
		var new_target = new_targets["Closest"].pick_random()
		if new_target == null: 
			$Attack_Timer.start()
			return
		
		archer.shoot(new_target)
	
	#This handles running the attack timer again
	var chance_roll = randf_range(0, 100) #This chance roll is for the quickdraw event
	if chance_roll <= chance_for_quickdraw: #If chance is in the archer's favor
		$Attack_Timer.wait_time = attack_time_default * 0.5 #Quickdraw happens and the default time is halved
	else: #If the archer doesn't get lucky
		$Attack_Timer.wait_time = attack_time_default #It just sets it to the default time
	
	$Attack_Timer.start()

func attack_reset():
	can_attack = true
	
	attack()

