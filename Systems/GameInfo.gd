extends Node

var biome = "Maple_Forest" #The current biome
var biome_list = ["Maple_Forest", "Oak_Forest", "Snowflake_Shire", "Mirage_Mesa"] #List of all the biomes

var game_is_in_play = false #This tells the code when the game is being played and when it's in the title menu

var game_state = "Menu"

func _ready():
	_pick_biome() #When the game loads up it'll pick a new biome

#This handles picking a new biome
func _pick_biome():
	randomize()
	biome = biome_list.pick_random()

func get_real_time():
	var actual_time_scale = 1
	
	match Engine.time_scale:
		2.0:
			actual_time_scale = 0.5
		3.0:
			actual_time_scale = 0.75
		4.0:
			actual_time_scale = 0.25
	
	return actual_time_scale
