extends Node3D

var level = 1 #This is the tower's level which will determine everything about it.

var target_list = [] #This is the list of possible targets
@export var target_groups = ["Enemy"] ##These are the groups that can be targeted

@export var tower_id : String ##This is the tower's ID in all game files
@export var tower_category : String ##This is the category of the tower


func _ready():
	_add_armor() #This adds the armor value to our main health once it exists

#This handles adding up armor
func _add_armor():
	#Note: This should only be applied once unless the tower gets a perk to add armor more than once.
	var health_manager = get_parent().get_parent().get_node("Health_Manager") #We get the health manager node we need
	var armor = Towers._get_tower_info(tower_id)[3] #This gets the tower's armor
	
	health_manager.armor += armor #Finally we add the health manager's armor to the tower's armor

#This handles unit detection and sees if it can be added to the target list
func unit_detected(body):
	for group in target_groups: #For each group we can target we'll check the unit for
		if body.is_in_group(group): #If the unit is in the target group
			target_list.append(body) #We add them to the list
			return #Then we exit the function
		
		#Otherwise the loop will run until it either finds the right group or the unit isn't what it's looking for0

#This handles removing units from the target list
func unit_lost(body):
	var index = 0 #We set this so we can easily identify the position of the unit in the target list
	
	
	if body in target_list: #First we check to see if the unit is even in the target list
		for unit in target_list: #If they are we go through each unit to find them
			if target_list[index] == unit: #We check to see if the current array position is the unit
				target_list.remove_at(index) #If it is we remove it from the target list
				return #Then leave the function
			
			index += 1 #Otherwise we go to the next position in the target list

#This will open up the tower edit menu when clicked
func open_tower_menu():
	get_parent().get_parent().get_parent().get_node("UI/Tower_Edit").enable(self)
