extends VBoxContainer

const CONGRATS_LINES = [
"Marvelous !",
"Splendid !",
"You are awesome !",
"You nailed it !",
"Outstanding !",
"You are made for this !",
"Epic !",
"Truly outrageous !",
"Hell yeah !"
]
var player
var level
var done = false

func _ready():
	level = get_tree().get_root().find_node("World", true, false)
	player = level.find_node("Player")

func calculateStars():
	var stars = 0
	if player.PlayerIsAlive || level.is_looping:
		if level.c_grade_requirement <= player.PlayerBestSequence:
			stars += 1
			self.find_node("Skull").hide()
			self.find_node("StarC").show()
			if level.b_grade_requirement <= player.PlayerBestSequence:
				stars += 1
				self.find_node("StarB").show()
				if level.a_grade_requirement <= player.PlayerBestSequence:
					stars += 1
					self.find_node("StarA").show()
				else:
					self.find_node("Hint").set_text("Next star: " + str(level.a_grade_requirement) + " charms in a row !")
			else:
				self.find_node("Hint").set_text("Next star: " + str(level.b_grade_requirement) + " charms in a row !")
		else:
			if player.PlayerIsAlive:
				self.find_node("Skull").hide()
				self.find_node("ScoreBoardTitle").set_text("Level Completed")
			if level.c_grade_requirement > 1:
				self.find_node("Hint").set_text("First star: " + str(level.c_grade_requirement) + " charms in a row !")
			elif level.c_grade_requirement == 1:
				self.find_node("Hint").set_text("First star: " + str(level.c_grade_requirement) + " charm !")
	return stars

func _draw():
	find_node("RestartButton").grab_focus()
	if done:
		return
	done = true
	var stars = calculateStars()
	get_tree().set_pause(true)
	var score = player.PlayerScore
	var sequence = player.PlayerBestSequence
	self.find_node("Score").set_text("Score: " + str(score))
	self.find_node("BestSequence").set_text("Best sequence: " + str(sequence))
	
	if player.PlayerIsAlive || level.is_looping:
		var my_file = File.new()
		my_file.open_encrypted_with_pass("user://" + str(level.level_ID) + "_Save.enc", File.READ, get_node("/root/SharedVariables")._enc_pass)
		var saved = my_file.get_as_text()
		my_file.close()
		var saved_dic = Dictionary()
		saved_dic.parse_json(saved)
		if typeof(saved_dic) == TYPE_DICTIONARY and saved_dic.has_all(["level", "stars", "score", "sequence"]):
			if (saved_dic["stars"] < stars \
			or saved_dic["score"] < score \
			or saved_dic["sequence"] < sequence):
				my_file.open_encrypted_with_pass("user://" + str(level.level_ID) + "_Save.enc", File.WRITE, get_node("/root/SharedVariables")._enc_pass)
				my_file.store_string({ "level": level.level_ID, "stars": max(stars , saved_dic["stars"]), "score": max(score, saved_dic["score"]), "sequence": max(sequence, saved_dic["sequence"]) }.to_json())
				my_file.close()
				self.get_parent().find_node("NewRecordLabel").show()
			if stars >= 3:
				self.find_node("ScoreBoardTitle").set_text(CONGRATS_LINES[randi() % CONGRATS_LINES.size()])
			elif stars == 2:
				self.find_node("ScoreBoardTitle").set_text("Very good !")
			elif stars == 1:
				self.find_node("ScoreBoardTitle").set_text("Well done !")
		else:
			var new_save = { "level": level.level_ID, "stars": stars, "score": score, "sequence": sequence }
			print(new_save)
			my_file.open_encrypted_with_pass("user://" + str(level.level_ID) + "_Save.enc", File.WRITE, get_node("/root/SharedVariables")._enc_pass)
			my_file.store_string(new_save.to_json())
			my_file.close()
			self.get_parent().find_node("NewRecordLabel").show()
			if stars >= 1:
				self.find_node("ScoreBoardTitle").set_text(CONGRATS_LINES[randi() % CONGRATS_LINES.size()])

func _on_LevelSelectionButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	get_tree().change_scene("res://Scenes/Main.tscn")
	get_node("/root/SharedVariables")._scene_params = "level_selection"
	get_tree().set_pause(false)

func _on_QuitButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	get_tree().change_scene("res://Scenes/Main.tscn")
	get_tree().set_pause(false)

func _on_RestartButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")
	get_tree().reload_current_scene()
	get_tree().set_pause(false)

func _on_SettingsButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	self.get_parent().find_node("SettingsMenu").show_self_and_hide_node(self)
