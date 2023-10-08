extends Node3D

var target_list = []
@export var target_groups = ["Enemy"]

func unit_detected(body):
	for group in target_groups:
		if body.is_in_group(group):
			target_list.append(body)
			return

func unit_lost(body):
	var index = 0
	for unit in target_list:
		if target_list[index] == unit:
			target_list.remove_at(index)
			return
		
		index += 1
