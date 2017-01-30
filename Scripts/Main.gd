extends Spatial

func _ready():
	self.find_node("AnimationPlayer").play("idle")
	get_node("/root/AudioPlayers/StreamPlayer").play(0)
	get_node("/root/AudioPlayers/StreamPlayer").set_loop_restart_time(0)
