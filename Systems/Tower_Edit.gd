extends Control

var active = false #Tells the menu if it's active or not

var tower_lock_on #This is the tower being focused on

@export var refund_rate = 1.0 ##This is what percent of the tower cost is refunded during sales

@onready var game_root = Commands.get_root()

@onready var game_info = get_tree().get_root().get_node("Game")
@onready var tower_node = game_info.get_node("Tower")

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
	cam.zoom_to(6.0) #And we move the zoom to a set zoom for now
	cam.rotate_to(-0.3, 3.1, 0) ##And rotate the camera back to the front of the tower
	
	$Naming/Name.text = tower_lock_on.tower_id
	
	update_upgrade()
	
	#Now we check to see if this is the last tower block built aka the peak
	if get_parent().get_parent().get_node("Tower").get_last_tower() == tower_focused:
		if tower_lock_on.can_sell:
			$Edit_Mode/Options/Sell.show() #If it is we show the sell option
		
		tower_lock_on.get_node("Build_Buttons").show()
		tower_lock_on.get_node("Build_Buttons/Cost").text = str(-game_info.get_node("Towers").get_node("Base").costs[1])
		tower_lock_on.connect("BuildNextLevel", build_next_level, 1)
	else: #If not we won't since they can't.
		$Edit_Mode/Options/Sell.hide()
		tower_lock_on.get_node("Build_Buttons").hide()
	
	#This will get the specific category of stats for the tower
	$Stats.get_node(tower_lock_on.tower_category).show() 
	
	$Anim.play("Toggle") #We'll play the toggle animation now
	
	if tower_lock_on.can_upgrade:
		$Edit_Mode.show()
	else:
		$Edit_Mode.hide()
	
	#And play the game speed toggle backwards to remove it
	get_parent().get_node("Game_Speed")._on_build_game_speed_toggle()
	
	$Edit_Mode/Options/Upgrade.grab_focus()

#This puts away the menu
func disable():
	$Anim.play_backwards("Toggle") #We play the menu toggle animation backwards to remove it
	tower_lock_on.get_node("Build_Buttons").hide()
	
	var cam = get_parent().get_parent().get_node("Cam_Rig") #Then we grab the cam rig
	cam.target = get_parent().get_parent().get_node("Tower") #We'll set it's new tower back to the tower foundation
	cam.lock_zoom = false #We'll unlock the zoom
	cam.zoom_to(15.0) #But we'll move the zoom back for the player too
	cam.rotate_to(-0.5, cam.rotation.y, cam.rotation.z)
	
	await $Anim.animation_finished #We'll wait for the un-toggle animation to finish
	active = false #Then we deactive the menu
	
	get_parent().get_node("Game_Speed")._on_build_game_speed_toggle() #We'll now toggle the game speed UI again
	#get_parent().get_node("Build").show() #And show the build button
	
	$Stats.get_node(tower_lock_on.tower_category).hide() #The stats UI will also go away
	GameInfo.game_state = "Play" #And game state is set back to Play

#Handles upgrading the tower
func upgrade_tower():
	#We get the upgrade cost first
	var _cost = tower_lock_on.costs[tower_lock_on.level + 1]
	
	#If the player doesn't have the needed gold then they can't upgrade
	if not game_root.has_currency("Gold", _cost): return
	
	game_root.modify_currency("Gold", -_cost) #If they can afford it we'll take their gold
	
	tower_lock_on.level_up() #This will level up the tower
	await get_tree().create_timer(0.1).timeout #This gives the game a half-second to get all the logic through
	#This way before we update the info it should be all increased
	
	var stats_node = $Stats.get_node(tower_lock_on.tower_category)
	
	match tower_lock_on.tower_category:
		"Attack":
			$Stats/Attack/Health/Amount.text = str(tower_lock_on.health[tower_lock_on.level])
			$Stats/Attack/Damage/Amount.text = str(tower_lock_on.attack_damage[tower_lock_on.level])
			$Stats/Attack/Attack_Rate/Amount.text = str(tower_lock_on.costs[tower_lock_on.level]) + "/sec"
			if tower_lock_on.level == 3 or tower_lock_on.level == 5:
				tower_lock_on.spawn_archer()
		
		"Defense":
			pass
		
		"Support":
			pass
	
	update_upgrade()

#Handles selling the tower
func sell_tower():
	#This is the amount to refund
	var to_refund = tower_lock_on.costs[tower_lock_on.level] * refund_rate
	
	game_root.modify_currency("Gold", to_refund) #Then we send the currency back
	disable() #And disable the menu since the tower is now gone
	
	await get_tree().create_timer(0.5).timeout #This is to ensure everything is done before we free the tower block
	tower_lock_on.queue_free() #Then bye bye tower blocks
	tower_lock_on = null #We null this since it'll be null anyways

func update_upgrade():
	$Naming/Level.text = "Lvl. " + str(tower_lock_on.level)
	
	#We check to see if the tower is max level yet
	if tower_lock_on.level == tower_lock_on.level_cap:
		$Edit_Mode/Options/Upgrade.hide()
		return #If there's nothing left to upgrade we hide the upgrade button and leave
	
	#If the tower block isn't max level we'll update the info and ensure the upgrade button is shown
	$Edit_Mode/Options/Upgrade.show()
	
	#Then we update the cost text
	$Edit_Mode/Options/Upgrade/Cost.text = str(tower_lock_on.costs[tower_lock_on.level + 1])
	
	
	#We update the upgrade cost

#This builds the empty tower
func build_next_level(_category):
	var tower_blocks = tower_node.get_node("Blocks")
	var tower_info = game_info.get_node("Towers").get_node("Base")
	
	var cost = tower_info._get_cost("Build") #This is the cost of the base tower
	var tower_anchor_point = tower_blocks.get_child(tower_blocks.get_child_count()-1).get_node("Anchor").global_position
	
	if game_root.has_currency("Gold", cost):
		game_root.modify_currency("Gold", -cost)
		tower_lock_on.get_node("Build_Buttons").hide()
		
		var new_tower = game_info.get_node("Towers").get_scene("Base").instantiate()
		tower_blocks.add_child(new_tower)
		new_tower.active = true
		new_tower.global_position = tower_anchor_point
		new_tower.tower_category = _category

