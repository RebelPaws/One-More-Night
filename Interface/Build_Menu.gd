extends Control

var menu = "None"

func back():
	$GeneralButtonPress_Sound.play()
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
	$GeneralButtonPress_Sound.play()
	$Anim.play("Show_Categories")
	menu = "Categories"

func select_category(_new_category):
	$GeneralButtonPress_Sound.play()
	menu = _new_category
	
	$Anim.play("Show_" + _new_category)

func buy_tower(tower_name):
	var game_info = get_parent().get_parent()
	var tower_blocks = game_info.get_node("Tower/Blocks")
	var tower = $Towers.get_node(menu).get_node(tower_name)
	
	var tower_anchor_point = tower_blocks.get_child(tower_blocks.get_child_count()-1).get_node("Anchor").global_position
	
	if game_info.has_currency(tower.cost):
		var new_tower = tower.scene.instantiate()
		$TowerBuild_Sound.play()
		tower_blocks.add_child(new_tower)
		new_tower.global_position = tower_anchor_point
		game_info.modify_currency(-tower.cost)
	else:
		$CantAfford_Sound.play()
