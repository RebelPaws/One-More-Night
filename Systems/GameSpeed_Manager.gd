extends Control

var in_view : bool = false

#This controls the game speed interface

var night_skip_to = 8.0 #This is the position to where the skip to night should skip to

signal pause_menu_toggle

#This sets the skip to night time would be
func set_night_skip_pos(_pos):
	night_skip_to = _pos


func _unhandled_key_input(event):
	if event.is_action_released("ui_cancel"):
		if get_tree().paused == false:
			_set_speed(0)
		else:
			_set_speed(1)

#This sets the game speed
func _set_speed(_speed):
	if _speed > 0: #If the speed is greater than 0
		if get_tree().paused:
			emit_signal("pause_menu_toggle")
			#get_parent().get_node("Pause_Menu").play_backwards("Toggle")
			get_tree().paused = false #We ensure the game isn't paused anymore
		Engine.time_scale = _speed #Then we set the time scale
		self.show()
		get_parent().get_node("Build").show()
	else: #If the speed equals 0
		self.hide()
		get_parent().get_node("Build").hide()
		get_tree().paused = true #We pause the game
		#get_parent().get_node("Pause_Menu/Anim").play("Toggle") #Open the pause menu 
		emit_signal("pause_menu_toggle")
		get_parent().get_node("Pause_Menu/Resume").grab_focus() #Grab focus so controllers can navigate

#This handles skipping the time to night
func skip_to_night():
	var day_animator = get_parent().get_parent().get_node("Sky/Day_Cycle") #We grab the sky animator
	day_animator.seek(night_skip_to) #Then we seek to the night skip position
	toggle_skip_night(false)

#This toggles the ability to skip to night
func toggle_skip_night(value):
	match value:
		true:
			$Speeds/Skip_to_Night.set_deferred("disabled", false)
			$Speeds/Skip_to_Night.show()
		false:
			$Speeds/Skip_to_Night.set_deferred("disabled", true)
			$Speeds/Skip_to_Night.hide()



func _on_build_game_speed_toggle():
	var tween = get_tree().create_tween()
	var new_position = Vector2.ZERO
	
	if in_view:
		in_view = false
		new_position = Vector2(1393,-120)
	else:
		in_view = true
		new_position = Vector2(1393,20)
	
	tween.tween_property(self, "position", new_position, 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.play()
