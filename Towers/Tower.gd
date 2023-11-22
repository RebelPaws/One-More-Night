extends Node3D

#not onready node variables
@onready var hit_box = get_node("Health_Manager/HitBox")
@onready var health_points_bar = get_tree().get_root().get_node("Game/UI/Currency_UI/Health_Label")
var health : Node3D
var armor : Node3D
var tower_blocks : Node3D
#hit_box = get_node("Health_Manager/HitBox")
#health = get_node("Health")
#armor = get_node("Armor")
#tower_blocks = get_node("Blocks")

#This is the tower controller
func _ready():
	hit_box.set_collision_mask(8)

#This updates the health visual of the tower
func update_health(_health):
	if is_instance_valid(health):
		health.get_node("Count").text = str(_health)
		health_points_bar.text = str(_health)

#This updates the armor visual of the tower
func update_armor(_armor):
	if is_instance_valid(armor):
		armor.get_node("Count").text = str(_armor)

#This gets the last tower blocks available aka the top of the tower
func get_last_tower():
	var last_index = tower_blocks.get_child_count()-1
	return tower_blocks.get_child(last_index)
	
func setup():
	
	health = get_node("Health")
	armor = get_node("Armor")
	tower_blocks = get_node("Blocks")
	update_health(100)
	update_armor(0)

func show_health_armor():
	health.show()
	armor.show()
	
