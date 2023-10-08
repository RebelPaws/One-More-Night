extends Node3D

@export var move_speed : float
@export var seek_target : bool
var target
var move_to = Vector3()

var active = false

func _ready():
	set_process(false)

func activate():
	if target == null: return
	
	show()
	set_process(true)
	active = true
	look_at(target.global_position)

func _process(delta):
	if target.active == false or target == null or self == null: 
		disable()
		return
	
	var dir = (self.global_position - target.global_position).normalized()
	
	if seek_target:
		move_to = (dir * move_speed)
		look_at(target.global_position)
	else:
		if move_to == Vector3():
			move_to = (dir * move_speed) 
	
	global_position -= move_to * delta

func arrow_hit(area):
	$Hit.play()
	disable()

func disable():
	hide()
	set_process(false)
	active = false
	target = null
	move_to = Vector3()

func out_of_bounds():
	arrow_hit(null)
