extends Node2D

const ENEMY = preload("res://Scenes/Enemy/Enemy.tscn")

func spawn_enemy():
	var enemy = ENEMY.instance()
	get_parent().add_child(enemy)
	enemy.position = position

func kill():
	queue_free()
