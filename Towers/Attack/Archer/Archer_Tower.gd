extends "res://Towers/Tower_Core.gd"

var can_attack = true
var chance_for_quickdraw = 35.0
@onready var archer_scene = preload("res://Towers/Attack/Archer/Archer_Unit/Archer_Unit.tscn")
@onready var units_holder = get_node("Units")
@onready var walking_path = get_node("Units/Path3D")

var base_tower

var top_y_value : float = 0.0

#var archer_locations : Dictionary = {0: [Vector3(0.614,-.153,-.079), Vector3(0,95.1,0)],
		#1: [Vector3(-0.318,-0.166,-0.535), Vector3(0,-149.6,0)],
		#2: [Vector3(-0.17,-0.128,.518), Vector3(0,-13.9,0)]}

func _ready():
	if not active:
		return
	base_tower = get_tree().get_root().get_node("Game/Tower/Blocks/Tower_Foundation")
	print(get_tree().get_root().get_node("Game"))
	spawn_archer()
	
	#attack()
	#var detection_range = get_node("Detection_Range")
	#var click = get_node("3D_Click")
	
	#detection_range.body_entered.connect(unit_detected)
	#detection_range.body_exited.connect(unit_lost)
	
	#click.ObjectClicked.connect(open_tower_menu)

func start_night():
	for path in get_node("Units/Path3D").get_children():
		path.get_child(0).attack_rate_timer.start()
		path.get_child(0).PLAY_STATE = "NIGHT"

func start_day():
	for path in get_node("Units/Path3D").get_children():
		path.get_child(0).PLAY_STATE = "DAY"

func spawn_archer():
	var new_path_follow = PathFollow3D.new()
	new_path_follow.rotation_mode = PathFollow3D.ROTATION_Y
	new_path_follow.use_model_front = true
	new_path_follow.loop = true
	walking_path.add_child(new_path_follow)
	var new_archer = archer_scene.instantiate()
	new_archer.hide()
	new_path_follow.add_child(new_archer)
	#new_archer.position = archer_locations[archer_info][0]
	#new_archer.rotation_degrees = archer_locations[archer_info][1]
	#new_archer.rotation_degrees.y += rotation_degrees.y
	new_archer.prepare_archer()
	if get_tree().get_root().get_node("Game").PLAY_STATE == "NIGHT":
		new_archer.PLAY_STATE = "NIGHT"
	
	new_archer.show()
	#new_archer.toggle_walking()
	


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
	pass
	"""var new_targets = create_target_list()
	
	if $Detection_Range.get_overlapping_bodies().size() <= 0: 
		$Attack_Timer.start()
		return
	
	can_attack = false
	
	for archer in $Units.get_children():
		archer.damage = attack_damage[level]
		var new_target = null
		if new_targets["Closest"].size() > 0:
			new_target = new_targets["Closest"].pick_random()
		else: 
			$Attack_Timer.start()
			return
		
		archer.shoot(new_target)
	
	#This handles running the attack timer again
	var chance_roll = randf_range(0, 100) #This chance roll is for the quickdraw event
	if chance_roll <= chance_for_quickdraw: #If chance is in the archer's favor
		$Attack_Timer.wait_time = attack_rate[level] * 0.5 #Quickdraw happens and the default time is halved
	else: #If the archer doesn't get lucky
		$Attack_Timer.wait_time = attack_rate[level] #It just sets it to the default time
	
	$Attack_Timer.start()"""

func find_target(attack_position):
	var target = null
	if base_tower.near_target_list.size() > 0:
		for possible_target in base_tower.near_target_list:
			if target == null:
				target = possible_target
			elif attack_position.distance_to(possible_target.global_position) < attack_position.distance_to(target.global_position):
				target = possible_target
	elif base_tower.target_list.size() > 0:
		for possible_target in base_tower.target_list:
			if target == null:
				target = possible_target
			elif attack_position.distance_to(possible_target.global_position) < attack_position.distance_to(target.global_position):
				target = possible_target
	
	return target

func attack_reset():
	can_attack = true

