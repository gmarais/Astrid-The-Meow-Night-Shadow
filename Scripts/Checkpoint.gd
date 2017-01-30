extends MeshInstance

export(int, "TIP", "END_OF_LEVEL") var type
export(String, MULTILINE) var message
export(bool) var isMandatory = false

var player
var checkPointsPanel
var g
var triggered = false;

func SetEnabledTip(state):
	if self.type == 0:
		if state == false:
			self.hide()
			set_fixed_process(false)
		else:
			self.show()
			set_fixed_process(true)

func _ready():
	self.g = get_node("/root/SharedVariables")
	if self.isMandatory:
		self.set_mesh(null)
		self.get_child(0).queue_free()
	self.player = self.get_tree().get_root().find_node("Player", true, false)
	if self.type == 0:
		self.add_to_group("tips")
		self.checkPointsPanel = self.get_tree().get_root().find_node("CheckPointsPanel", true, false)
		SetEnabledTip(g._settings["tips"])
	else:
		set_fixed_process(true)

func trigger():
	triggered = true
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")
	var gameMenuPanel = self.player.gameMenuPanel
	if type == 0:
		self.checkPointsPanel.find_node("Label").set_text(message)
		self.checkPointsPanel.show()
	else:
		gameMenuPanel.find_node("GameMenu").hide()
		gameMenuPanel.find_node("ScoreBoard").show()
		gameMenuPanel.show()
		self.queue_free()

func _fixed_process(delta):
	var target = player.get_global_transform().origin
	self.look_at(Vector3(target.x, target.y + 0.25, target.z), Vector3(0,1,0))
	self.rotate_y(3.14159)

	if triggered == false \
	and self.player.get_global_transform().origin.z > self.get_global_transform().origin.z + 0.1 \
	and self.player.get_global_transform().origin.z < self.get_global_transform().origin.z + 1:
		if self.is_visible() and self.isMandatory:
			self.trigger()
			self.queue_free()

func _on_AreaBody_body_enter( body ):
	if triggered == false and self.is_visible() and self.player == body:
		self.trigger()
