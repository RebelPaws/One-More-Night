extends Node

var data_directory = "user://Data"
var save_file = "user://Data/Save_Data.txt"

func _ready():
	if not DirAccess.dir_exists_absolute(data_directory):
		_create_data()

func _create_data():
	DirAccess.make_dir_absolute(data_directory)
	
	_save_game(0, 0)

func _save_game(_perma_currency, _survival_hiscore):
	var file = FileAccess.open(save_file, FileAccess.WRITE)
	
	file.store_line("Perma_Currency :" + str(_perma_currency))
	file.store_line("Survival_HiScore :" + str(_survival_hiscore))
	file = null

func _load_game():
	if not FileAccess.file_exists(save_file):
		_save_game(0, 0)
	
	var file = FileAccess.open(save_file, FileAccess.READ)
	
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
		print(key)
		match key:
			"Perma_Currency":
				print("Perma Currency: " + str(value))
