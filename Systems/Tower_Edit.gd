extends Control

var active = false #Tells the menu if it's active or not

var tower_lock_on #This is the tower being focused on

@export var refund_rate = 1.0 ##This is what percent of the tower cost is refunded during sales

@onready var game_root = get_parent().get_parent()
@onready var tower_info = game_root.get_node("Towers")

#This pulls up the menu
func enable(tower_focused):
	#If the menu is already active or another menu is we don't allow it to open up
	#This is the counter-measure to clicky players trying to break or accidently clicking open other menus
	if active or GameInfo.game_state == "Menu": return
	
	GameInfo.game_state = "Menu" #We set the game state to menu
	active = true #Now we're ready to be active
	
	tower_lock_on = tower_focused #Set our tower lock on reference
	get_parent().get_node("Build").hide() #Then hide the build menu button
	
	var cam = get_parent().get_parent().get_node("Cam_Rig") #We grab the camera rig
	cam.target = tower_focused.get_node("Cam_Anchor") #Now we give it a new target to move to
	cam.lock_zoom = true #We lock in the zoom so it'll be focused on the tower block being focused
	cam.zoom_to(5.0) #And we move the zoom to a set zoom for now
	
	$Naming/Name.text = tower_lock_on.tower_id
	
	update_upgrade()
	
	#Now we check to see if this is the last tower block built aka the peak
	if get_parent().get_parent().get_node("Tower").get_last_tower() == tower_focused:
		$Options/Sell.show() #If it is we show the sell option
	else: #If not we won't since they can't.
		$Options/Sell.hide()
	
	#This will get the specific category of stats for the tower
	$Stats.get_node(tower_lock_on.tower_category).show() 
	
	$Anim.play("Toggle") #We'll play the toggle animation now
	
	#And play the game speed toggle backwards to remove it
	get_parent().get_node("Game_Speed/Anim").play_backwards("Toggle") 
	
	$Options/Upgrade.grab_focus()

#This puts away the menu
func disable():
	$Anim.play_backwards("Toggle") #We play the menu toggle animation backwards to remove it
	
	var cam = get_parent().get_parent().get_node("Cam_Rig") #Then we grab the cam rig
	cam.target = get_parent().get_parent().get_node("Tower") #We'll set it's new tower back to the tower foundation
	cam.lock_zoom = false #We'll unlock the zoom
	cam.zoom_to(15.0) #But we'll move the zoom back for the player too
	
	await $Anim.animation_finished #We'll wait for the un-toggle animation to finish
	active = false #Then we deactive the menu
	
	get_parent().get_node("Game_Speed/Anim").play("Toggle") #We'll now toggle the game speed UI again
	get_parent().get_node("Build").show() #And show the build button
	
	$Stats.get_node(tower_lock_on.tower_category).hide() #The stats UI will also go away
	GameInfo.game_state = "Play" #And game state is set back to Play

#Handles upgrading the tower
func upgrade_tower():
	#We get the upgrade cost first
	var _cost = Towers._get_tower_info(tower_lock_on.tower_id, tower_lock_on.tower_category)[1][tower_lock_on.level]
	
	#If the player doesn't have the needed gold then they can't upgrade
	if not game_root.has_currency(_cost): return
	
	game_root.modify_currency(-_cost) #If they can afford it we'll take their gold
	
	tower_lock_on.level_up() #This will level up the tower
	await get_tree().create_timer(0.1).timeout #This gives the game a half-second to get all the logic through
	#This way before we update the info it should be all increased
	
	var stats_node = $Stats.get_node(tower_lock_on.tower_category)
	var tower_info = Towers._get_tower_info(tower_lock_on.tower_id, tower_lock_on.tower_category)
	match tower_lock_on.tower_category:
		"Attack":
			$Stats/Attack/Health/Amount.text = str(tower_info[2][tower_lock_on.level])
			$Stats/Attack/Damage/Amount.text = str(tower_info[3][tower_lock_on.level])
			$Stats/Attack/Attack_Rate/Amount.text = str(tower_info[4][tower_lock_on.level]) + "/sec"
		
		"Defense":
			pass
		"Support":
			pass
	
	update_upgrade()

#Handles selling the tower
func sell_tower():
	#This is the amount to refund
	var to_refund = tower_lock_on.cost[tower_lock_on.level] * refund_rate
	
	game_root.modify_currency(to_refund) #Then we send the currency back
	disable() #And disable the menu since the tower is now gone
	
	await get_tree().create_timer(0.5).timeout #This is to ensure everything is done before we free the tower block
	tower_lock_on.queue_free() #Then bye bye tower blocks
	tower_lock_on = null #We null this since it'll be null anyways

func update_upgrade():
	$Naming/Level.text = "Lvl. " + str(tower_lock_on.level)
	
	#We check to see if the tower is max level yet
	if tower_lock_on.level == tower_lock_on.level_cap:
		$Options/Upgrade.hide()
		return #If there's nothing left to upgrade we hide the upgrade button and leave
	
	#If the tower block isn't max level we'll update the info and ensure the upgrade button is shown
	$Options/Upgrade.show()
	
	#Then we update the cost text
	$Options/Upgrade/Cost.text = str(tower_lock_on.cost[tower_lock_on.level])
	
	
	#We update the upgrade cost
