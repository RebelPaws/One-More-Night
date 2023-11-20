extends Node3D

signal GoldChanged
signal ManaChanged

#Onready Nodes
@onready var cam_rig = get_node("Cam_Rig")
@onready var tower_node = get_node("Tower")

@onready var title_screen = get_node("UI/Title")
@onready var currency_ui = get_node("UI/Currency_UI")
@onready var build_menu = get_node("UI/Build")
@onready var game_speed_buttons = get_node("UI/Game_Speed")

#@onready var audio = get_node("Audio")
@onready var music = get_node("Audio/Music")
@onready var enemy_manager = get_node("Enemy_Manager")
@onready var day_cycle = get_node("Sky/Day_Cycle")

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
	
	cam_rig.target = tower_node #This sets the starting target to the tower

#This starts the game to play
func start_game():
	"""
	title_screen.get_node("Audio/ButtonPress").play() #then we play the button press sound
	await get_tree().create_timer(0.2).timeout #Wait a second
	title_screen.get_node("Audio/ButtonPress").stop() #And make sure it stopped (I forgot what issue made this needed)
	"""
	GameInfo.game_state = "Play" #Sets the game state to Play
	game_speed_buttons._on_build_game_speed_toggle() #Brings up the game speed UI
	currency_ui.get_node("Anim").play("Toggle")
	build_menu.show() #Shows the build button
	
	#Shows 3D Tower information
	tower_node.setup()
	tower_node.show_health_armor()
	
	title_screen.hide() #Hides the title
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
			currency_ui.get_node("Gold_Label").text = str(gold)
			emit_signal("GoldChanged") #Then send out the signal to update currency visuals
			if _amount > 0: #If gold is being added, add it to the currency total
				gold_total += _amount
		"Mana":
			mana += _amount
			currency_ui.get_node("Mana_Label").text = str(mana)
			emit_signal("ManaChanged")
			if _amount > 0: #If mana is being added, add it to the currency total
				mana_total += _amount


#This will start enemies attacking
func start_night():
	music.switch_track("Night") #We switch the music track to the night variant
	enemy_manager._toggle(true) #We now allow enemies to spawn
	
	game_speed_buttons.toggle_skip_night(false) #We don't allow the skip to night to work at night

#This will end enemies attacking
func end_night():
	#$UI/Game_Speed.toggle_skip_night(true) #Now that it's day they can skip to night again
	enemy_manager.enemies_spawned = 0 #We set the amount of enemies currently spawned to 0
	
	music.switch_track("Morning") #We switch the music track to the morning variant
	
	enemy_manager._toggle(false) #Then we stop enemies from spawning
	night_survived()

#This will handle what happens when a night is survived
func night_survived():
	nights_survived += 1 #Add to the amount of nights survived

#When a day cycle finishes we set it to play again
func day_finished(_anim_name):
	day_cycle.stop()
	day_cycle.play("Day")


func night_skip_button_active():
	game_speed_buttons.toggle_skip_night(true) #Now that it's day they can skip to night again
