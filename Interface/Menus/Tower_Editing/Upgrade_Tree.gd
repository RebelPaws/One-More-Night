extends Control

func select_upgrade(_upgrade):
	pass

func update_info(_upgrade):
	$Info/Upgrade_Name.text = _upgrade.name
	$Info/Upgrade_Description.text = _upgrade.get_node("Description").text
