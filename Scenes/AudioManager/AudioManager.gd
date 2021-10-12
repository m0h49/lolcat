extends Node

func _process(_delta: float) -> void:
	AudioServer.set_bus_volume_db(0, Global.volume)

func play_music(music):
	$music_player.stream = music
	$music_player.play()

func play_effect(clip):
	var n = $EffectPlayer.get_child_count()
	
	for i in range(n):
		var child = $EffectPlayer.get_child(i)
		if !child.playing:
			child.stream = clip
			child.play()
			return
