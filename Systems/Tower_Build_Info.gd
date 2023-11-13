extends Button

@export var tower_id : String
@export var tower_category : String

func _ready():
	var info = Towers._get_tower_info(tower_id, tower_category)
	
	$Cost.text = str(-info[1][1])
	
	match tower_category:
		"Attack":
			get_node("Damage").text = str(info[2][1])
		"Defense":
			get_node("Armor").text = str(info[2][1])
		"Support":
			get_node("Heal").text = str(info[2][1])
