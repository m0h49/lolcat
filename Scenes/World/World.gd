extends Node2D

var _err

var taken_walks = []
var borders = Rect2(1, 1, 16, 8)

const Player = preload("res://Scenes/Player/Player.tscn")

onready var dirt = $DirtTileMap
onready var water = $WaterTileMap

func _ready() -> void:

	randomize()
	generate_level()

func generate_level():
	
	var walker = Walker.new(Vector2(8, 4), borders)
	var map = walker.walk(20)
	
	var player = Player.instance()
	get_node("YSort").add_child(player) # add_child(player)
	
	player.position = map.front() * 16
	player.target = map.front() * 16
	
	walker.queue_free()
	
	for location in map:
		water.set_cellv(location, 0)
	water.update_bitmask_region(borders.position, borders.end)
	
	for x in borders.size.x:
		for y in borders.size.y:
			if map.find(Vector2(x+1, y+1)) == -1:
				if randi() % 2 == 0: # TODO
					taken_walks.append(Vector2(x+1, y+1))
	
	for location in taken_walks:
		location = location * 2
		var rep = location.x
		for y in 2:
			location.y = location.y + y
			for x in 2:
				location.x = location.x + x
				dirt.set_cellv(location, 0)
			location.x = rep
	dirt.update_bitmask_region(borders.position * 2, borders.end * 2)
