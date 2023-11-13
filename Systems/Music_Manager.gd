extends Node

var music_bank

func _ready():
	music_bank = get_node(GameInfo.biome)
	music_bank.play()

func switch_track(_time_of_day):
	var tween = create_tween()
	
	match _time_of_day:
		"Morning":
			tween.tween_property(music_bank, "parameter_dayNight", 30, 2)
		"Night":
			tween.tween_property(music_bank, "parameter_dayNight", 65, 4)
