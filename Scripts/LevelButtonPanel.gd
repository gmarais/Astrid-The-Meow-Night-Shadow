extends VBoxContainer

export(String, FILE, "*.tscn") var level_scene_file
export(String) var level_ID
export(String) var level_name

func _ready():
	self.find_node("LevelButton").set_text(level_name)
	var my_file = File.new()
	my_file.open_encrypted_with_pass("user://" + level_ID + "_Save.enc", File.READ, get_node("/root/SharedVariables")._enc_pass)
	var saved = my_file.get_as_text()
	my_file.close()
	var saved_dic = Dictionary()
	saved_dic.parse_json(saved)
	if typeof(saved_dic) == TYPE_DICTIONARY and saved_dic.has_all(["level", "stars", "score", "sequence"]) and saved_dic["level"] == level_ID:
		self.find_node("NeverPlayed").hide()
		var node = self.find_node("BestScore")
		node.set_text("Best score: " + str(saved_dic["score"]))
		node.show()
		var node = self.find_node("BestSequence")
		node.set_text("Best sequence: " + str(saved_dic["sequence"]))
		node.show()
		if saved_dic["stars"] > 0:
			self.find_node("StarC").show()
		if saved_dic["stars"] > 1:
			self.find_node("StarB").show()
		if saved_dic["stars"] > 2:
			self.find_node("StarA").show()

func _on_level_button_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")
	get_tree().change_scene(level_scene_file)
