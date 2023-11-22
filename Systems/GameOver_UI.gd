extends Control

var UI_node : CanvasLayer
var game_manager : Node3D 


func _open():
	game_manager = get_tree().get_root().get_node("Game")
	UI_node = get_parent()
		
	if GameInfo.game_is_in_play == false: return
	
	GameInfo.game_state = "Menu"
	
	UI_node.get_node("Build").hide()
	UI_node.get_node("Game_Speed")._on_build_game_speed_toggle()
	UI_node.get_node("Currency_UI/").toggle_menu()
	
	update_stats()
	GameInfo.game_is_in_play = false
	show()

func update_stats():
	var nights_survived = game_manager.nights_survived
	
	$Title.text = "You Survived " + str(nights_survived) + " Nights!"
	
	var gold_total = game_manager.gold_total
	var mana_total = game_manager.mana_total
	var tower_count = game_manager.get_node("Tower/Blocks").get_child_count()
	var kill_count = game_manager.get_node("Enemy_Manager").confirmed_kills
	
	var stat_array = [str(gold_total), str(mana_total), str(tower_count), str(kill_count)]
	var menu_array = get_node("Stats").get_children()
	
	for i in menu_array.size():
		menu_array[i-1].get_node("Subtitle").text = stat_array[i-1]
	
	#$Stats/Gold/Subtitle.text = str(gold_total)
	#$Stats/Mana/Subtitle.text = str(mana_total)
	#$Stats/Towers/Subtitle.text = str(tower_count)
	#$Stats/Kills/Subtitle.text = str(kill_count)
	
	DataManager._save_game(0, nights_survived)

func try_again():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
