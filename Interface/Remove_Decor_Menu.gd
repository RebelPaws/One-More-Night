extends Control

var target

func enable():
	$Anim.play("Toggle")

func disable():
	$Anim.play_backwards("Toggle")

func update_info(_item, _item_name, _cost):
	$Header.text = "Remove " + _item_name + "?"
	$Remove/Cost.text = str(_cost)
	
	target = _item
	
	enable()


func remove_object():
	target.call_deferred("free")
	disable()


func cancel():
	disable()
