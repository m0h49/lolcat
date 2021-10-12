extends Control

var _err

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	_err = get_tree().change_scene("res://Scenes/Menu/Menu.tscn")
