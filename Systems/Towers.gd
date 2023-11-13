extends Node

var tower_info = {
	"Archer": {
				"Scene": preload("res://Towers/Attack/Archer_Tower.tscn"),
				
				"Costs": {1: 20, 
						2: 30, 
						3: 40, 
						4: 50, 
						5: 100},
				
				"Damage": 
					{1: 5, 
					 2: 7, 
					 3: 9, 
					 4: 13, 
					 5: 16}, 
					
				"Armor": 
					{1: 0, 
					 2: 0, 
					 3: 0, 
					 4: 0, 
					 5: 0}, 
				},
}

func _get_tower_info(_tower_id):
	var scene = tower_info[_tower_id]["Scene"]
	var cost = tower_info[_tower_id]["Costs"]
	var damage = tower_info[_tower_id]["Damage"]
	var armor = tower_info[_tower_id]["Armor"]
	
	return [scene, cost, damage]


