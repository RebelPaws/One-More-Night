extends Control

var night_skip_to = 8.0

func set_night_skip_pos(_pos):
	night_skip_to = _pos

func _set_speed(_speed):
	
	if _speed > 0:
		get_tree().paused = false
		Engine.time_scale = _speed
	else:
		get_tree().paused = true

func skip_to_night():
	var day_animator = get_parent().get_parent().get_node("Sky/Day_Cycle")
	day_animator.seek(night_skip_to)

func toggle_skip_night(value):
	match value:
		true:
			$Speeds/Skip_to_Night.set_deferred("disabled", false)
			$Speeds/Skip_to_Night.show()
		false:
			$Speeds/Skip_to_Night.set_deferred("disabled", true)
			$Speeds/Skip_to_Night.hide()
