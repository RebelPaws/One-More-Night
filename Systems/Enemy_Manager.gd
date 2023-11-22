extends Node3D

signal Retreat
@onready var retreat_timer = get_node("Retreat_Timer")
@onready var game_manager = get_parent()

var confirmed_kills = 0

@export_group("Spawn Settings")
var can_spawn = false: #This tells the manager when enemies can spawn
	set(val):
		can_spawn = val
		spawn_enemy()

@export var spawn_time_range = [0.5, 3.0]
@export var spawn_time_range_night : Dictionary = {
	0: [3.0, 6.0],
	3: [2.0, 4.0],
	6: [1.0, 3.0],
	9: [0.5, 3.0]
}

var enemies_spawned = 0

#func _ready():
	#await get_tree().create_timer(5).timeout
	#can_spawn = true

func _toggle(_value):
	match _value:
		true:
			can_spawn = true
			if spawn_time_range_night.has(game_manager.nights_survived):
				spawn_time_range = spawn_time_range_night[game_manager.nights_survived]
				print(spawn_time_range)
			return
		false:
			can_spawn = true
			$Spawn_Timer.stop()
			return

func add_kill():
	confirmed_kills += 1
	enemies_spawned -= 1
	
	get_parent().get_node("Audio/Terror_Param").value = enemies_spawned
	get_parent().get_node("Audio/Terror_Param").trigger()

func spawn_enemy():
	if GameInfo.game_is_in_play == false: return
	if not can_spawn: return
	
	var new_enemy = $Enemy_List.get_child($Enemy_List.get_child_count()-1)._get_unused_object()
	if new_enemy == null: return

	
	$Spawn_Area/Spawn_Position.progress_ratio = randf_range(0, 1)
	var spawn_position = $Spawn_Area/Spawn_Position.global_position
	new_enemy.global_position = spawn_position
	new_enemy.target = get_parent().get_node("Tower/Minion_Target")
	new_enemy.show()
	new_enemy._enable()
	if new_enemy.dead_connected == false:
		new_enemy.get_node("Health_Manager").connect("Dead", add_kill)
		new_enemy.dead_connected = true
	new_enemy.get_node("Health_Manager").reset()
	new_enemy.retreat_pos = spawn_position
	
	$Spawn_Timer.wait_time = randf_range(spawn_time_range[0], spawn_time_range[1])
	$Spawn_Timer.start()
	
	enemies_spawned += 1
	get_parent().get_node("Audio/Terror_Param").value = enemies_spawned
	get_parent().get_node("Audio/Terror_Param").trigger()

func enemies_retreat():
	emit_signal("Retreat")
	if retreat_timer.is_stopped():
		retreat_timer.start(15)


func _on_retreat_timer_timeout():
	for i in $Enemy_List.get_children():
		i._cleanup_active_objects()
