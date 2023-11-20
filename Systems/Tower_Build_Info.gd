extends ButtonTemplate

#This sets up the info for the build menu tower block buttons

@onready var game_info = get_tree().get_root().get_node("Game")

@export var tower_id : String ##The name or id of the tower block
@export var tower_category : String ##The category the tower is in (Attack, Defense, Support)
@export var tower_scene_string : String ##The scene to instantiate
#@export var tower_cost : int
@onready var cost_label = get_node("Cost")
@onready var cant_afford_sound = game_info.get_node("UI/Build/Audio/CantAfford")



signal buy_tower_clicked(id_name : String, category : String, scene_string : String)

func _ready():
	game_info.connect("GoldChanged", Callable(self, "_toggle_button"))
	update_info()

#This handles updating the info
func update_info():
	var tower = game_info.get_node("Towers").get_node(tower_id)
	if tower == null: return
	
	cost_label.text = str(-tower._get_cost("Build")) #Set the cost label
	
	#Then we set the category special stat
	match tower_category:
		"Attack":
			get_node("Damage").text = str(tower.attack_damage[tower.level])
		"Defense":
			get_node("Armor").text = str(tower.armor[tower.level])
		"Support":
			get_node("Heal").text = str(tower.healing[tower.level])


func _on_function_trigger():
	if game_info.has_currency("Gold", game_info.get_node("Towers").get_node(tower_id)._get_cost("Build")):
		emit_signal("buy_tower_clicked", tower_id, tower_category, tower_scene_string)
	else:
		cant_afford_sound.play()
		await get_tree().create_timer(0.2).timeout
		cant_afford_sound.stop()

func _toggle_button():
	if game_info.has_currency("Gold", game_info.get_node("Towers").get_node(tower_id)._get_cost("Build")):
		disabled = false
		get_node("GrayOut").hide()
	else:
		disabled = true
		get_node("GrayOut").show()
