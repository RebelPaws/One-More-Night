extends Node3D

signal GoldChanged
signal ManaChanged

@export_category("Currency Settings")
@export var gold = 100 ##This is the count for gold currency. Value is starting amount.
var gold_total = 0 #This is just to count up the total gained gold for stats

@export var mana = 0 ##This is the count for mana currency. Value is starting amount.
var mana_total = 0 #This is just to count up the total gained mana for stats

var nights_survived = 0 #This is how many nights have been survived


func _ready():
	DataManager._load_game() #This will try to load game data right away
	
	GameInfo.game_state = "Menu" #The game starts in a title screen aka Menu mode
	
	modify_currency("Gold", 0) #This updates the gold to reflect the starting currency
	modify_currency("Mana", 0) #This updates the mana to reflect the starting currency
	
	$Cam_Rig.target = $Tower #This sets the starting target to the tower

#This starts the game to play
func start_game():
	GameInfo.game_state = "Play" #Sets the game state to Play
	
	$UI/Title/Audio/ButtonPress.play() #then we play the button press sound
	await get_tree().create_timer(0.2).timeout #Wait a second
	$UI/Title/Audio/ButtonPress.stop() #And make sure it stopped (I forgot what issue made this needed)
	
	$UI/Game_Speed/Anim.play("Toggle") #Brings up the game speed UI
	$UI/Currency_UI/Anim.play("Toggle")
	$UI/Build.show() #Shows the build button
	
	#Shows 3D Tower information
	$Tower/Health.show() 
	$Tower/Armor.show()
	
	$UI/Title.hide() #Hides the title
	GameInfo.game_is_in_play = true #Make sure the game knows it's in play

#This handles quitting the game
func quit_game():
	get_tree().quit()


#This will handle checking for needed currency
func has_currency(_type, _needed):
	match _type:
		"Gold":
				if gold >= _needed: #If the player has the needed currency
					return true #Return true
		"Mana":
				if mana >= _needed: #If the player has the needed currency
					return true #Return true
	
	return false #Otherwise Return false

#This handles modifying currency
func modify_currency(_type, _amount):
	match _type:
		"Gold":
			gold += _amount #The amount is added to the currency count. To subtract just send a negative amount
			$UI/Currency_UI/Gold_Label.text = str(gold)
			emit_signal("GoldChanged", gold) #Then send out the signal to update currency visuals
		"Mana":
			mana += _amount
			$UI/Currency_UI/Mana_Label.text = str(mana)
			emit_signal("ManaChanged", mana)
	
	if _amount > 0: #If gold is being added, add it to the currency total
		match _type:
			"Gold":
					gold_total += _amount
			"Mana":
					mana_total += _amount


#This will start enemies attacking
func start_night():
	$Audio/Music.switch_track("Night") #We switch the music track to the night variant
	$Enemy_Manager._toggle(true) #We now allow enemies to spawn
	
	$UI/Game_Speed.toggle_skip_night(false) #We don't allow the skip to night to work at night

#This will end enemies attacking
func end_night():
	#$UI/Game_Speed.toggle_skip_night(true) #Now that it's day they can skip to night again
	$Enemy_Manager.enemies_spawned = 0 #We set the amount of enemies currently spawned to 0
	
	$Audio/Music.switch_track("Morning") #We switch the music track to the morning variant
	
	$Enemy_Manager._toggle(false) #Then we stop enemies from spawning
	night_survived()

#This will handle what happens when a night is survived
func night_survived():
	nights_survived += 1 #Add to the amount of nights survived

#When a day cycle finishes we set it to play again
func day_finished(_anim_name):
	$Sky/Day_Cycle.stop()
	$Sky/Day_Cycle.play("Day")


func night_skip_button_active():
	$UI/Game_Speed.toggle_skip_night(true) #Now that it's day they can skip to night again
