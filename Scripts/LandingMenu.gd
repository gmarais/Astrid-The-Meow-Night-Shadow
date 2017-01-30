extends Control

var g

func _ready():
	g = get_node("/root/SharedVariables");
	if g._scene_params == "level_selection":
		g._scene_params = null
		self.get_parent().find_node("LevelSelectionMenu").show()
		self.get_parent().find_node("LandingMenu").hide()

func _draw():
	find_node("ChooseLevelButton").grab_focus()

func _on_ChooseLevelButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	self.get_parent().find_node("LevelSelectionMenu").show()
	self.hide()

func _on_QuitButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	OS.delay_msec(400)
	get_tree().quit()

func _on_SettingsButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	self.get_parent().find_node("SettingsMenu").show_self_and_hide_node(self)

func _on_CreditsButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	self.get_parent().find_node("CreditsMenu").show()
	self.hide()
