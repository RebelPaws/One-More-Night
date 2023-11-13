extends Node3D

signal Damaged #This sends out the damage signal with health variables
signal Damaged_Default #This sends out the damage signal without the health variables
signal Dead
signal Healed
signal ArmorChanged

@export var health_max : float ##This is the most health the object can have.
@onready var health_current = health_max #This is the current health of the object.

var is_hurt = false #This is to see if the object is still in its hurt state

@export var armor : float: ##This is the amount of armor the object has to negate damage.
	set(val):
		armor = val #We set the armor to the new value
		emit_signal("ArmorChanged", val) #Then we send out the armor change signal to update visual indicators

func _ready():
	_heal(0) #This just updates the health visuals
	armor = armor #This updates the armor visuals

#This handles getting the health percent
func _get_percent():
	return (health_current / health_max) * 100

#This handles taking damage
func _take_damage(_damage):
	if is_hurt: return
	
	is_hurt = true
	
	var reduction_percent = armor * 0.01
	if reduction_percent > 0.9: reduction_percent = 0.9
	
	if get_parent().name == "Tower":
		for block in get_parent().get_node("Blocks").get_children():
			if "Shield" in block.name:
				var chance_roll = randf_range(0, 100)
				if chance_roll <= block.chance_for_perfect_defense:
					return
	
	_damage -= (_damage * reduction_percent)
	
	health_current = clamp(floor(health_current - _damage), 0, health_max) #Damage is reduced and health is clamped
	
	if health_current == 0: #If health is 0 then the object is dead
		emit_signal("Dead") #We emit the dead signal
		return #Then leave the function
	
	emit_signal("Damaged_Default")
	emit_signal("Damaged", health_current) #If the object doesn't die then they just emit the Damaged signal
	await get_tree().create_timer(0.3).timeout
	is_hurt = false

#This handles healing the object
func _heal(_heal_amount):
	health_current += _heal_amount
	health_current = clamp(floor(health_current), 0, health_max)
	emit_signal("Healed", health_current)

#This handles getting hit by a hazard
func hitbox_hit(area):
	if get_parent().is_in_group("Enemy") and area.is_in_group("Enemy"): 
		return
	
	var damage = area.damage #We grab the damage from the hazard
	_take_damage(damage) #Then we apply the damage to the object

func reset():
	health_current = health_max
	is_hurt = false
