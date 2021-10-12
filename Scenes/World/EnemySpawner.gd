extends Node2D

const WIDTH = 576-47 #1920 - (120 + 120) #1712 # 1712 + 104 = 104
const HEIGHT = 304-36 #1080 - 200 #832 + 64 # 832 + 184 + 64
const ENEMY = preload("res://Scenes/Enemy/SpawningEnemy.tscn")

var spawnArea = Rect2()

# Spawn time management
var delta = 2
var offset = 0.5

func _ready() -> void:
	randomize()
	spawnArea = Rect2(0, 0, WIDTH, HEIGHT)
	set_next_spawn()

func spawn_enemy():
	var position = Vector2(randi() % WIDTH + 47, randi() % HEIGHT + 36)
	
	var cell_coord = $"../WaterTileMap".world_to_map(position)
	var cell_type_id = $"../WaterTileMap".get_cellv(cell_coord)
	if cell_type_id != $"../WaterTileMap".tile_set.find_tile_by_name("WaterAnim.tres 0"):
		var enemy = ENEMY.instance()
		enemy.position = position
		$"../YSort".add_child(enemy)
		return position

func set_next_spawn():
	var nextTime = delta + (randf() - 0.5) * 2 * offset
	$Timer.wait_time = nextTime
	$Timer.start()

func _on_timeout() -> void:
	spawn_enemy()
	set_next_spawn()

#func _draw() -> void:
#	var radius = 20
#	draw_rect(spawnArea, Color(0.2, 0.2, 1.0, 0.5))
#
#	for i in range(25):
#		draw_circle(spawn_enemy(), radius, Color.red)
