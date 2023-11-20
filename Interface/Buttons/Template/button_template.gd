extends TextureButton

class_name ButtonTemplate

@onready var buttonpress_sound = get_node("ButtonPress")
@onready var timer = get_node("Timer")
@onready var label = get_node("Label")

signal function_trigger

func _on_pressed():
	buttonpress_sound.play()
	timer.start()
	
func _on_timer_timeout():
	buttonpress_sound.stop()
	emit_signal("function_trigger")
