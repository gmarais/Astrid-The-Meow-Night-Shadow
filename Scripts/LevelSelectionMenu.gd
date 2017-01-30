extends Control

func _draw():
	find_node("LevelButton", true, false).grab_focus()

func _on_BackButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	self.get_parent().find_node("LandingMenu").show()
	self.hide()
