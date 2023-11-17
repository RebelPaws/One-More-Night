extends CharacterBody3D

signal TargetReached
signal Enable
var dead_connected = false

@export var gravity : float
@export var move_speed : float
var ground_level = 2.5
@export var currency_worth : int

@onready var nav_agent = $NavigationAgent3D
@onready var game_info = get_parent().get_parent().get_parent().get_parent()

var active = false
var retreat_pos : Vector3
var can_attack = true

var is_target_reached = false

var target:
	set(val):
		target = val
		nav_agent.target_position = val.global_position

var state = "Idle"
var retreat = false

func _enable():
	set_physics_process(true)
	active = true
	can_attack = true
	
	is_target_reached = false
	emit_signal("Enable")

func move():
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * move_speed
	
	velocity = new_velocity
	
	global_position.y = ground_level
	look_at(nav_agent.get_next_path_position())
	move_and_slide()

func target_reached():
	is_target_reached = true
	
	if retreat:
		_disable()
		return
	
	emit_signal("TargetReached")

func _retreat():
	if not active: return
	
	retreat = true
	$Retreat_Position.global_position = retreat_pos
	target = $Retreat_Position
	$Attack_Timer.stop()
	_enable()

func _disable():
	set_physics_process(false)
	hide()
	active = false
	retreat = false
	global_position = Vector3(999999, 999999, 9999999)

