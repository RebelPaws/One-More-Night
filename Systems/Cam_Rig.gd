extends Node3D

@export var vertical_speed : float ##This is how fast the camera can move up and down the tower
@export var rotation_speed = {"Y-Axis": 0.0, "X-Axis": 0.0, "Z-Axis": 0.0} ##This controls the speed for each axis rotations.

var zoom_restraints = [5, 30] #This restricts the zoom from going too far in or out [Zoom_In, Zoom_Out]
var lock_zoom = false #This makes it so the zoom can't be changed when true
@export var zoom_speed : float #This is how fast the zoom goes in and out

var target: #This is the target being viewed
	set(val): #When a new target is set, allow the camera to follow to the new target
		target = val
		can_follow = true


@export var follow_speed = 5.0 #This is how fast the cam can move to a new target
var can_follow = true #This allows the cam to follow a target

@export var tower_blocks_path : NodePath #This is the path to the tower blocks containter node
@onready var tower_blocks = get_node(tower_blocks_path) #This gets the tower blocks container node


func _process(delta):
	control_process(delta) #Run the controls
	
	#If there is a target
	if target != null:
		#If the target position isn't equal to the current position
		if target.global_position != global_position and can_follow:
			var direction = target.global_position - global_position #We get the direction to the target
			var velocity = direction * follow_speed #Then get the velocity the cam should be moving at
			global_position += velocity * delta #Then we apply the velocity to the cam's position
			
			#If the cam is in range of the target we snap the cam to the target and turn off follow mode
			if global_position.distance_to(target.global_position) < 0.5:
				global_position = target.global_position
				can_follow = false

#This handles the controls for the camera
func control_process(delta):
	#These are the variable control shortcuts
	var rotate_y_clock = Input.is_action_pressed("Rotate_Y_C")
	var rotate_y_counterclock = Input.is_action_pressed("Rotate_Y_CC")
	
	var move_up = Input.is_action_pressed("Move_Up") and target.name == "Tower"
	var move_down = Input.is_action_pressed("Move_Down") and target.name == "Tower"
	
	var zoom_in = Input.is_action_pressed("Zoom_In") and $X/Z/Camera3D.position.z > zoom_restraints[0] and not lock_zoom
	var zoom_out = Input.is_action_pressed("Zoom_Out") and $X/Z/Camera3D.position.z < zoom_restraints[1] and not lock_zoom
	
	#This checks for rotation input for the Y-Axis
	if rotate_y_clock:
		rotation.y += (rotation_speed["Y-Axis"] * delta) * GameInfo.get_real_time()
	if rotate_y_counterclock:
		rotation.y -= (rotation_speed["Y-Axis"] * delta) * GameInfo.get_real_time()
	
	#These allow the camera to move vertically up and down
	var ceiling = tower_blocks.get_child(tower_blocks.get_child_count()-1).get_node("Anchor").global_position.y
	
	if move_up:
		if global_position.y <= ceiling:
			global_position.y += (vertical_speed * delta) * GameInfo.get_real_time()
	if move_down:
		if global_position.y > 0:
			global_position.y -= (vertical_speed * delta) * GameInfo.get_real_time()
	
	#These are the zoom controls
	if zoom_in:
		$X/Z/Camera3D.position.z -= zoom_speed
	if zoom_out:
		$X/Z/Camera3D.position.z += zoom_speed

#This is an auto-zoom feature
func zoom_to(new_zoom):
	#We tween the current zoom to the zoom we want
	var tween = create_tween()
	tween.tween_property($X/Z/Camera3D, "position", Vector3($X/Z/Camera3D.position.x, $X/Z/Camera3D.position.y, new_zoom), 0.5)

#This is an auto-zoom feature
func rotate_to(new_x, new_y, new_z):
	#We tween the current zoom to the zoom we want
	var tween = create_tween()
	
	tween.tween_property($X, "rotation", Vector3(new_x, 0, 0), 0.6)
	tween.tween_property(self, "rotation", Vector3(0, new_y, 0), 0.6)

