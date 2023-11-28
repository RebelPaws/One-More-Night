extends Node3D

@export var arrow_tscn : PackedScene
@onready var attack_rate_timer = get_node("attack_timer")
@onready var cooldown_timer = get_node("cooldown_timer")
@onready var game_world = get_tree().get_root().get_node("Game")
@onready var tower_node = get_parent().get_parent().get_parent().get_parent()

#var base_tower_vector3 = Vector3(45.127, 0,54.531)
var base_tower_vector3 : Vector3

var path_following : PathFollow3D

var speed : float = 0.0
var chance_for_perfect_shot = 20.0
var damage = 5.0
var attack_rate = 1.0
var cooldown_rate = 0.5

var PLAY_STATE : String = "DAY" #DAY or NIGHT depending on time

var attack_ready = false
var is_prepared = false
var is_walking = false

var ratio_walking_to : float
var current_target : Node3D = null
var walked_to_target : bool = false

var path_progress_ratios : Dictionary = {
	0: 0.0,	1: .1,	2: .2,	3: .4,
	4: .5,	5: .6,	6: .7,	7: .8,
	8: .9#,	9: .99
}

#TESTING ROTATION!!!#
"""
var test_targets : Array = [Vector3(50,2.5,54.5), Vector3(49.937,4,57.94),
Vector3(45.11,4,59.224),Vector3(40.287,4,57.852),Vector3(38.447,4,54.5)]

var test_targets_dict : Dictionary = {1: Vector3(50,2.5,54.5), 2: Vector3(49.937,4,57.94),
3: Vector3(45.11,4,59.224),4: Vector3(40.287,4,57.852),5: Vector3(38.447,4,54.5)}

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("check_rotation"):
		if is_walking:
			toggle_walking()
		var test_target = test_targets.pick_random()
		print("test target at: " + str(test_target))
		print("Test Target #" + str(test_targets_dict.find_key(test_target)))
		_rotate_towards(test_target, 1.0)
		await get_tree().create_timer(3.0).timeout
		if is_walking == false:
			toggle_walking()
		
"""

func which_quadrant(current_position):
	var x_val = current_position.x
	var z_val = current_position.z
	if x_val < base_tower_vector3.x:
		if z_val >= base_tower_vector3.z:
			return 1
		else:
			return 4
	else:
		if z_val >= base_tower_vector3.z:
			return 2
		else:
			return 3
	


#Setup the archer to get ready!
func prepare_archer():
	path_following = get_parent()
	base_tower_vector3 = (tower_node.global_position * Vector3(1,0,1))
	$AnimationPlayer.set_speed_scale(2.0)
	
	if PLAY_STATE == "NIGHT":
		attack_rate_timer.start()
		
	is_prepared = true
	toggle_walking()


func _physics_process(delta):
	if is_walking:
		var parent_progress = get_parent().get_progress()
		get_parent().set_progress(parent_progress + speed*delta)
		if speed < 0:
			rotation_degrees.y = 180
		else:
			rotation_degrees.y = 0
		if PLAY_STATE == "DAY":
			pass
		elif PLAY_STATE == "NIGHT":
			if current_target == null:
				return
			else:
				if snapped(get_parent().get_progress_ratio(), .1) == ratio_walking_to:
					toggle_walking()
					attack()
			

func update_stats():
	damage = tower_node.attack_damage[tower_node.level]
	attack_rate = tower_node.attack_rate[tower_node.level]
	attack_rate_timer.wait_time = attack_rate
	

func toggle_walking():
	if is_walking:
		is_walking = false
		#if current_target == null:
			#rotation_degrees.y = -90			
		speed = 0.0
		

	else:
		is_walking = true
		if PLAY_STATE == "DAY":
			speed = [0.2, -0.2].pick_random()
			
		elif PLAY_STATE == "NIGHT":
			if current_target == null:
				speed = [0.5, -0.5].pick_random()
			else:
				walk_to_node()
		

func walk_to_node(): # This is for walking to a node for a "current_target" in a different quadrant
	var prog_ratio = get_parent().get_progress_ratio()
	if snapped(prog_ratio, .1) == ratio_walking_to:
		attack()
		return
	var distance_forward : float
	var distance_back : float
	if ratio_walking_to < prog_ratio:
		distance_forward = ratio_walking_to + 1 - prog_ratio
		distance_back = prog_ratio - ratio_walking_to
	else:
		distance_forward = ratio_walking_to - prog_ratio
		distance_back = prog_ratio + 1 - ratio_walking_to
	print("Ratio Walking To: " + str(ratio_walking_to) + "\nProgress_Ratio: " + str(prog_ratio))
	print("Distance Forward: " + str(distance_forward) + "\nDistance Back: " + str(distance_back))
	if distance_forward < distance_back:
		speed = 0.5
		print("Walking forwards")
	else:
		speed = -0.5
		print("Walking backwards")


func _rotate_towards(target: Vector3, duration: float):
	var y_null = Vector3(1,0,1)
	var target_location = target * y_null
	var archer_location = global_position * y_null
	var direction_from_tower_to_target = base_tower_vector3.direction_to(target_location)
	var direction_from_tower_to_archer = base_tower_vector3.direction_to(archer_location)
	var new_angle_vector = (direction_from_tower_to_target-direction_from_tower_to_archer).normalized()
	
	var archer_angle_viewing = get_parent().rotation.y + rotation.y - PI
	#print("parent's rotation: " + str(get_parent().rotation_degrees.y) + "\narcher rotation: " + str(rotation_degrees.y))
	#print("archer_angle_viewing: " + str(rad_to_deg(archer_angle_viewing)))
	if archer_angle_viewing > PI:
		archer_angle_viewing -= 2*PI
	elif archer_angle_viewing < -PI:
		archer_angle_viewing += 2*PI
	#print("archer_angle_viewing: " + str(rad_to_deg(archer_angle_viewing)))
	
	var global_angle = Vector3(0,0,1).signed_angle_to(new_angle_vector, Vector3.UP)
	
	#print("global_angle: " + str(rad_to_deg(global_angle)))
	
	var how_much_to_rotate = global_angle - archer_angle_viewing
	#print("how_much_to_rotate: " + str(rad_to_deg(how_much_to_rotate)))
	var new_rotation = rotation.y+how_much_to_rotate
	#print("new_rotation: " + str(rad_to_deg(new_rotation)))
	
	
	var rotate_tween = get_tree().create_tween()
	rotate_tween.tween_property(self, "rotation:y", new_rotation, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	rotate_tween.play()
	await rotate_tween.finished
	
	
func shoot(_target):
	if walked_to_target:
		walked_to_target = false

	var _y = await aim()
	var _x = await _rotate_towards(_target.global_position, 0.6)
	var chance_roll = randf_range(0, 100)
	var arrow = $Arrow_Container._get_unused_object()
	if arrow == null: 
		return
	#print_debug(_target)
	
	arrow.global_position = $Shoot_Point.global_position
	arrow.target = _target
	arrow.get_node("DamageBox").damage = damage
	
	if chance_roll <= chance_for_perfect_shot:
		arrow.seek_target = true
	else:
		arrow.seek_target = false
	
	arrow.activate()
	#cooldown_timer.start()
	
	$AnimationPlayer.play("2H_Ranged_Shoot")
	$Attack.play()
	await $AnimationPlayer.animation_finished
	reload()

func reload():
	$AnimationPlayer.play("2H_Ranged_Reload")
	await $AnimationPlayer.animation_finished
	_on_cooldown_timer_timeout()
	#aim()

func aim():
	
	$AnimationPlayer.play("2H_Ranged_Aiming")
	await $AnimationPlayer.animation_finished

func attack() -> void:
	attack_rate_timer.stop()
	
	if current_target != null:
		if !(tower_node.base_tower.target_list.has(current_target)) and !(tower_node.base_tower.near_target_list.has(current_target)):
			current_target = await tower_node.find_target(global_position)
		if current_target == null:
			if is_walking == false:
				toggle_walking()
			wait_for_target()
			return
		var archer_quad = which_quadrant(global_position)
		var target_quad = which_quadrant(current_target.global_position)
		var quad_array = [archer_quad, target_quad]
		if walked_to_target or (archer_quad == target_quad):
			if is_walking:
				toggle_walking()
			shoot(current_target)
			attack_ready = false	
		elif tower_node.base_tower.near_target_list.has(current_target):
			if (quad_array.has(1) and (quad_array.has(4) or quad_array.has(2))) or (quad_array.has(3) and (quad_array.has(4) or quad_array.has(2))):
				if is_walking:
					toggle_walking()
				shoot(current_target)
				attack_ready = false
			else:
				var node_on_path = get_closest_path_node(current_target, get_parent().get_parent())
				ratio_walking_to = path_progress_ratios.get(node_on_path)
				walked_to_target = true
				if is_walking == false:
					toggle_walking()		
		else:
			var node_on_path = get_closest_path_node(current_target, get_parent().get_parent())
			ratio_walking_to = path_progress_ratios.get(node_on_path)
			walked_to_target = true
			if is_walking == false:
				toggle_walking()
	else:
		if is_walking == false:
			toggle_walking()
		
		wait_for_target()
	
func wait_for_target():
	$wait_timer.start()
		
func get_closest_path_node(target, path_node):
	var closest_path_node : Vector3 = Vector3.ZERO
	var closest_path_id : int = 0
	for i in path_node.curve.get_point_count():
		if closest_path_node == Vector3.ZERO:
			closest_path_node = path_node.curve.get_point_position(i)
			closest_path_id = i
		else:
			if target.global_position.distance_to(path_node.curve.get_point_position(i)) < target.global_position.distance_to(closest_path_node):
				closest_path_node = path_node.curve.get_point_position(i)
				closest_path_id = i
	if closest_path_id == 9:
		closest_path_id = 0
	return closest_path_id

func _on_attack_timer_timeout():
	attack_ready = true
	if current_target == null:
		current_target = tower_node.find_target(global_position)
		if current_target == null:
			attack_rate_timer.start()
			if is_walking == false:
				toggle_walking()
		else:
			if tower_node.base_tower.target_list.has(current_target):
				tower_node.base_tower.target_list.erase(current_target)
			if tower_node.base_tower.near_target_list.has(current_target):
				tower_node.base_tower.near_target_list.erase(current_target)
			attack()
	else:
		attack()
		


func _on_cooldown_timer_timeout():
	#if current target is still in the world, keep it, otherwise null it
	if tower_node.base_tower.target_list.has(current_target):
		pass
	elif tower_node.base_tower.near_target_list.has(current_target):
		pass
	else:
		current_target = null
		walked_to_target = false
	attack_rate_timer.start()
	
	if is_walking == false:
		toggle_walking()
		#print("Walking toggle is on at cooldown timer")
	


func _on_wait_timer_timeout():
	_on_attack_timer_timeout()

