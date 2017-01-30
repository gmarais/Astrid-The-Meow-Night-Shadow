extends MeshInstance

var rotation_speed = -3
var player
var camera
var passed = false

func _ready():
	player = self.get_tree().get_root().find_node("Player", true, false)
	camera = player.find_node("Camera")
	set_fixed_process(true)

func _fixed_process(delta):
	var new_rot = get_rotation()
	new_rot.y += rotation_speed * delta
	set_rotation(new_rot)
	if passed == false:
		if player.get_global_transform().origin.z > self.get_global_transform().origin.z + 0.6:
			passed = true

func _on_AreaBody_body_enter( body ):
	if self.is_visible() and "PlayerScore" in body:
		var voice = get_node("/root/AudioPlayers/SamplePlayer").play("NFF-zing")
		get_node("/root/AudioPlayers/SamplePlayer").set_pitch_scale(voice, 0.8)
		get_node("/root/AudioPlayers/SamplePlayer").set_reverb(voice, SamplePlayer.REVERB_SMALL, 0.2)
		if camera.get_transform().origin.z > 0:
			camera.find_node("AnimationPlayer").play("Restore")
		else:
			camera.find_node("AnimationPlayer").play("Reverse")
		self.hide()
