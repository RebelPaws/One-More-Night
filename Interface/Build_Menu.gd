extends Control

var menu = "None"
#var archer_tower_scene = preload("res://Towers/Attack/Archer/Archer_Tower.tscn")
#var shield_tower_scene = preload("res://Towers/Defense/Shield_Tower.tscn")
#var healer_tower_scene = preload("res://Towers/Support/Healer_Tower.tscn")
@onready var categories : Control = get_node("Categories")
@onready var attack_towers : Control = get_node("Attack_Towers")
@onready var defense_towers : Control = get_node("Defense_Towers")
@onready var support_towers : Control = get_node("Support_Towers")

#signal game_speed_toggle


var menu_choices : Dictionary = {}

func _ready():
	menu_choices = {"Categories": categories, 
		"Attack": attack_towers,
		"Defense": defense_towers,
		"Support": support_towers}


func back(menu_leaving):
	var menu_left = menu_choices[menu_leaving]
	var tween_leaving = get_tree().create_tween()
	tween_leaving.tween_property(menu_left, "position", Vector2(0,1080), 0.2).set_trans(Tween.TRANS_CUBIC)
	tween_leaving.play()
	await get_tree().create_timer(0.2).timeout
	menu_left.hide()
	var tween_coming = get_tree().create_tween()
	var menu_entering : Control
	if menu_leaving == "Categories":
		#get_parent().get_node("Game_Speed/Anim").play("Toggle")
		GameInfo.game_state = "Play"
		menu = "None"
		menu_entering = get_node("Build_Control")
		#emit_signal("game_speed_toggle")
	else:		
		menu_entering = categories
		menu = "Categories"
	
	menu_entering.show()
	tween_coming.tween_property(menu_entering, "position", Vector2(0,780), 0.2).set_trans(Tween.TRANS_CUBIC)
	tween_coming.play()
	

func select_category(_new_category):
	var old_category = null
	if _new_category == "Categories":
		GameInfo.game_state = "Menu"
		old_category = get_node("Build_Control")
		#emit_signal("game_speed_toggle")
	else:
		old_category = categories
	
	menu = _new_category
	var menu_coming = menu_choices[_new_category]
	var tween_leaving = get_tree().create_tween()
	tween_leaving.tween_property(old_category, "position", Vector2(0,1080), 0.2).set_trans(Tween.TRANS_CUBIC)
	var tween_coming = get_tree().create_tween()
	tween_coming.tween_property(menu_coming, "position", Vector2(0,780), 0.2).set_trans(Tween.TRANS_CUBIC)
	tween_leaving.play()
	await get_tree().create_timer(0.2).timeout
	tween_coming.play()
	old_category.hide()
	menu_coming.show()
	
	
	#menu = _new_category
	#$Anim.play("Show_" + _new_category)
"""
func xx_show_categories():
	GameInfo.game_state = "Menu"
	
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()
	
	get_parent().get_node("Game_Speed/Anim").play_backwards("Toggle")
	
	$Anim.play("Show_Categories")
	menu = "Categories"



func xx_back():
	#$Audio/ButtonPress.play()
	#await get_tree().create_timer(0.2).timeout
	#$Audio/ButtonPress.stop()
	
	match menu:
		"Categories":
			$Anim.play_backwards("Show_Categories")
			get_parent().get_node("Game_Speed/Anim").play("Toggle")
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

func xx_show_categories():
	GameInfo.game_state = "Menu"
	
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()
	
	get_parent().get_node("Game_Speed/Anim").play_backwards("Toggle")
	
	$Anim.play("Show_Categories")
	menu = "Categories"

func xx_bad_select_category(_new_category):
	$Audio/ButtonPress.play()
	await get_tree().create_timer(0.2).timeout
	$Audio/ButtonPress.stop()
	
	menu = _new_category
	
	$Anim.play("Show_" + _new_category)

"""

func buy_tower(tower_name, tower_category, tower_scene_string):
	
	var game_info = get_parent().get_parent()
	var tower_blocks = game_info.get_node("Tower/Blocks")
	var tower_info = get_parent().get_parent().get_node("Towers").get_node(tower_name)
	
	var tower_anchor_point = tower_blocks.get_child(tower_blocks.get_child_count()-1).get_node("Anchor").global_position
	
	if game_info.has_currency("Gold", tower_info._get_cost("Build")):
		$Audio/TowerBuild.play()
		
		#var new_tower = tower_info.duplicate()
		var new_tower
		new_tower = load(tower_scene_string).instantiate()
		tower_blocks.add_child(new_tower)
		new_tower.global_position = tower_anchor_point
		var random_rotation = randi_range(0,359)
		match tower_name:
			"Archer":
				new_tower.attack()
				new_tower.set_rotation_degrees(Vector3(0,random_rotation,0))
			"Shield":
				#new_tower = shield_tower_scene.instantiate()
				new_tower._add_armor()
			#"Healer":
				#new_tower = healer_tower_scene.instantiate()
		
		
		#tower_blocks.add_child(new_tower)
		#new_tower.global_position = tower_anchor_point
		new_tower.show()
		
		game_info.modify_currency("Gold", -tower_info._get_cost("Build"))
		await get_tree().create_timer(0.2).timeout
		$Audio/TowerBuild.stop()
	else:
		$Audio/CantAfford.play()
		await get_tree().create_timer(0.2).timeout
		$Audio/CantAfford.stop()

func _on_anim_current_animation_changed(name):
	$Anim.speed_scale = GameInfo.get_real_time()



