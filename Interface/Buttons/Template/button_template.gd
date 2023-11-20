extends TextureButton

class_name ButtonTemplate

@onready var buttonpress_sound = get_node("ButtonPress")
@onready var timer = get_node("Timer")
@onready var label = get_node("Label")

var wait_time : float = 0.2

signal function_trigger

func _on_pressed():
	var time_mod = Engine.time_scale
	buttonpress_sound.play()
	if get_tree().paused == true:
		timer.start(wait_time)
	else:
		timer.start(time_mod*wait_time)
	
func _on_timer_timeout():
	buttonpress_sound.stop()
	emit_signal("function_trigger")
