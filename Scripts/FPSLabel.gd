extends Label

func _ready():
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process(true)

func _process(delta):
	self.set_text(str(OS.get_frames_per_second()) + " fps")
