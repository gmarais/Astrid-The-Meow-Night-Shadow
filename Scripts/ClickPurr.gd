extends StaticBody

func _input_event(camera, event, click_pos, click_normal, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON:
		get_node("/root/AudioPlayers/SamplePlayer").play("Purring")
