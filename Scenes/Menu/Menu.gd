extends Control

var _err

var optinon_down = false
var music = load("res://Scenes/AudioManager/Music.ogg")

func _ready() -> void:
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.load_score()
	$Score.text = "Score : " + str(Global.score)
	$Best.text = "Best : " + str(Global.best_score)
	
	if Global.music_play == true:
		$MenuOptions/VBoxContainer/Music.pressed = true
		$MenuOptions/VBoxContainer/Music/Label.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	elif Global.music_play == false:
		$MenuOptions/VBoxContainer/Music.pressed = false
		$MenuOptions/VBoxContainer/Music/Label.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
		AudioManager.play_music(null)
	
	if Global.mute == true:
		$MenuOptions/VBoxContainer/Mute.pressed = true
		AudioServer.set_bus_mute(0, true)
		$MenuOptions/VBoxContainer/Mute/Label.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	elif Global.mute == false:
		$MenuOptions/VBoxContainer/Mute.pressed = false
		AudioServer.set_bus_mute(0, false)
		$MenuOptions/VBoxContainer/Mute/Label.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
		
	if Global.fps_output == true:
		$MenuOptions/VBoxContainer/FPS.pressed = true
		$MenuOptions/VBoxContainer/FPS/Label.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	elif Global.fps_output == false:
		$MenuOptions/VBoxContainer/FPS.pressed = false
		$MenuOptions/VBoxContainer/FPS/Label.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	
	$MenuOptions/VBoxContainer/VolumeHSlider.set_value(Global.volume)

func _on_Play_pressed() -> void:
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Play/Play.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	Global.score = 0
	_err = get_tree().change_scene("res://Scenes/World/World.tscn")

func _on_Options_pressed() -> void:
	if optinon_down == true:
		$MenuOptions/Tween.interpolate_property($MenuOptions, "rect_position", Vector2(264, 50), Vector2(264, -200), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		optinon_down = false
		$Options/Options.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	elif optinon_down == false:
		$MenuOptions/Tween.interpolate_property($MenuOptions, "rect_position", Vector2(264, -200), Vector2(264, 50), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		optinon_down = true
		$Options/Options.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	$MenuOptions/Tween.start()

func _on_Quit_pressed() -> void:
	get_tree().quit()

func _on_Mute_pressed() -> void:
	if not Global.mute:
		AudioServer.set_bus_mute(0, true)
		Global.mute = true
		$MenuOptions/VBoxContainer/Mute/Label.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	elif Global.mute:
		AudioServer.set_bus_mute(0, false)
		Global.mute = false
		$MenuOptions/VBoxContainer/Mute/Label.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	Global.save_score() # Save state mute

func _on_Music_pressed() -> void:
	if Global.music_play == false:
		AudioManager.play_music(music)
		Global.music_play = true
		$MenuOptions/VBoxContainer/Music/Label.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	elif Global.music_play == true:
		AudioManager.play_music(null)
		Global.music_play = false
		$MenuOptions/VBoxContainer/Music/Label.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	Global.save_score() # Save state sound

func _on_FPS_pressed() -> void:
	if Global.fps_output == false:
		Global.fps_output = true
		$MenuOptions/VBoxContainer/FPS/Label.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	elif Global.fps_output == true:
		Global.fps_output = false
		$MenuOptions/VBoxContainer/FPS/Label.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	Global.save_score() # Save state fps on/off


func _on_Volume_value_changed(value: float) -> void:
	Global.volume = value
	Global.save_score() # Save state volume

func _on_For_Kids_pressed() -> void:
	$MenuOptions/VBoxContainer/For_Kids/For_Kids.add_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
	_err = get_tree().change_scene("res://Scenes/WorldForKids/WorldForKids.tscn")


func _on_About_pressed() -> void:
	_err = get_tree().change_scene("res://Scenes/About/About.tscn")
