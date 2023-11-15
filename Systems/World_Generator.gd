@tool
extends Node3D

#This script lets us generate maps very quickly
#Down the road this could be used to create more things
#But the general idea is a rough out of the map we can modify

#This variable will create a new map when switched
@export var create_new_world = false:
	set(val):
		create_new_world = val #We set the variable to true to keep it on for a second
		destroy_world() #We destroy the world before making a new one
		await get_tree().create_timer(0.3).timeout #We hold a second to make sure the world is fully gone
		generate_world() #Then we generate a new world
		create_new_world = false #And change this back to false so we can do it all again if needed

@export var grid_size = 10 ##This is the size of the map.

@export var hex_tile : PackedScene ##The tile scene used to generate maps.
@export var tile_size = 10.0 ##This is the size of each tile (may need adjusting)


#This handles world generation with lots of math I barely understand tbh
func generate_world():
	for x in range(grid_size): #This is for each row
		var tile_coordinates = Vector2()
		tile_coordinates.x = x * tile_size * cos(deg_to_rad(30))
		tile_coordinates.y = 0 if x % 2 == 0 else tile_size / 2
		
		for y in range(grid_size): #And this is for each column
			var new_tile = hex_tile.instantiate()
			add_child(new_tile)
			new_tile.owner = get_parent().owner
			new_tile.translate(Vector3(tile_coordinates.x, 0 , tile_coordinates.y))
			tile_coordinates.y += tile_size

#This handles destroying the world
func destroy_world():
	#For each tile we have we will free it then return at the end
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
	return


