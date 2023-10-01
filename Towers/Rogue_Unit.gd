extends Node3D

@export var arrow_tscn : PackedScene

func shoot(_target):
	var arrow = $Arrow_Container._get_unused_object()
	if arrow == null: 
		return
	
	arrow.global_position = $Shoot_Point.global_position
	arrow.target = _target
	arrow.activate()
	
	$AnimationPlayer.play("2H_Ranged_Shoot")
	$Shoot_Sound.play()
	await $AnimationPlayer.animation_finished
	reload()

func reload():
	$AnimationPlayer.play("2H_Ranged_Reload")
	await $AnimationPlayer.animation_finished
	aim()

func aim():
	$AnimationPlayer.play("2H_Ranged_Aiming")


