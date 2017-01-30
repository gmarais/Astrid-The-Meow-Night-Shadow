extends Container

var gameMenuPanel
var checkPointsPanel
var startTimer

func _ready():
	gameMenuPanel = self.find_node("GameMenuPanel")
	checkPointsPanel = self.find_node("CheckPointsPanel")
	startTimer = self.find_node("StartTimer")
	set_process(true)

func hidePanelAndResume(panel):
	if (gameMenuPanel.is_visible() and checkPointsPanel.is_visible()) == false:
		startTimer.resetAndShow()
	elif panel == gameMenuPanel:
		checkPointsPanel.find_node("Button").grab_focus()
	else:
		gameMenuPanel.find_node("ResumeButton").grab_focus()
	panel.hide()

func _process(delta):
	if Input.is_action_pressed("ui_cancel") and gameMenuPanel.is_visible() == false:
		get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")
		gameMenuPanel.show()
		startTimer.set_process(false)
