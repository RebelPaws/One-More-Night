@tool
extends Node3D

@export var create_new_world = false:
	set(val):
		create_new_world = val
		destroy_world()
		await get_tree().create_timer(0.3).timeout
		generate_world()
		create_new_world = false

@export var grid_size = 10

@export var hex_tile : PackedScene
@export var tile_size = 10.0


func generate_world():
	for x in range(grid_size):
		var tile_coordinates = Vector2()
		tile_coordinates.x = x * tile_size * cos(deg_to_rad(30))
		tile_coordinates.y = 0 if x % 2 == 0 else tile_size / 2
		for y in range(grid_size):
			var new_tile = hex_tile.instantiate()
			add_child(new_tile)
			new_tile.translate(Vector3(tile_coordinates.x, 0 , tile_coordinates.y))
			tile_coordinates.y += tile_size

func destroy_world():
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
	return
