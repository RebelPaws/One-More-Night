extends CharacterBody3D

@export var gravity : float
@export var move_speed : float
@export var currency_worth : int

@onready var nav_agent = $NavigationAgent3D
@onready var game_info = get_parent().get_parent().get_parent().get_parent()

var active = false
var retreat_pos : Vector3

var target:
	set(val):
		target = val
		nav_agent.target_position = val.global_position

var state = "Idle"
var retreat = false

func _ready():
	$NavigationAgent3D.connect("target_reached", target_reached)
	set_physics_process(false)
	
	get_parent().get_parent().get_parent().connect("Retreat", _retreat)
	set_state("Run")

func _enable():
	set_physics_process(true)
	active = true
	state = "Idle"

func set_state(_new_state):
	if state == _new_state or not active: return
	
	match _new_state:
		"Idle":
			$Anim.play("Idle")
		"Run":
			$Anim.play("Run")
		
		"Attack":
			pass
		
		"Hurt":
			set_physics_process(false)
			$Sounds/Hurt_Sound.play()
			$Anim.play("Hurt")
			await get_tree().create_timer(0.5).timeout
			set_state("Idle")
			return
		
		"Dead":
			active = false
			set_physics_process(false)
			$Sounds/Death_Sound.play()
			$Anim.play("Death")
			game_info.modify_currency(currency_worth)
			await $Anim.animation_finished
			await get_tree().create_timer(0.5).timeout
			hide()
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
	
	if velocity.x or velocity.z != 0:
		if state == "Idle":
			set_state("Run")
	if velocity.x or velocity.z == 0:
		if state == "Run":
			set_state("Idle")
	
	move_and_slide()

func target_reached():
	set_physics_process(false)
	
	if retreat:
		active = false
		hide()
		global_position.x = 999999
		return
	
	$Attack_Timer.start()

func Attack():
	set_state("Attack")
	$Sounds/Attack_Sound.play()
	$Anim.play("Attack")
	$DamageBox.toggle_collider()
	await get_tree().create_timer(0.5).timeout
	$DamageBox.toggle_collider()
	await $Anim.animation_finished
	$Anim.play("Idle")

func _retreat():
	if not active: return
	
	retreat = true
	$Retreat_Position.global_position = retreat_pos
	target = $Retreat_Position
	$Attack_Timer.stop()
	_enable()
