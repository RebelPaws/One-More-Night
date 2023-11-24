extends Control

signal SetBaseTower
signal Upgraded

var tower_focus #This will be set by the tower edit menu

func enable(_new_focus):
	tower_focus = _new_focus
	var upgrade_type = tower_focus.get_node("Level_Manager").level % 2
	
	match tower_focus.tower_category:
		"Attack":
			match tower_focus.tower_id:
				"Base":
					$Unit_Selection/Attack.show()
					$Unit_Selection/Attack/Archer.update_upgrade_info()
				
				"Archer":
					if upgrade_type != 0:
						$Upgrade_Selection/Attack/Archer/Stat.show()
						$Upgrade_Selection/Attack/Archer/Stat.get_child(0).update_upgrade_info()
					if upgrade_type == 0:
						$Upgrade_Selection/Attack/Archer/Perk.show()
						$Upgrade_Selection/Attack/Archer/Perk.get_child(0).update_upgrade_info()
				
				"Soldier":
					$Upgrade_Selection/Attack/Soldier.show()
					$Upgrade_Selection/Attack/Soldier.get_child(0).update_upgrade_info()
		
		"Defense":
			pass
		
		"Support":
			pass
	
	show()

func disable():
	match tower_focus.tower_category:
		"Attack":
			match tower_focus.tower_id:
				"Base":
					$Unit_Selection/Attack.hide()
				
				"Archer":
					$Upgrade_Selection/Attack/Archer/Stat.hide()
					$Upgrade_Selection/Attack/Archer/Perk.hide()
				
				"Soldier":
					$Upgrade_Selection/Attack/Soldier.hide()
		
		"Defense":
			pass
		
		"Support":
			pass
	
	hide()

func select_upgrade(_upgrade):
	match tower_focus.tower_category:
		"Attack":
			match tower_focus.tower_id:
				"Base":
					match _upgrade.name:
						"Archer":
							emit_signal("SetBaseTower", "Archer")
						"Soldier":
							emit_signal("SetBaseTower", "Soldier")
				
				"Archer":
					emit_signal("Upgraded", _upgrade)
				
				"Soldier":
					emit_signal("Upgraded", _upgrade)
		
		"Defense":
			pass
		
		"Support":
			pass
	
	disable()

func update_info(_upgrade):
	$Info/Upgrade_Name.text = _upgrade.name
	$Info/Upgrade_Description.text = _upgrade.get_node("Description").text


