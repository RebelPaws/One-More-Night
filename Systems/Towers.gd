extends Node

#This holds info for each tower
#Structure:
#{Tower_Name: {Costs: {Tower_Level: Cost_Value},
#             {Category_Stat: {Tower_Level: Stat_Power}
#             } 
#}
#Everything is broken into dictionaries since upgrades are a thing this makes it easier to set the upgraded stats
var tower_info = {
	"Archer": {
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

#This holds the scenes preloaded to use in the game
#These were held in tower_info but some issue was creating a crash error for the Healer tower block
var scenes = {
				"Archer": preload("res://Towers/Attack/Archer_Tower.tscn"),
				"Shield": preload("res://Towers/Defense/Shield_Tower.tscn"),
				"Healer": preload("res://Towers/Support/Healer_Tower.tscn")
			}

#This grabs all the needed info to send to wherever it needs to go
func _get_tower_info(_tower_id, _tower_category):
	if not _tower_id in tower_info: return #This ensures a non-tower won't slip through and crash the game
	
	var scene = scenes[_tower_id] #The tower block scene preloaded
	var cost = tower_info[_tower_id]["Costs"] #The tower costs
	
	#Since not all towers have the same stats this sends the category special stat where it needs to go
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


