extends Control

var in_view = false
var time_mod : float
var wait_time : float = 0.2


func _on_game_speed_pause_menu_toggle():
	if Engine.time_scale != 0:
		time_mod = Engine.time_scale * wait_time
	else:
		time_mod = wait_time
	var tween = get_tree().create_tween()
	var new_position = Vector2.ZERO
	var new_modulation = Color8(255,255,255,0)
	
	if in_view:
		in_view = false
		new_position = Vector2(0,1080)	
	else:
		in_view = true
		global_position = Vector2(0,0)
		new_modulation = Color8(255,255,255,255)
		
	
	tween.tween_property(self, "modulate", new_modulation, time_mod).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.play()
	await get_tree().create_timer(time_mod).timeout
	if in_view == false:
		global_position = new_position
	#if in_view == false:
		#get_tree().paused = false
