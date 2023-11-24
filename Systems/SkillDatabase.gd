extends Node

var tower_type = ["Archer", "Soldier"]
var equipped_perks = []

var perk_list = {
					"Archer": {
										"Name": "Archer",
										"Description": "Blast the enemies with polterguist power!",
										
										"Perks": {
													"Seeker": {
																"Requirements": [],
																"Blockers": [],
																"Unlocked": true,
																"Description": "Missing your shots? Auto-Attacks am I RIGHT?!....No more! With this perk your shots will home in!",
															},
												},
											},
				}

var upgrades_in_menu = []

func get_upgrade():
	var _name 
	var _type 
	var possible_options = []
	
	for ability_key in abilities.keys():
		if ability_key in equipped_abilities:
			
			for perk_key in abilities[ability_key]["Perks"].keys():
				var has_requirements = true
				var perk_info = abilities[ability_key]["Perks"][perk_key]
				
				if not perk_key in equipped_perks:
					if not perk_key in upgrades_in_menu:
						if perk_info["Unlocked"]:
							if perk_info["Requirements"] != []:
								for requirement in perk_info["Requirements"]:
									if not requirement in equipped_perks:
										has_requirements = false
							if has_requirements:
								for blocker in perk_info["Blockers"]:
									if not blocker in equipped_perks and not blocker in equipped_abilities:
										possible_options.append([perk_key, abilities[ability_key]["Name"] + " Perk"])
								if perk_info["Blockers"] == []:
									possible_options.append([perk_key, abilities[ability_key]["Name"] + " Perk"])
		if not ability_key in equipped_abilities:
			if not ability_key in upgrades_in_menu:
				possible_options.append([ability_key, "Ability"])
	
	var new_upgrade = possible_options.pick_random()
	if new_upgrade == null:
		return null
	_name = new_upgrade[0]
	_type = new_upgrade[1]
	
	upgrades_in_menu.append(_name)
	return [_name, _type]

