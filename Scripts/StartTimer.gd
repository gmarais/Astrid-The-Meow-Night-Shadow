extends Label

var countDown = 3
var roundedTime = 3
var player
var uiAnimationPlayer

func _ready():
	get_node("/root/AudioPlayers/StreamPlayer").play(44.7)
	get_node("/root/AudioPlayers/StreamPlayer").set_loop_restart_time(60.044)
	player = self.get_parent().get_parent().find_node("Player")
	uiAnimationPlayer = self.get_parent().get_parent().find_node("UIAnimationPlayer")
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process(true)

func resetAndShow():
	countDown = 2
	roundedTime = 2
	set_text(str(roundedTime))
	set_process(true)
	show()

func _process(delta):
	var desired_pos = self.get_viewport().get_rect().size / 2 - (self.get_size() * self.get_scale()) /2
	if self.get_global_pos() != desired_pos:
		self.set_global_pos(desired_pos)

	countDown -= delta
	var r = round(countDown)
	if r != roundedTime:
		roundedTime = r
		if roundedTime == 0:
			if player:
				if get_tree().is_paused():
					get_tree().set_pause(false)
				if player.get_transform().origin.z == 0:
					player.set_fixed_process(true)
					player.animationPlayer.play("run")
			uiAnimationPlayer.play("UpdateStartTimer")
			set_text("Meow")
		else:
			uiAnimationPlayer.play("UpdateStartTimer")
			set_text(str(roundedTime))
	if countDown <= 0:
		self.set_process(false)
		self.hide()
