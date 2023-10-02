extends Node3D

signal CurrencyChanged

var currency = 100
var currency_total = 0

var nights_survived = 0

func _ready():
	modify_currency(0)

func night_survived():
	nights_survived += 1

func has_currency(_needed):
	if currency >= _needed:
		return true
	
	return false

func modify_currency(_amount):
	currency += _amount
	emit_signal("CurrencyChanged", currency)
	
	if _amount > 0:
		currency_total += _amount

#This will start enemies attacking
func start_night():
	$Night_Music.play()
	$Day_Music.stop()
	$Enemy_Manager._toggle(true)
	
	$UI/Game_Speed.toggle_skip_night(false)

#This will end enemies attacking
func end_night():
	$UI/Game_Speed.toggle_skip_night(true)
	$Enemy_Manager.enemies_spawned = 0
	$Day_Music.play()
	$Night_Music.stop()
	$Enemy_Manager._toggle(false)

func start_game():
	$UI/Game_Speed.show()
	$UI/Build.show()
	$Tower/Health.show()
	$Tower/Armor.show()
	$Tower/Currency.show()
	$UI/Title.hide()
	GameInfo.game_is_in_play = true

func quit_game():
	get_tree().quit()
