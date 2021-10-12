extends Node

var _err

var music_play = true
var mute = false
var fps_output = false
var volume = -30

var max_ammo = 5
var max_life = 5

var ammo = max_ammo
var life = max_life

var score = 0
var best_score = 0

var menu = preload("res://Scenes/Menu/Menu.tscn")

signal ammo_changed(ammo)
signal life_changed(life)
signal game_over

func update_ammo(var delta):
	ammo += delta
	emit_signal("ammo_changed", ammo)

func update_life(var delta):
	life += delta
	emit_signal("life_changed", life)
	if (life <= 0):
		save_score()
		emit_signal("game_over")
#		return_to_menu()

func update_score(var delta):
	score += delta

func return_to_menu():
	ammo = max_ammo
	life = max_life
	_err = get_tree().change_scene_to(menu)

func load_score():
	var save_file = File.new()
	if !save_file.file_exists("user://savegame.save"):
		return 
	save_file.open_encrypted_with_pass("user://savegame.save", File.READ, "ernfeo4534kf")
	
	var data = save_file.get_var()
	score = data["score"]
	best_score = data["best_score"]
	music_play = data["music_play"]
	mute = data["mute"]
	fps_output = data["fps_output"]
	volume = data["volume"]
	save_file.close()

func save_score():
	var save_file = File.new()
	save_file.open_encrypted_with_pass("user://savegame.save", File.WRITE, "ernfeo4534kf")
	
	if score > best_score:
		best_score = score
	
	var data = {
		"score" : score,
		"best_score" : best_score,
		"music_play" : music_play,
		"mute" : mute,
		"fps_output" : fps_output,
		"volume" : volume,
	}
	save_file.store_var(data)
	save_file.close()

