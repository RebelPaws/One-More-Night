extends "res://Towers/Tower_Core.gd"

#Perfect defense isn't implemented since the system of how this is work is changing
@export var chance_for_perfect_defense : float ##This is the chance for a perfect defense that will void all damage

func _ready():
	_add_armor() #Adds armor to the health

