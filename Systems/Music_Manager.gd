extends Node

func switch_track(_time_of_day):
	match _time_of_day:
		"Morning":
			fade($Night_Addition)
			fade_in($Morning_Addition)
		"Afternoon":
			fade($Morning_Addition)
			fade_in($Afternoon_Addition)
		"Night":
			fade($Afternoon_Addition)
			fade_in($Night_Addition)

func fade(_track):
	while _track.volume_db > -20:
				_track.volume_db -= 1
				await get_tree().create_timer(0.1).timeout

func fade_in(_track):
	while _track.volume_db < 0:
				_track.volume_db += 1
				await get_tree().create_timer(0.1).timeout
