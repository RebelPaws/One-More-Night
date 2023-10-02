extends Control

var menu = "None"

func back():
	$ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$ButtonPress.stop()
	
	match menu:
		"Categories":
			$Anim.play_backwards("Show_Categories")
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
	$ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$ButtonPress.stop()
	
	$Anim.play("Show_Categories")
	menu = "Categories"

func select_category(_new_category):
	$ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$ButtonPress.stop()
	
	menu = _new_category
	
	$Anim.play("Show_" + _new_category)

func buy_tower(tower_name):
	var game_info = get_parent().get_parent()
	var tower_blocks = game_info.get_node("Tower/Blocks")
	var tower = $Towers.get_node(menu).get_node(tower_name)
	
	var tower_anchor_point = tower_blocks.get_child(tower_blocks.get_child_count()-1).get_node("Anchor").global_position
	
	if game_info.has_currency(tower.cost):
		$TowerBuild.play()
		var new_tower = tower.scene.instantiate()
		tower_blocks.add_child(new_tower)
		new_tower.global_position = tower_anchor_point
		game_info.modify_currency(-tower.cost)
		await get_tree().create_timer(0.2).timeout
		$TowerBuild.stop()
	else:
		$CantAfford.play()
		await get_tree().create_timer(0.2).timeout
		$CantAfford.stop()
