extends MeshInstance

const rotationSpeed = 3
var player
var camera
var passed = false
var particles
var playerScoreLabel
var playerBestSequenceLabel
var uIAnimationPlayer

func _ready():
	player = self.get_tree().get_root().find_node("Player", true, false)
	camera = player.find_node("Camera")
	set_fixed_process(true)
	particles = player.find_node("Particles")
	playerScoreLabel = player.get_parent().find_node("PlayerScore")
	playerBestSequenceLabel = player.get_parent().find_node("PlayerBestSequence")
	uIAnimationPlayer = player.get_parent().find_node("UIAnimationPlayer")

func _fixed_process(delta):
	var new_rot = get_rotation()
	new_rot.y += rotationSpeed * delta
	set_rotation(new_rot)
	if passed == false:
		if player.get_global_transform().origin.z > self.get_global_transform().origin.z + 0.6:
			passed = true
			if self.is_visible() and player.CharmsInARow > 0:
				player.CharmsInARow = 0

func _on_AreaBody_body_enter( body ):
	if self.is_visible() and "PlayerScore" in body:
		if particles != null:
			particles.set_emitting(true)
		var multiplicator = min(body.CharmsInARow, 5)
		if camera.get_transform().origin.z > 0:
			var voice = get_node("/root/AudioPlayers/SamplePlayer").play("NFF-zing")
			get_node("/root/AudioPlayers/SamplePlayer").set_pitch_scale(voice, 0.8)
			body.PlayerScore += 2 + multiplicator * multiplicator
			body.CharmsInARow += 2
		else:
			get_node("/root/AudioPlayers/SamplePlayer").play("NFF-zing")
			body.PlayerScore += 1 + multiplicator * multiplicator
			body.CharmsInARow += 1
		if body.PlayerBestSequence < body.CharmsInARow:
			body.PlayerBestSequence = body.CharmsInARow
			playerBestSequenceLabel.set_text("Best sequence: " + str(body.PlayerBestSequence))
			uIAnimationPlayer.play("UpdateScoreAndSequence")
		else:
			uIAnimationPlayer.play("UpdateScore")
		playerScoreLabel.set_text("Score: " + str(body.PlayerScore))
		self.hide()
