extends Control

var menu = "None"

func back():
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()
	
	match menu:
		"Categories":
			$Anim.play_backwards("Show_Categories")
			GameInfo.game_state = "Play"
		"Attack":
			$Anim.play_backwards("Show_Attack")
			menu = "Categories"
		"Defense":
			$Anim.play_backwards("Show_Defense")
			menu = "Categories"
		"Support":
			$Anim.play_backwards("Show_Support")
			menu = "Categories"

func show_categories():
	GameInfo.game_state = "Menu"
	
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()
	
	$Anim.play("Show_Categories")
	menu = "Categories"

func select_category(_new_category):
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()
	
	menu = _new_category
	
	$Anim.play("Show_" + _new_category)

func buy_tower(tower_name, tower_category):
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()
	
	var game_info = get_parent().get_parent()
	var tower_blocks = game_info.get_node("Tower/Blocks")
	var tower_info = Towers._get_tower_info(tower_name, tower_category) #[0 = scene, 1 = cost, 2 = damage]
	
	var tower_anchor_point = tower_blocks.get_child(tower_blocks.get_child_count()-1).get_node("Anchor").global_position
	
	if game_info.has_currency(tower_info[1][1]):
		$Audio/TowerBuild.play()
		var new_tower = tower_info[0].instantiate()
		tower_blocks.add_child(new_tower)
		new_tower.global_position = tower_anchor_point
		game_info.modify_currency(-tower_info[1][1])
		await get_tree().create_timer(0.2).timeout
		$Audio/TowerBuild.stop()
	else:
		$Audio/CantAfford.play()
		await get_tree().create_timer(0.2).timeout
		$Audio/CantAfford.stop()

func _process(delta):
	pass

func _on_anim_current_animation_changed(name):
	$Anim.speed_scale = GameInfo.get_real_time()
