extends RigidBody

var animationPlayer
var model
var gameMenuPanel
var PlayerIsAlive = true
var PlayerScore = 0
var PlayerBestSequence = 0
var CharmsInARow = 0
var reloadingBar
var starReloadingBarFG
var notEnoughEnergyText
var max_speed = 7.25
var jump_speed = 9.0
var forward_acceleration = 65
var side_acceleration = 35
var energy_regen = 35
var energy_side_cost = 35
var grounded = false
var jumping = false
var tick_of_stop

func _ready():
	model = self.find_node("CollisionShape")
	animationPlayer = model.find_node("AnimationPlayer")
	animationPlayer.play("idle")
	self.find_node("Camera").find_node("AnimationPlayer").play("Restore")
	var level = self.get_parent()
	reloadingBar = level.find_node("JumpReloadingBar")
	reloadingBar.set_value(100.0)
	starReloadingBarFG = reloadingBar.find_node("StarFG")
	notEnoughEnergyText = level.find_node("NotEnoughEnergy")
	gameMenuPanel = level.find_node("GameMenuPanel")

func check_if_grounded():
	var space_state = self.get_world().get_direct_space_state()
	var collisions = space_state.intersect_ray(self.get_translation(), self.get_translation() + Vector3(0, -0.3, 0), [self])
	if (collisions.size()):
		grounded = true
	else:
		if jumping:
			jumping = false
		grounded = false

func player_died():
	PlayerIsAlive = false
	var voice = get_node("/root/AudioPlayers/SamplePlayer").play("KittenMeow")
	get_node("/root/AudioPlayers/SamplePlayer").set_pitch_scale(voice, rand_range(0.9, 1.3))
	gameMenuPanel.find_node("GameMenu").hide()
	gameMenuPanel.find_node("ScoreBoard").show()
	gameMenuPanel.show()

func check_if_falling():
	var pos = self.get_translation()
	if pos.y < -2.5:
		player_died()
	if pos.z != 0 and self.get_linear_velocity().z <= 0.1:
		if OS.get_ticks_msec() - tick_of_stop > 200:
			player_died()
	else:
		tick_of_stop = OS.get_ticks_msec()

func _fixed_process(delta):
	check_if_grounded()
	check_if_falling()
	if reloadingBar.get_value() < 100.0:
		reloadingBar.set_value(min(reloadingBar.get_value() + energy_regen * delta, 100.0))
	if reloadingBar.get_value() < 99.0:
		starReloadingBarFG.hide()
	else:
		if starReloadingBarFG.is_visible() == false:
			starReloadingBarFG.show()
		if notEnoughEnergyText.is_visible():
			notEnoughEnergyText.hide()

	var current_velocity = get_linear_velocity()
	current_velocity.z += forward_acceleration * delta
	current_velocity.z = min(max_speed, current_velocity.z)

	if (jumping == false and grounded and Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")):
		if (reloadingBar.get_value() >= 99.0):
			current_velocity.y = jump_speed
			current_velocity.z = max_speed
			jumping = true
			reloadingBar.set_value(max(reloadingBar.get_value() - 99.0, 0.0))
			var voice = get_node("/root/AudioPlayers/SamplePlayer").play("NFF-jump")
			get_node("/root/AudioPlayers/SamplePlayer").set_pitch_scale(voice, rand_range(.9, 1.1))
		else:
			notEnoughEnergyText.show()
	else:
		if (Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right") == false):
			current_velocity.x += side_acceleration * delta * current_velocity.z / max_speed
			current_velocity.x = min(max_speed, current_velocity.x)
			reloadingBar.set_value(max(reloadingBar.get_value() - energy_side_cost * delta, 0.0))
		if (Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left") == false):
			current_velocity.x -= side_acceleration * delta * current_velocity.z / max_speed
			current_velocity.x = max(-max_speed, current_velocity.x)
			reloadingBar.set_value(max(reloadingBar.get_value() - energy_side_cost * delta, 0.0))
	if (current_velocity != get_linear_velocity()):
		set_linear_velocity(current_velocity)
		var anispeed =  current_velocity.z / max_speed * 1.5 + abs(current_velocity.x) / max_speed
		anispeed *= 1.5
		animationPlayer.set_speed(anispeed)
		model.set_rotation(Vector3(model.get_rotation().x, atan2(current_velocity.x, current_velocity.z), model.get_rotation().z))
