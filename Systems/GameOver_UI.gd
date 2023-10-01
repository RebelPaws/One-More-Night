extends Control

func _open():
	if GameInfo.game_is_in_play == false: return
	
	update_stats()
	GameInfo.game_is_in_play = false
	show()

func update_stats():
	$Title.text = "You Survived " + str(get_parent().get_parent().nights_survived) + " Nights!"
	var currency_total = get_parent().get_parent().currency_total
	var tower_count = get_parent().get_parent().get_node("Tower/Blocks").get_child_count()
	var kill_count = get_parent().get_parent().get_node("Enemy_Manager").confirmed_kills
	
	$Stats/Currency/Subtitle2.text = str(currency_total)
	$Stats/Towers/Subtitle5.text = str(tower_count)
	$Stats/Kills/Subtitle3.text = str(kill_count)

func try_again():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
