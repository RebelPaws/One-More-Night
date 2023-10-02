extends Node

var biome = "Maple_Forest"
var biome_list = ["Maple_Forest", "Oak_Forest"]

var game_is_in_play = false

func _ready():
	_pick_biome()

func _pick_biome():
	biome = biome_list.pick_random()
