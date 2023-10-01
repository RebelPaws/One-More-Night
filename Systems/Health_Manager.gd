extends Node3D

signal Damaged
signal Dead
signal Healed
signal ArmorChanged

@export var health_max : float ##This is the most health the object can have.
@onready var health_current = health_max #This is the current health of the object.

@export var armor : float:
	set(val):
		armor = val
		emit_signal("ArmorChanged", val)

func _ready():
	_heal(0)
	armor = armor

#This handles getting the health percent
func _get_percent():
	return (health_current / health_max) * 100

#This handles taking damage
func _take_damage(_damage):
	var reduction_percent = armor * 0.01
	if reduction_percent > 0.9: reduction_percent = 0.9
	
	_damage -= (_damage * reduction_percent)
	
	health_current = clamp(health_current - _damage, 0, health_max) #Damage is reduced and health is clamped
	
	if health_current == 0: #If health is 0 then the object is dead
		emit_signal("Dead") #We emit the dead signal
		return #Then leave the function
	
	emit_signal("Damaged", health_current) #If the object doesn't die then they just emit the Damaged signal

#This handles healing the object
func _heal(_heal_amount):
	health_current = clamp(health_current + _heal_amount, 0, health_max)
	emit_signal("Healed", health_current)

#This handles getting hit by a hazard
func hitbox_hit(area):
	if area.is_in_group("Enemy"): return
	
	var damage = area.damage #We grab the damage from the hazard
	_take_damage(damage) #Then we apply the damage to the object


