extends Node

var biome = "Maple_Forest" #The current biome
var biome_list = ["Maple_Forest", "Oak_Forest", "Snow", "Desert"] #List of all the biomes

var game_is_in_play = false #This tells the code when the game is being played and when it's in the title menu

func _ready():
	_pick_biome() #When the game loads up it'll pick a new biome

#This handles picking a new biome
func _pick_biome():
	randomize()
	biome = biome_list.pick_random()
