extends ButtonTemplate

@export var menu_leaving : Control
@export var menu_entering : Control

signal leave_menu(menu_name : String)
	
func _on_timer_timeout():
	buttonpress_sound.stop()
	emit_signal("leave_menu",menu_leaving, menu_entering)
