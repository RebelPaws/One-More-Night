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
					
				},
	"Shield": {
				"Scene": preload("res://Towers/Defense/Shield_Tower.tscn"),
				
				"Costs": {1: 30, 
						2: 60, 
						3: 100, 
						4: 120, 
						5: 150},
				
				"Armor": 
					{1: 5, 
					 2: 8, 
					 3: 12, 
					 4: 15, 
					 5: 20}, 
				},
	"Healer": {
				"Scene": preload("res://Towers/Support/Healer_Tower.tscn"),
				
				"Costs": {1: 50, 
						2: 100, 
						3: 150, 
						4: 250, 
						5: 300},
				
				"Heal": 
					{1: 1, 
					 2: 2, 
					 3: 5, 
					 4: 9, 
					 5: 12}, 
	},
}

func _get_tower_info(_tower_id, _tower_category):
	var scene = tower_info[_tower_id]["Scene"]
	var cost = tower_info[_tower_id]["Costs"]
	
	match _tower_category:
		"Attack":
			var damage = tower_info[_tower_id]["Damage"]
			return [scene, cost, damage]
		"Defense":
			var armor = tower_info[_tower_id]["Armor"]
			return [scene, cost, armor]
		"Support":
			var healing = tower_info[_tower_id]["Heal"]
			return [scene, cost, healing]


