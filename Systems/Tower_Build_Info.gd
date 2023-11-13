extends Button

#This sets up the info for the build menu tower block buttons

@export var tower_id : String ##The name or id of the tower block
@export var tower_category : String ##The category the tower is in (Attack, Defense, Support)

func _ready():
	update_info()

#This handles updating the info
func update_info():
	var info = Towers._get_tower_info(tower_id, tower_category) #We grab the tower info
	
	$Cost.text = str(-info[1][1]) #Set the cost label
	
	#Then we set the category special stat
	match tower_category:
		"Attack":
			get_node("Damage").text = str(info[2][1])
		"Defense":
			get_node("Armor").text = str(info[2][1])
		"Support":
			get_node("Heal").text = str(info[2][1])

