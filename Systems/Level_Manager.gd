extends Node

signal LevelUp #This will mark a level up

var level = 1
@export var level_cap : int ##The level cap for the object

var xp = 0
@export var xp_requirements = {} ##Each level's XP requirement [1: 50] means you need 50 XP to reach level 2

func _input(event):
	if Input.is_action_just_pressed("Cheat_Input_1"):
		gain_xp(1)

func gain_xp(_amount):
	print(xp)
	xp += _amount
	
	var xp_needed_to_level = xp_requirements[level]
	
	if xp >= xp_needed_to_level:
		level_up()

func level_up():
	level += 1
	emit_signal("LevelUp")

