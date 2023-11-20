extends MeshInstance3D

#This gets the game root for us
@onready var game_root = get_tree().get_root().get_node("Game")

@export var cost_to_remove = 5 ##This is the cost to remove the decor from the map

#This opens up the decor manager menu
func open_decor_menu():
	if GameInfo.game_state == "Play": #It checks to ensure the game is in play
		#Then we update the info in the decor manager menu before enabling it
		game_root.get_node("UI/Remove_Decor_Menu").update_info(self, "Maple Tree", cost_to_remove)
		game_root.get_node("UI/Remove_Decor_Menu").enable()
		
		#The rest of this logic is carried out in Remove_Decor.gd
