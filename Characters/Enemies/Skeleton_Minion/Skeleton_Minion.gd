extends "res://Characters/Enemies/Enemy_Core/Enemy.gd"

func _ready():
	$NavigationAgent3D.connect("target_reached", target_reached)
	set_physics_process(false)
	
	get_parent().get_parent().get_parent().connect("Retreat", _retreat)

func _physics_process(delta):
	if state in ["Hurt", "Dead"]: return
	
	if not is_target_reached:
		move()
	elif state != "Attack":
		Attack()
	
	state_check()

func set_state(_new_state):
	if state == _new_state or not active: return
	
	match _new_state:
		"Idle":
			$Anim.play("Idle")
		"Run":
			$Anim.play("Run")
		
		"Attack":
			if can_attack:
				Attack()
		
		"Hurt":
			set_physics_process(false)
			$Sounds/Hurt_Sound.play()
			$Anim.play("Hurt")
			await get_tree().create_timer(0.5).timeout
			set_state("Idle")
			return
		
		"Dead":
			active = false
			set_physics_process(false)
			$Sounds/Death_Sound.play()
			$Anim.play("Death")
			pay_worth()
			await $Anim.animation_finished
			_disable()
	
	state = _new_state

func state_check():
	if velocity.x or velocity.z != 0:
		if state == "Idle":
			set_state("Run")
	
	if velocity.x and velocity.z == 0:
		if state == "Run":
			set_state("Idle")
	
	if is_target_reached:
		set_state("Attack")

func Attack():
	can_attack = false
	set_state("Attack")
	$Sounds/Attack_Sound.play()
	$Anim.play("Attack")
	$DamageBox.toggle_collider()
	await get_tree().create_timer(0.5).timeout
	$DamageBox.toggle_collider()
	await $Anim.animation_finished
	set_state("Idle")

func _on_target_reached():
	set_state("Attack")

func attack_ready():
	can_attack = true
