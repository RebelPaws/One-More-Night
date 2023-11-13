extends Area3D

#This script handles clicking on 3D objects
#For this to work the CollisionShape node needs to have Inspector/Input/Ray_Pickable enabled

signal ObjectClicked

#This handles seeing if the object was clicked and then sends out the clicked signal
func clicked(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("ObjectClicked")
