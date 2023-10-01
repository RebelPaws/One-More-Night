extends Area3D

@export var damage : float ##This is the damage that will be done.

#This turns the collision shape on and off (useful or repetive hazards and attacks)
func toggle_collider():
	match $CollisionShape3D.disabled:
		true:
			$CollisionShape3D.set_deferred("disabled", false)
		
		false:
			$CollisionShape3D.set_deferred("disabled", true)


