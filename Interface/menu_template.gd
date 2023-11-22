extends Control

class_name MenuTemplate

@export var position_off_screen : Vector2
@export var position_on_screen : Vector2

var wait_time : float = 0.2
var in_view : bool = false

func change_menu(old_menu : Control, new_menu : Control):
	var time_mod : float
	if get_tree().paused == true:
		time_mod = 1
	else:
		time_mod = Engine.time_scale
	var tween_old_menu = get_tree().create_tween()
	var tween_new_menu = get_tree().create_tween()
	
	tween_old_menu.tween_property(old_menu, "position", old_menu.position_off_screen, time_mod*wait_time).set_trans(Tween.TRANS_CUBIC)
	tween_new_menu.tween_property(new_menu, "position", new_menu.position_on_screen, time_mod*wait_time).set_trans(Tween.TRANS_CUBIC)
	tween_old_menu.play()
	new_menu.show()
	await get_tree().create_timer(time_mod*wait_time).timeout
	old_menu.hide()
	tween_new_menu.play()
	

	
func toggle_menu():
	var time_mod : float
	if get_tree().paused == true:
		time_mod = 1
	else:
		time_mod = Engine.time_scale
	var tween = get_tree().create_tween()
	if in_view:
		tween.tween_property(self, "position", position_off_screen, time_mod*.6).set_trans(Tween.TRANS_SPRING)
		in_view = false
	else:
		tween.tween_property(self, "position", position_on_screen, time_mod*.6).set_trans(Tween.TRANS_CUBIC)
		in_view = true
	tween.play()



