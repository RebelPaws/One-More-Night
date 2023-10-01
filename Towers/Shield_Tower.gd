extends "res://Towers/Tower_Core.gd"

@export var armor_value : float

func _ready():
	var health_manager = get_parent().get_parent().get_node("Health_Manager")
	health_manager.armor += armor_value
	print(health_manager.armor)

