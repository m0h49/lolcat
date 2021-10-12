extends KinematicBody2D

const SPEED = 100

var velacity = Vector2()
var destroyed = false

func _physics_process(delta: float) -> void:
	$Sprite.rotation += 180
	var collision = move_and_collide(velacity * delta)
	if collision:
		velacity = velacity.bounce(collision.normal)

func set_ball_direction(direction):
	velacity = direction * SPEED

func kill_ball():
	if (!destroyed):
		destroyed = true
		Global.update_ammo(1)
		call_deferred("free")

func _on_body_entered(body: Node) -> void:
	if body != self:
		if "Ball" in body.name:
			body.kill_ball()
			kill_ball()
		if "Enemy" in body.name:
			body.kill_enemy(true)
		if "Player" in body.name:
			body.damage_player(1, position)
			kill_ball()
