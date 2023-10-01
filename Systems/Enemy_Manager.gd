extends Node3D

var confirmed_kills = 0

@export_group("Spawn Settings")
var can_spawn = false: #This tells the manager when enemies can spawn
	set(val):
		can_spawn = val
		spawn_enemy()

@export var spawn_time_range = [0.2, 1.0]

#func _ready():
	#await get_tree().create_timer(5).timeout
	#can_spawn = true

func _toggle():
	match can_spawn:
		true:
			can_spawn = false
			$Spawn_Timer.stop()
			return
		false:
			can_spawn = true
			return

func add_kill():
	confirmed_kills += 1

func spawn_enemy():
	if GameInfo.game_is_in_play == false: return
	if not can_spawn: return
	
	var new_enemy = $Enemy_List.get_child($Enemy_List.get_child_count()-1)._get_unused_object()
	if new_enemy == null: return
	
	new_enemy.target = get_parent().get_node("Tower/Minion_Target")
	
	$Spawn_Area/Spawn_Position.progress_ratio = randf_range(0, 1)
	var spawn_position = $Spawn_Area/Spawn_Position.global_position
	new_enemy.global_position = spawn_position
	new_enemy.show()
	new_enemy._enable()
	new_enemy.get_node("Health_Manager").connect("Dead", add_kill)
	
	$Spawn_Timer.wait_time = randf_range(spawn_time_range[0], spawn_time_range[1])
	$Spawn_Timer.start()
