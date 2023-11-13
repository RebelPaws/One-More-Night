extends Node

#The game currently uses FMod for all the audio as it allows for some cool stuff like dynamic music

var music_bank

func _ready():
	music_bank = get_node(GameInfo.biome) #We grab the music bank based on the biome
	music_bank.play() #Then we play the music

#This handles switching the track between day and night music
func switch_track(_time_of_day):
	var tween = create_tween() #This creates the tween we need
	
	match _time_of_day: #We snag the time of day we're at then tween the FMod parameter to where it needs to be
		"Morning":
			tween.tween_property(music_bank, "parameter_dayNight", 30, 2)
		"Night":
			tween.tween_property(music_bank, "parameter_dayNight", 65, 4)
