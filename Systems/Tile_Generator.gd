extends Node3D

#This is used to manage the tiles a bit as well as make sure the correct biome tile is showing
#Despite the name it's less generative and more applying details

@export var can_decorate = true #This allows us to turn of decor generation for certain tiles

func _ready():
	#We make a new node to hold these decor items
	var decor_node = Node.new() 
	add_child(decor_node)
	
	var biome = get_node("Biome/" + GameInfo.biome) #This grabs a random biome to apply and gets the tile mesh for it
	
	#For each biome we hide all of them to ensure nothing is showing
	for b in $Biome.get_children():
		b.hide()
	
	biome.show() #Then we show the biome we're using
	
	
	if not can_decorate: return #At this point if the tile doesn't generate decoration it's done being generated
	
	#We see if a random roll of the dice is enough to create a decor item
	if randf_range(0, 100) <= biome.chance_of_decor:
		var new_decor = biome.decor.pick_random().instantiate() #If it is we pick a random decor item then instance it
		decor_node.add_child(new_decor) #Then we add the decor item to the decor node
		new_decor.global_position = self.global_position + Vector3(0, 0.4, 0) #We set the position and give it a little offset
		new_decor.scale = Vector3(0.7, 0.7, 0.7) #Then we set the scale it down a little

