extends Node3D

@export var arrow_tscn : PackedScene
@onready var area_to_shoot = get_node("Area3D/CollisionShape3D")
@onready var attack_rate_timer = get_node("attack_timer")
@onready var cooldown_timer = get_node("cooldown_timer")
@onready var game_world = get_tree().get_root().get_node("Game")
@onready var tower_node = get_parent().get_parent().get_parent().get_parent()

var path_following : PathFollow3D

var speed : float = 0.0
var chance_for_perfect_shot = 20.0
var damage = 5.0
var attack_rate = 1.5
var cooldown_rate = 0.5

#Possibly to be deleted
var ground_from_location : float
var collision_shape_points : PackedVector3Array
var target_list : Array = []
var first_y_value : float = 0.0
var position_walking_to
var path_positions : Dictionary

###

var PLAY_STATE : String = "DAY" #DAY or NIGHT depending on time

var attack_ready = false
var is_prepared = false
var is_walking = false

var ratio_walking_to : float
var current_target : Node3D = null

var path_progress_ratios : Dictionary = {
	0: 0.0,	1: .09,	2: .23,	3: .36,
	4: .46,	5: .58,	6: .65,	7: .75,
	8: .86#,	9: .99
}


func which_quadrant(current_position):
	var x_val = global_position.x
	var z_val = global_position.z
	
	if x_val < 45.07:
		if z_val >= 54.51:
			return 1
		else:
			return 4
	else:
		if z_val >= 54.51:
			return 2
		else:
			return 3
	


#Setup the archer to get ready!
func prepare_archer():
	path_following = get_parent()
	"""var distance_to_ground : float = 0 - global_position.y
	var distance_fluff : int = (global_position.y-4.96)/1.78
	for i : Vector3 in area_to_shoot.get_shape().points:
		if i.y == -40:
			i.y = distance_to_ground-(25 + (distance_fluff*10))
		else:
			i.y = distance_to_ground-(distance_fluff*10)
		
		collision_shape_points.append(i)
	
	#This creates a new CollisionShape based off of the original and how high off the ground they are
	var new_shape = ConvexPolygonShape3D.new()
	new_shape.set_points(collision_shape_points)
	area_to_shoot.set_shape(new_shape)
	if first_y_value == 0.0:
		first_y_value = new_shape.points[0].y"""
	#gott have 'em facing out
	#rotation_degrees.y = -90
	
	
	is_prepared = true
	toggle_walking()

func _physics_process(delta):
	if is_walking:
		var parent_progress = get_parent().get_progress()
		get_parent().set_progress(parent_progress + speed*delta)
		if PLAY_STATE == "DAY":
			pass
		elif PLAY_STATE == "NIGHT":
			if current_target == null:
				return
			else:
				if snapped(get_parent().get_progress_ratio(), .01) == ratio_walking_to:
					toggle_walking()
			

func update_stats():
	damage = tower_node.attack_damage[tower_node.level]
	attack_rate = tower_node.attack_rate[tower_node.level]
	attack_rate_timer.wait_time = attack_rate
	

func toggle_walking():
	if is_walking:
		rotation_degrees.y = -90
		speed = 0.0
		is_walking = false
	else:
		if PLAY_STATE == "DAY":
			speed = [0.2, -0.2].pick_random()
			if speed < 0:
				rotation_degrees.y = 180
			is_walking = true
		elif PLAY_STATE == "NIGHT":
			if current_target == null:
				speed = [0.2, -0.2].pick_random()
				is_walking = true
			else:
				var prog_ratio = get_parent().get_progress_ratio()
				var distance_forward : float
				var distance_back : float
				if ratio_walking_to < prog_ratio:
					distance_forward = ratio_walking_to + 1 - prog_ratio
					distance_back = prog_ratio - ratio_walking_to
				else:
					distance_forward = ratio_walking_to - prog_ratio
					distance_back = prog_ratio + 1 - ratio_walking_to
				
				if distance_forward < distance_back:
					speed = 0.2
					rotation_degrees.y += 90
				else:
					speed = -0.2
					rotation_degrees.y -= 90
				is_walking = true
	
func shoot(_target):
	var arrow = $Arrow_Container._get_unused_object()
	if arrow == null: 
		return
	#print_debug(_target)
	
	var chance_roll = randf_range(0, 100)
	
	arrow.global_position = $Shoot_Point.global_position
	arrow.target = _target
	arrow.get_node("DamageBox").damage = damage
	
	if chance_roll <= chance_for_perfect_shot:
		arrow.seek_target = true
	else:
		arrow.seek_target = false
	
	arrow.activate()
	
	$AnimationPlayer.play("2H_Ranged_Shoot")
	$Attack.play()
	await $AnimationPlayer.animation_finished
	reload()

func reload():
	$AnimationPlayer.play("2H_Ranged_Reload")
	await $AnimationPlayer.animation_finished
	aim()

func aim():
	$AnimationPlayer.play("2H_Ranged_Aiming")

func attack():
	attack_rate_timer.stop()
	if current_target != null:
		var archer_quad = which_quadrant(global_position)
		var target_quad = which_quadrant(current_target.global_position)
		if target_quad == archer_quad:
			if is_walking:
				toggle_walking()
			var aim_tween = get_tree().create_tween()
			var new_rotation = global_position.angle_to(current_target.global_position)
			
			aim_tween.tween_property(self, "rotation", new_rotation, 0.5)
			aim_tween.play()
			await get_tree().create_timer(0.5).timeout
			shoot(current_target)
			attack_ready = false
			cooldown_timer.start()
		else:
			var node_on_path = get_closest_path_node(current_target, get_parent().get_parent())
			ratio_walking_to = path_progress_ratios.get(node_on_path)
			if is_walking == false:
				toggle_walking()
	else:
		if is_walking == false:
			toggle_walking()
		await get_tree().create_timer(0.5).timeout
		_on_attack_timer_timeout()
	
	#attack_ready = false
	#shoot(target)
	#attack_rate_timer.start()
		
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
func _on_area_3d_body_entered(body):
	#target_list.append(body)
	#if attack_ready:
	#	attack()
	pass


func _on_area_3d_body_exited(body):
	#target_list.erase(body)
	pass


func _on_attack_timer_timeout():
	attack_ready = true
	if current_target == null:
		current_target = tower_node.find_target(global_position)
		if current_target == null:
			attack_rate_timer.start()
			if is_walking == false:
				toggle_walking()
		else:
			attack()
	else:
		attack()
		


func _on_cooldown_timer_timeout():
	#if current target is still in the world, keep it, otherwise null it
	if tower_node.base_tower.target_list.has(current_target):
		pass
	else:
		current_target = null
	attack_rate_timer.start()
	
	if is_walking == false:
		toggle_walking()
	
