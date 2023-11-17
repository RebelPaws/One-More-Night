extends Node

@export var object_to_pool : PackedScene ##Put the object you want to pool here.
@export var amount_to_pool : int ##This is how many objects you want in your pool.

@export var vault_position : Vector3

func _ready():
	_create_pool()

func _create_pool():
	for object in amount_to_pool:
		var new_obj = object_to_pool.instantiate()
		add_child(new_obj)
		new_obj.set_process(false)
		new_obj.hide()
		new_obj.global_position = vault_position

func _get_unused_object():
	for object in self.get_children():
		if object.active == false:
			return object
		
	return null

func _cleanup_active_objects():
	for object in self.get_children():
		if object.active:
			object._disable()
	
	return null
