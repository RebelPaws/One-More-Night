extends Control

var menu = "None"
var wait_time : float = 0.2
#var archer_tower_scene = preload("res://Towers/Attack/Archer/Archer_Tower.tscn")
#var shield_tower_scene = preload("res://Towers/Defense/Shield_Tower.tscn")
#var healer_tower_scene = preload("res://Towers/Support/Healer_Tower.tscn")
@onready var categories : Control = get_node("Categories")
@onready var attack_towers : Control = get_node("Attack_Towers")
@onready var defense_towers : Control = get_node("Defense_Towers")
@onready var support_towers : Control = get_node("Support_Towers")
@onready var game_info = get_tree().get_root().get_node("Game")
@onready var tower_node = game_info.get_node("Tower")

#signal game_speed_toggle


var menu_choices : Dictionary = {}

func _ready():
	menu_choices = {"Categories": categories, 
		"Attack": attack_towers,
		"Defense": defense_towers,
		"Support": support_towers}


func buy_tower(tower_name, tower_category, tower_scene_string):
	
	var time_mod : float
	if get_tree().paused == true:
		time_mod = 1
	else:
		time_mod = Engine.time_scale
		
	var tower_blocks = tower_node.get_node("Blocks")
	var tower_info = game_info.get_node("Towers").get_node(tower_name)
	
	var tower_anchor_point = tower_blocks.get_child(tower_blocks.get_child_count()-1).get_node("Anchor").global_position
	
	$Audio/TowerBuild.play()
	#var new_tower = tower_info.duplicate()
	var new_tower
	new_tower = load(tower_scene_string).instantiate()
	tower_blocks.add_child(new_tower)
	new_tower.global_position = tower_anchor_point
	var random_rotation = randi_range(0,359)
	match tower_name:
		"Archer":
			new_tower.set_rotation_degrees(Vector3(0,random_rotation,0))
			new_tower.spawn_archer()
			new_tower.attack()
			
		"Shield":
			#new_tower = shield_tower_scene.instantiate()
			new_tower._add_armor()
		#"Healer":
			#new_tower = healer_tower_scene.instantiate()
	
	
	#tower_blocks.add_child(new_tower)
	#new_tower.global_position = tower_anchor_point
	new_tower.show()
	
	game_info.modify_currency("Gold", -tower_info._get_cost("Build"))
	await get_tree().create_timer(time_mod*wait_time).timeout
	$Audio/TowerBuild.stop()
	
	

func _on_anim_current_animation_changed(name):
	$Anim.speed_scale = GameInfo.get_real_time()



