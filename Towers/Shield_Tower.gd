extends "res://Towers/Tower_Core.gd"

@export var armor_value : float
@export var chance_for_perfect_defense : float

func _ready():
	var health_manager = get_parent().get_parent().get_node("Health_Manager")
	health_manager.armor += armor_value
	

