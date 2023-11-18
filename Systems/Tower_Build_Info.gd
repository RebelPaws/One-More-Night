extends Button

#This sets up the info for the build menu tower block buttons

@onready var game_root = get_tree().get_root().get_node("Game")

@export var tower_id : String ##The name or id of the tower block
@export var tower_category : String ##The category the tower is in (Attack, Defense, Support)
@export var tower_scene_string : String ##The scene to instantiate
#@export var tower_cost : int

signal buy_tower_clicked(id_name : String, category : String, scene_string : String)

func _ready():
	update_info()

#This handles updating the info
func update_info():
	var tower = game_root.get_node("Towers").get_node(tower_id)
	if tower == null: return
	
	$Cost.text = str(-tower._get_cost("Build")) #Set the cost label
	
	#Then we set the category special stat
	match tower_category:
		"Attack":
			get_node("Damage").text = str(tower.attack_damage[tower.level])
		"Defense":
			get_node("Armor").text = str(tower.armor[tower.level])
		"Support":
			get_node("Heal").text = str(tower.healing[tower.level])


func _on_pressed():
	emit_signal("buy_tower_clicked", tower_id, tower_category, tower_scene_string)
