extends ButtonTemplate

@export var menu_leaving : String

signal leave_menu(menu_name : String)

func _on_pressed():
	buttonpress_sound.play()
	timer.start()
	
func _on_timer_timeout():
	buttonpress_sound.stop()
	emit_signal("leave_menu",menu_leaving)
