extends CharacterBody3D

@export var gravity : float
@export var move_speed : float
@export var currency_worth : int

@onready var nav_agent = $NavigationAgent3D
@onready var game_info = get_parent().get_parent().get_parent().get_parent()

var active = false

var target:
	set(val):
		target = val
		nav_agent.target_position = val.global_position

var state = "Idle"

func _ready():
	$NavigationAgent3D.connect("target_reached", target_reached)
	set_physics_process(false)

func _enable():
	set_physics_process(true)
	active = true
	state = "Idle"

func set_state(_new_state):
	if state == _new_state or not active: return
	
	match _new_state:
		"Idle":
			pass
		"Run":
			pass
		
		"Hurt":
			pass
		"Dead":
			game_info.modify_currency(currency_worth)
			hide()
			active = false
			global_position.x = 999999
	
	state = _new_state

func _physics_process(delta):
	move()

func move():
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * move_speed
	
	velocity = new_velocity
	look_at(nav_agent.get_next_path_position())
	
	move_and_slide()

func target_reached():
	set_physics_process(false)
	$Attack_Timer.start()

func Attack():
	$DamageBox.toggle_collider()
	await get_tree().create_timer(0.5).timeout
	$DamageBox.toggle_collider()


