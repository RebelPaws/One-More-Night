extends Node3D

@export var active : bool ##This determines whether the object is active or not

@export_category("Tower Identification")
@export var tower_id : String ##This is the tower's ID in all game files
@export var tower_category : String ##This is the category of the tower

#This holds all the info needed for the tower to operate
#All of it is right here for easy editing
@export_category("Basic Info")
@export var costs = {1: 20, 
						2: 5, 
						3: 5, 
						4: 5, 
						5: 5
					}

@export var health = {1: 20, 
						2: 5, 
						3: 5, 
						4: 5, 
						5: 5
					}

@export_subgroup("Attack")
@export var attack_damage = {1: 5, 
							2: 5, 
							3: 10, 
							4: 10, 
							5: 15
							}

#Updated attack rate to make sense
@export var attack_rate = {1: 2, 
						2: 2, 
						3: 2, 
						4: 1, 
						5: 1
						}

@export_subgroup("Defense")
@export var armor = {1: 20, 
						2: 5, 
						3: 5, 
						4: 5, 
						5: 5
						}

@export_subgroup("Healing")
@export var healing = {1: 20, 
						2: 5, 
						3: 5, 
						4: 5, 
						5: 5
						}

@export var healing_rate = {1: 20, 
							2: 5, 
							3: 5, 
							4: 5, 
							5: 5
							}

@export_category("Level Info")
var level = 1 #This is the tower's level which will determine everything about it.
@export var level_cap = 5 ##This is the tower's max level

@export_category("Target Settings")
var target_list = [] #This is the list of possible targets
var near_target_list = [] #This is the list of near possible targets
@export var target_groups = ["Enemy"] ##These are the groups that can be targeted

signal enemy_detected(enemy)

#This handles adding up armor
func _add_armor():
	#Note: This should only be applied once unless the tower gets a perk to add armor more than once.
	var health_manager = get_parent().get_parent().get_node("Health_Manager") #We get the health manager node we need
	#var armor = Towers._get_tower_info(tower_id, tower_category)[2][level] #This gets the tower's armor
	var armor_buff = armor.get(level)
	
	health_manager.armor += armor_buff #Finally we add the health manager's armor to the tower's armor

#This handles unit detection and sees if it can be added to the target list
func unit_detected(body):
	for group in target_groups: #For each group we can target we'll check the unit for
		if body.is_in_group(group): #If the unit is in the target group
			target_list.append(body) #We add them to the list
			return #Then we exit the function
		
		#Otherwise the loop will run until it either finds the right group or the unit isn't what it's looking for0

#This handles removing units from the target list
func unit_lost(body):
	var index = 0 #We set this so we can easily identify the position of the unit in the target list
	
	
	if body in target_list: #First we check to see if the unit is even in the target list
		for unit in target_list: #If they are we go through each unit to find them
			if target_list[index] == unit: #We check to see if the current array position is the unit
				target_list.remove_at(index) #If it is we remove it from the target list
				return #Then leave the function
			
			index += 1 #Otherwise we go to the next position in the target list

#This will open up the tower edit menu when clicked
func open_tower_menu():
	get_parent().get_parent().get_parent().get_node("UI/Tower_Edit").enable(self)

func level_up():
	level = clamp(level + 1, 1, level_cap)
	for path in get_node("Units/Path3D").get_children():
		path.get_child(0).update_stats()

#This will return the cost whether it's level 1 or another level
func _get_cost(_type):
	match _type:
		"Build":
			return costs[1]
		"Upgrade":
			return costs[level + 1]


func get_closest_path_node(target, path_node):
	var closest_path_node : Vector3 = Vector3.ZERO
	var closest_path_id : int = 0
	for i in path_node.curve.get_point_count():
		if closest_path_node == Vector3.ZERO:
			closest_path_node = path_node.curve.get_point_position(i)
			closest_path_id = i
		else:
			if target.global_position.distance_to(path_node.curve.get_point_position(i)) < target.global_position.distance_to(closest_path_node):
				#closest_path_node = path_node.curve.get_point_position(i)
				closest_path_node = path_node.curve.get_point_position(i)
				closest_path_id = i
	
	return closest_path_id


func signal_archer_unit():
	var passed_target
	if near_target_list.size() == 0:
		passed_target = target_list[0]
	else:
		passed_target = near_target_list[0]
	var archer_found = false
	var checks = 1
	while archer_found == false and checks != get_parent().get_child_count():
		var closest_path_id : int
		for i in get_parent().get_children():
			if i.tower_id == "Archer":
				var path_holder = i.get_node("Units/Path3D")
				closest_path_id = get_closest_path_node(passed_target, path_holder)
				var nearest_archer = null
				for path in path_holder.get_children():
					if nearest_archer == null:
						nearest_archer = path.get_child(0)
					elif path.child(0).global_position.distance_to(passed_target.global_position) < nearest_archer.global_position.distance_to(passed_target.global_position):
						nearest_archer = path.get_child(0)
				if nearest_archer != null:	
					#nearest_archer.speed = .2
					nearest_archer.passed_target_list.append([passed_target, nearest_archer.path_progress_ratios.get(closest_path_id)])
					#nearest_archer.ratio_walking_to = nearest_archer.path_progress_ratios.get(closest_path_id)
					#nearest_archer.toggle_walking()
					archer_found = true
					if nearest_archer.target_list.size() == 0:
						nearest_archer.get_passed_target()
					if near_target_list.has(passed_target):
						near_target_list.erase(passed_target)
				continue
			checks += 1
	if near_target_list.size() > 0:
		get_node("Timer").start()
	
	"""for i in get_parent().get_children():
		if i.tower_id == "Archer":
			
			var nearest_archer = null
			if is_near:
				for path in i.get_node("Units/Path3D").get_children():
					if path.get_child(0).target_list.size() > 0:
						continue
					elif path.get_child(0).is_walking == true:
						return
					elif nearest_archer == null:
						nearest_archer = path.get_child(0)
			else:
				for path in i.get_node("Units/Path3D").get_children():
					if nearest_archer != null:
						return
					elif path.get_child(0).is_walking == true:
						return
					else:
						nearest_archer = path.get_child(0)
						return
			if nearest_archer != null:	
				#nearest_archer.speed = .2
				nearest_archer.ratio_walking_to = nearest_archer.path_progress_ratios.get(closest_path_id)
				nearest_archer.toggle_walking()"""

func _on_foundation_detect_body(body):
	target_list.append(body)
	if $Timer.is_stopped():
		$Timer.start()
	#emit_signal("enemy_detected", body)
	#signal_archer_unit()
	

func _on_nearby_detection_range_body_entered(body):
	target_list.erase(body)
	near_target_list.append(body)
	if $Timer.is_stopped():
		$Timer.start()
	#signal_archer_unit()


func _on_detection_range_body_exited(body):
	if target_list.has(body):
		target_list.erase(body)


func _on_nearby_detection_range_body_exited(body):
	near_target_list.erase(body)


func pass_targets_to_archer():
	signal_archer_unit()
