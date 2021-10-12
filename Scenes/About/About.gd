extends Control

var _err

func _ready() -> void:
	$AnimationPlayer.play("Credits")
	yield($AnimationPlayer, "animation_finished")
	_err = get_tree().change_scene("res://Scenes/Menu/Menu.tscn")

