extends "res://Interface/Buttons/Template/button_template.gd"

"""
I made this extra script to make it easier for the upgrade tree script to obtain the
upgrade node and info
"""


signal UpdateInfo
signal SelectUpgrade

func choose_upgrade():
	emit_signal("SelectUpgrade", self)

func update_upgrade_info():
	self.grab_focus()
	emit_signal("UpdateInfo", self)
