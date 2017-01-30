extends VBoxContainer

var previousNode = null
var soundSlider
var musicSlider
var enableTips
var fullscreen
var g

func _ready():
	g = get_node("/root/SharedVariables");
	soundSlider = self.find_node("SoundVolumeSlider")
	musicSlider = self.find_node("MusicVolumeSlider")
	enableTips = self.find_node("EnableTips")
	fullscreen = self.find_node("FullScreen")

func _draw():
	soundSlider.set_val(AudioServer.get_fx_global_volume_scale())
	musicSlider.set_val(AudioServer.get_stream_global_volume_scale())
	enableTips.set("is_pressed", g._settings["tips"])
	fullscreen.set("is_pressed", OS.is_window_fullscreen())
	find_node("BackButton").grab_focus()

func show_self_and_hide_node(node):
	previousNode = node
	node.hide()
	self.show()

func _on_BackButton_pressed():
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch2")
	self.hide()
	if previousNode:
		previousNode.show()

func _on_SoundVolumeSlider_value_changed(value):
	AudioServer.set_fx_global_volume_scale(value)
	g._settings["sound"] = value
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")

func _on_MusicVolumeSlider_value_changed(value):
	AudioServer.set_stream_global_volume_scale(value)
	g._settings["music"] = value
	get_node("/root/AudioPlayers/SamplePlayer").play("heavy_throw_switch")

func _on_EnableTips_toggled( pressed ):
	g._settings["tips"] = pressed
	self.get_tree().call_group(0, "tips", "SetEnabledTip", pressed)

func _on_FullScreen_toggled( pressed ):
	g._settings["fullscreen"] = pressed
	OS.set_window_fullscreen(pressed)
