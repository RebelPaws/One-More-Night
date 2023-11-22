extends Node

@export var scenes = {"Base": preload("res://Towers/Tower_Base/Tower_Base.tscn"),
					  "Archer": preload("res://Towers/Attack/Archer/Archer_Tower.tscn"),
					  "Shield": preload("res://Towers/Defense/Shield_Tower.tscn"),
					  "Healer": preload("res://Towers/Support/Healer_Tower.tscn")
}

func get_scene(_id):
	return scenes[_id]
