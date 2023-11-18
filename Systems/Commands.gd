extends Node

var cheat_mode = false
var cheats_input = []

func get_root():
	return get_tree().current_scene


func _input(event):
	var activate_cheats = Input.is_action_pressed("Cheat_Key_1") and Input.is_action_pressed("Cheat_Key_2") and not cheat_mode
	
	if cheat_mode:
		if Input.is_action_just_pressed("Cheat_Input_1"): cheats_input.append(1)
		if Input.is_action_just_pressed("Cheat_Input_2"): cheats_input.append(2)
		if Input.is_action_just_pressed("Cheat_Input_3"): cheats_input.append(3)
		if Input.is_action_just_pressed("Cheat_Input_4"): cheats_input.append(4)
	
	match cheats_input:
		[1, 1, 1, 1]: #Gold Cheat
			print("Money cheat")
			get_root().modify_currency("Gold", 1000)
			cheat_code_end()
	
	if activate_cheats:
		cheat_mode = true
		get_tree().create_timer(5).connect("timeout", cheat_code_end)

func cheat_code_end():
	cheat_mode = false
	cheats_input.clear()
