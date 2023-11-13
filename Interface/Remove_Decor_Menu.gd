extends Control

#This script handles removing decor items from the map

var target #This is the target object we're removing potentially
var target_type = "" #This is the type of object it is (determines audio type and name shown currently)

#This pulls up the remove menu
func enable():
	play_button_sound() #We play the button sound
	GameInfo.game_state = "Menu" #Set game state to Menu
	$Anim.play("Toggle") #Then we play the menu toggle animation

#This puts away the remove menu
func disable():
	GameInfo.game_state = "Play" #We set the game state to Play
	$Anim.play_backwards("Toggle") #Then we play the toggle animation backwards


#This updates the info we'll showcase
func update_info(_item, _item_name, _cost):
	$Header.text = "Remove " + _item_name + "?" #This will come out as "Remove Item?"
	$Remove/Cost.text = str(-_cost) #This sets the cost text
	
	target = _item #This sets the target object
	target_type = _item_name #Then we set the target type
	
	enable() #Then we enable the menu

#This handles removing the actual object
func remove_object():
	var game_root = get_parent().get_parent() #We grab the game root to modify and check currency
	var cost_to_remove = int($Remove/Cost.text) #This grabs the cost to remove the item
	
	if game_root.has_currency(cost_to_remove): #We check to see if the player has enough gold
		game_root.modify_currency(cost_to_remove) #If they do we remove the gold from their wallet
		
		disable() #Then we disable the menu to avoid any double clicking and to speed the process up
		
		if "Tree" in target_type: #If Tree is a word in the target type we know it's a tree object
			for chop in 3: #So then we chop it down, we play the cut clip 3 times
				$Audio/Cut_Tree.play()
				await get_tree().create_timer(0.3).timeout #Small delay between each sound
		
		target.call_deferred("free") #Then we remove the object from the game

#This disables the menu in case the player doesn't want to remove the decor or can't
func cancel():
	play_button_sound()
	disable()

#This ensures that the animation is playing at a game speed of 1.0 at all times even if the game is sped up
func _on_anim_current_animation_changed(name):
	$Anim.speed_scale = GameInfo.get_real_time()

#This plays the click button sound
func play_button_sound():
	$Audio/ButtonPress.play()
	
	await get_tree().create_timer(0.2).timeout
	
	$Audio/ButtonPress.stop()
