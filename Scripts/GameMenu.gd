extends VBoxContainer

var gameUI

func _ready():
	gameUI = self.get_tree().get_root().find_node("GameUI", true, false)

func _draw():
	get_tree().set_pause(true)
	find_node("ResumeButton").grab_focus()

func _on_LevelSelectionButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	get_tree().change_scene("res://Scenes/Main.tscn")
	get_node("/root/SharedVariables")._scene_params = "level_selection"
	get_tree().set_pause(false)

func _on_QuitButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	get_tree().change_scene("res://Scenes/Main.tscn")
	get_tree().set_pause(false)

func _on_ResumeButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")
	gameUI.hidePanelAndResume(self.get_parent())

func _on_RestartButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")
	get_tree().reload_current_scene()
	get_tree().set_pause(false)

func _on_SettingsButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	self.get_parent().find_node("SettingsMenu").show_self_and_hide_node(self)
