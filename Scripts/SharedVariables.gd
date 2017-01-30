extends Node

var _enc_pass = "wer454qr54aswe5r"
var _scene_params
var _settings = { "sound": 1.0, "music": 1.0, "tips": true , "fullscreen": false}

var cursor_is_relaxed = false
var cursor_relax_image = load("res://Sprites/paw_relax.png")
var cursor_grip_image = load("res://Sprites/paw_grip.png")

func _ready():
	OS.set_target_fps(60)
	set_process(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _process(delta):
	if cursor_is_relaxed and Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		Input.set_custom_mouse_cursor(cursor_grip_image, Vector2(4,6))
		cursor_is_relaxed = false
	elif !cursor_is_relaxed and !Input.is_mouse_button_pressed(BUTTON_LEFT) and !Input.is_mouse_button_pressed(BUTTON_RIGHT):
		Input.set_custom_mouse_cursor(cursor_relax_image, Vector2(4,6))
		cursor_is_relaxed = true

func _enter_tree():
	var my_file = File.new()
	my_file.open_encrypted_with_pass("user://UserSettings.enc", File.READ, _enc_pass)
	var saved_settings = my_file.get_as_text()
	my_file.close()
	if typeof(saved_settings) == TYPE_STRING:
		var saved_settings_dic = Dictionary()
		saved_settings_dic.parse_json(saved_settings)
		if typeof(saved_settings_dic) == TYPE_DICTIONARY and saved_settings_dic.has_all(_settings.keys()):
			for key in _settings:
				_settings[key] = saved_settings_dic[key]
	AudioServer.set_fx_global_volume_scale(_settings["sound"])
	AudioServer.set_stream_global_volume_scale(_settings["music"])
	OS.set_window_fullscreen(_settings["fullscreen"])

func _exit_tree():
	var my_file = File.new()
	my_file.open_encrypted_with_pass("user://UserSettings.enc", File.WRITE, _enc_pass)
	my_file.store_string(_settings.to_json())
	my_file.close()

