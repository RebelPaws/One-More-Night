extends Control

#@onready var UI_node : CanvasLayer = get_parent()
@onready var game_manager : Node3D = get_tree().get_root().get_node("Game")


func _open():
	if GameInfo.game_is_in_play == false: return
		
	update_stats()
	GameInfo.game_is_in_play = false
	modulate = Color8(255,255,255,0)
	show()
	var tween_fade_in = get_tree().create_tween()
	
	tween_fade_in.tween_property(self, "modulate", Color8(255,255,255,255), 1.0).set_trans(Tween.TRANS_QUART)
	tween_fade_in.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = true


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
	get_tree().paused = false
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
