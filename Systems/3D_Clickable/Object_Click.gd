extends Area3D

#This script handles clicking on 3D objects
#For this to work the CollisionShape node needs to have Inspector/Input/Ray_Pickable enabled

signal ObjectClicked

var disabled = false

@export var is_button = false ##This lets us set this to just an object click detection or a 3D button

@export var button_textures = {"Normal": null, "Focused": null, "Pressed": null, "Disabled": null}

#This handles seeing if the object was clicked and then sends out the clicked signal
func clicked(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			set_button_texture("Pressed")
			emit_signal("ObjectClicked")
			await get_tree().create_timer(0.5).timeout
			set_button_texture("Normal")


func set_button_texture(_texture):
	if not is_button: return #If it's not a sprite it shouldn't run this
	
	var sprite = get_node("Sprite3D")
	
	sprite.texture = button_textures[_texture]
	if _texture == "Disabled":
		disabled = true
	else:
		disabled = false
