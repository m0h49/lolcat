extends KinematicBody2D

const BALL = preload("res://Scenes/Ball/Ball.tscn")

export var detect_enemy = false

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500
export var STEPBACKFACTOR = 100
export var target = Vector2.ZERO

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var shoot_sound = load("res://Scenes/AudioManager/FireBall.wav")

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready() -> void:
	animationTree.active = true

func _physics_process(delta: float) -> void:
	match state:
		MOVE: move_state(delta)
		ROLL: roll_state()
		ATTACK: attack_state()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() == false:
			if detect_enemy == true:
				target = position
				if (event.position != position):
					if (Global.ammo > 0):
						Global.update_ammo(-1)
						var direction = (event.position - position).normalized()
						var ball = BALL.instance()
						get_parent().add_child(ball)
						ball.global_position = global_position + (20 * direction)
						ball.set_ball_direction(direction)
						AudioManager.play_effect(shoot_sound)
					detect_enemy = false
			elif detect_enemy == false:
				target = event.position

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector = (target - position).normalized()
#	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO and position.distance_to(target) > 10:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	

	if Input.is_action_just_pressed("ui_focus_next"):
		state = ROLL

	if Input.is_action_just_pressed("ui_select"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE
	
func damage_player(var amount, var fromPoint):
	if (!$StepBack.is_playing()):
		$StepBack/Timer.start()
		$StepBack.play("StepBack")
		velocity = (position - fromPoint).normalized() * STEPBACKFACTOR
		Global.update_life(-amount)

