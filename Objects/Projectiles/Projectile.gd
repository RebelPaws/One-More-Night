extends Node3D

@export var move_speed : float
@export var seek_target : bool
var target
var move_to = Vector3()

var active = false

func _ready():
	set_process(false)

func activate():
	show()
	set_process(true)
	active = true
	look_at(target.global_position)

func _process(delta):
	if target == null: 
		arrow_hit(null)
		return
	
	var dir = (target.global_position - global_position).normalized()
	
	if seek_target:
		move_to = (dir * move_speed) * delta
	else:
		if move_to == Vector3():
			move_to = (dir * move_speed) * delta
	
	global_position += move_to


func arrow_hit(area):
	hide()
	set_process(false)
	active = false

func out_of_bounds():
	$VisibleOnScreenNotifier3D/Timer.start()
