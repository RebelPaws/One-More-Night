extends Node3D

@export var arrow_tscn : PackedScene
@onready var area_to_shoot = get_node("Area3D/CollisionShape3D")
@onready var attack_rate_timer = get_node("Timer")
@onready var game_world = get_tree().get_root().get_node("Game")
@onready var tower_node = get_parent().get_parent().get_parent().get_parent()

var path_following : PathFollow3D

var speed : float = 0.0
var chance_for_perfect_shot = 20.0
var damage = 5.0
var attack_rate = 2.0
var ground_from_location : float
var collision_shape_points : PackedVector3Array

var target_list : Array = [] # This is for targets in range

var passed_target_list : Array[Array] = [] # This is for targets from the tower

var attack_ready = true
var is_prepared = false
var is_walking = false

var first_y_value : float = 0.0

var position_walking_to
var ratio_walking_to : float

var path_positions : Dictionary

var path_progress_ratios : Dictionary = {
	0: 0.0,	1: .09,	2: .23,	3: .36,
	4: .46,	5: .58,	6: .65,	7: .75,
	8: .86,	9: .99
}

#Setup the archer to get ready!
func prepare_archer():
	path_following = get_parent()
	var distance_to_ground : float = 0 - global_position.y
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
		first_y_value = new_shape.points[0].y
	#gott have 'em facing out
	rotation_degrees.y = -90
	
	path_following.set_progress_ratio(randf())
	
	is_prepared = true

func _physics_process(delta):
	if is_walking:
		var parent_progress = get_parent().get_progress()
		
		get_parent().set_progress(parent_progress + speed*delta)
		if snapped(get_parent().get_progress_ratio(), .01) == ratio_walking_to:
			toggle_walking()
			#rotation_degrees.y -= 90

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
		var prog_ratio = get_parent().get_progress_ratio()
		var distance_forward : float
		var distance_back : float
		if ratio_walking_to < prog_ratio:
			distance_forward = ratio_walking_to + 1 - prog_ratio
			distance_back = prog_ratio - ratio_walking_to
		elif ratio_walking_to == prog_ratio:
			return
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
	var target
	for i in target_list:
		if target == null:
			target = i
		elif global_position.distance_to(i.global_position) < global_position.distance_to(target.global_position):
			target = i
		else:
			pass
	
	attack_ready = false
	shoot(target)
	attack_rate_timer.start()
		

func _on_area_3d_body_entered(body):
	target_list.append(body)
	if attack_ready and target_list.size() == 1:
		attack()


func _on_area_3d_body_exited(body):
	target_list.erase(body)
	for i in passed_target_list:
		print(i)
		print(passed_target_list)
		if i.has(body):
			passed_target_list.erase(i)
	if target_list.size() == 0 and passed_target_list.size() > 0:
		get_passed_target()


func _on_timer_timeout():
	attack_ready = true
	if target_list.size() > 0:
		attack()
	elif passed_target_list.size() > 0:
		get_passed_target()

func get_passed_target():
	if is_walking:
		return
	else:
		var target_array : Array = []
		for i in passed_target_list:
			if target_array.size() == 0:
				target_array = i
			elif global_position.distance_to(i[0].global_position) < global_position.distance_to(target_array[0].global_position):
				target_array = i
		ratio_walking_to = target_array[1]
		toggle_walking()
		#passed_target_list.erase(target_array)
