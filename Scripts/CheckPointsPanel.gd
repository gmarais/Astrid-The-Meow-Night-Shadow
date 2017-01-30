extends Panel

var gameUI

func _ready():
	gameUI = self.get_tree().get_root().find_node("GameUI", true, false)

func _draw():
	get_tree().set_pause(true)
	find_node("Button").grab_focus()

func _on_Button_pressed():
	gameUI.hidePanelAndResume(self)
