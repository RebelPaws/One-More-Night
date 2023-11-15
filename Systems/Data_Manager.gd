extends Node

var save_file_directory = "user://Data/Save_Data.txt"

func _create_data():
	var save_file = FileAccess.open(save_file_directory, FileAccess.WRITE)

func _save_game(_perma_currency, _survival_hiscore):
	var file = FileAccess.open(save_file_directory, FileAccess.WRITE)
	
	file.store_line("Perma_Currency :" + str(_perma_currency))
	file.store_line("Survival_HiScore :" + str(_survival_hiscore))
	
	file.close()

func _load_game():
	var file = FileAccess.open(save_file_directory, FileAccess.READ)
	
	for index in file.get_as_text().count(":"):
		var line = file.get_line()
		var key = line.split(":")[0]
		var value = line.split(":")[1]
		
		if value.is_valid_int():
			value = int(value)
		
		elif value.is_valid_float():
			value = float(value)
		
		elif value.begins_with("["):
			value = value.trim_prefix("[")
			value = value.trim_suffix("]")
			value = value.split(",")
		
		match key:
			"Perma_Currency":
				print("Perma Currency: " + str(value))
	
	file.close()
