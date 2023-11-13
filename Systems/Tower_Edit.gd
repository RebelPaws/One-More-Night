extends Control

var active = false

var tower_lock_on

func enable(tower_focused):
	return
	if active: return
	
	tower_lock_on = tower_focused
	get_parent().get_node("Build").hide()
	active = true
	var cam = get_parent().get_parent().get_node("Cam_Rig")
	cam.target = tower_focused.get_node("Cam_Anchor")
	cam.lock_zoom = true
	cam.zoom_to(5.0)
	
	if get_parent().get_parent().get_node("Tower").get_last_tower() == tower_focused:
		$Sell.show()
	else:
		$Sell.hide()
	
	$Stats.get_node(tower_lock_on.tower_category).show()
	
	$Anim.play("Toggle")
	get_parent().get_node("Game_Speed/Anim").play_backwards("Toggle")

func disable():
	$Anim.play_backwards("Toggle")
	active = false
	var cam = get_parent().get_parent().get_node("Cam_Rig")
	cam.target = get_parent().get_parent().get_node("Tower")
	cam.lock_zoom = false
	cam.zoom_to(15.0)
	await $Anim.animation_finished
	get_parent().get_node("Game_Speed/Anim").play("Toggle")
	get_parent().get_node("Build").show()
	
	$Stats.get_node(tower_lock_on.tower_category).hide()

func upgrade_tower():
	var _cost = Towers._get_tower_info(tower_lock_on.tower_id, tower_lock_on.tower_category)["Cost"]

func sell_tower():
	var to_refund = Towers.towers[tower_lock_on.tower_id]["Cost"][tower_lock_on.level]
	get_parent().get_parent().modify_currency(to_refund)
	disable()
	await get_tree().create_timer(1.5).timeout
	tower_lock_on.queue_free()
	tower_lock_on = null
