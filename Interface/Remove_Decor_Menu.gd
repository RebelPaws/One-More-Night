extends Control

var target
var target_type = ""

func enable():
	play_button_sound()
	GameInfo.game_state = "Menu"
	$Anim.play("Toggle")

func disable():
	GameInfo.game_state = "Play"
	$Anim.play_backwards("Toggle")

func update_info(_item, _item_name, _cost):
	$Header.text = "Remove " + _item_name + "?"
	$Remove/Cost.text = str(_cost)
	
	target = _item
	target_type = _item_name
	
	enable()

func remove_object():
	var game_root = get_parent().get_parent()
	var cost_to_remove = int($Remove/Cost.text)
	
	if game_root.has_currency(cost_to_remove):
		
		game_root.modify_currency(-cost_to_remove)
		disable()
		if "Tree" in target_type:
			for chop in 3:
				$Audio/Cut_Tree.play()
				await get_tree().create_timer(0.3).timeout
		
		target.call_deferred("free")

func play_button_sound():
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()

func cancel():
	play_button_sound()
	disable()

func _on_anim_current_animation_changed(name):
	$Anim.speed_scale = GameInfo.get_real_time()
