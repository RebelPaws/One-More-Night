extends Node

signal OpenLense
signal CloseLense

var lense_active = false

func _input(event):
	var toggle = Input.is_action_just_pressed("Toggle_Lense")
	
	if toggle:
		match lense_active:
			true:
				lense_active = false
				emit_signal("CloseLense")
				return
			false:
				lense_active = true
				emit_signal("OpenLense")
				return


