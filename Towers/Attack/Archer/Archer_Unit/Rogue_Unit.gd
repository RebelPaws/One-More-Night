extends Node3D

@export var arrow_tscn : PackedScene

var chance_for_perfect_shot = 20.0
var damage = 1.0

func shoot(_target):
	var arrow = $Arrow_Container._get_unused_object()
	if arrow == null: 
		return
	
	var chance_roll = randf_range(0, 100)
	
	arrow.global_position = $Shoot_Point.global_position
	arrow.target = _target
	arrow.get_node("DamageBox").damage = damage
	
	if chance_roll <= chance_for_perfect_shot:
		arrow.seek_target = true
	else:
		arrow.seek_target = false
	
	arrow.activate()
	
	$AnimationPlayer.play("2H_Ranged_Shoot")
	$Attack.play()
	await $AnimationPlayer.animation_finished
	reload()

func reload():
	$AnimationPlayer.play("2H_Ranged_Reload")
	await $AnimationPlayer.animation_finished
	aim()

func aim():
	$AnimationPlayer.play("2H_Ranged_Aiming")


