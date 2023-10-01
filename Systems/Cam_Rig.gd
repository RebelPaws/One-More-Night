extends Node3D

@export var vertical_speed : float ##This is how fast the camera can move up and down the tower
@export var rotation_speed = {"Y-Axis": 0.0, "X-Axis": 0.0, "Z-Axis": 0.0} ##This controls the speed for each axis rotations.

func _process(delta):
	control_process(delta) #Run the controls

#This handles the controls for the camera
func control_process(delta):
	#These are the variable control shortcuts
	var rotate_y_clock = Input.is_action_pressed("Rotate_Y_C")
	var rotate_y_counterclock = Input.is_action_pressed("Rotate_Y_CC")
	
	var move_up = Input.is_action_pressed("Move_Up")
	var move_down = Input.is_action_pressed("Move_Down")
	
	#This checks for rotation input for the Y-Axis
	if rotate_y_clock:
		rotation.y += rotation_speed["Y-Axis"] * delta
	if rotate_y_counterclock:
		rotation.y -= rotation_speed["Y-Axis"] * delta
	
	var ceiling = get_parent().get_node("Blocks").get_child(get_parent().get_node("Blocks").get_child_count()-1).get_node("Anchor").global_position.y
	if move_up:
		if position.y <= ceiling:
			position.y += vertical_speed * delta
	if move_down:
		if position.y > 0:
			position.y -= vertical_speed * delta

