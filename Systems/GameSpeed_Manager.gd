extends Control

#This controls the game speed interface

var night_skip_to = 8.0 #This is the position to where the skip to night should skip to

#This sets the skip to night time would be
func set_night_skip_pos(_pos):
	night_skip_to = _pos

#This sets the game speed
func _set_speed(_speed):
	if _speed > 0: #If the speed is greater than 0
		if get_tree().paused:
			get_parent().get_node("Pause_Menu/Anim").play_backwards("Toggle")
			get_tree().paused = false #We ensure the game isn't paused anymore
		Engine.time_scale = _speed #Then we set the time scale
	else: #If the speed equals 0
		get_tree().paused = true #We pause the game
		get_parent().get_node("Pause_Menu/Anim").play("Toggle") #Open the pause menu 
		get_parent().get_node("Pause_Menu/Options/Resume").grab_focus() #Grab focus so controllers can navigate

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
