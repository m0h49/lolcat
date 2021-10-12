extends KinematicBody2D


const FORCE = 0.5
const DELTA = 0.2
const SPEED = 50

const DEAD_ENEMY = preload("res://Scenes/Enemy/DeadEnemy.tscn")

var velocity = Vector2()
var behaviour = Vector2()

func _ready() -> void:
	randomize()
	var theta = randf() * 2 * PI
	var ampl = (1 + (randf() - 0.5) * DELTA) * FORCE
	behaviour = Vector2(cos(theta), sin(theta)) * ampl

func _physics_process(_delta: float) -> void:
	var toPlayer = ($"../Player".position - position).normalized()
	velocity = (toPlayer + behaviour).normalized() * SPEED
#	move_and_collide(velocity * delta)
	velocity = move_and_slide(velocity)
	orientate()

func orientate():
	if (velocity.y > 0):
		$Body/Eyes.visible = true
	else:
		$Body/Eyes.visible = false

func kill_enemy(var scoring):
	if scoring:
		Global.update_score(1)
	
	var de = DEAD_ENEMY.instance()
	get_parent().add_child(de)
	de.global_position = global_position
	de.start(scoring)
	
	queue_free()

func _on_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.damage_player(1, position)
		kill_enemy(false)

func _on_Detected_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() == true:
			$"../Player".detect_enemy = true


