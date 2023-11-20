extends Control

var in_view = false


func _on_game_speed_pause_menu_toggle():
	var tween = get_tree().create_tween()
	var new_position = Vector2.ZERO
	
	if in_view:
		in_view = false
		new_position = Vector2(0,1080)
	else:
		in_view = true
		new_position = Vector2(0,600)
	
	tween.tween_property(self, "position", new_position, 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.play()
	await get_tree().create_timer(0.2).timeout
	#if in_view == false:
		#get_tree().paused = false
