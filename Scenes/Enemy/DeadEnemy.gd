extends Node2D

var tween
var scoring

func start(var _scoring):
	self.scoring = _scoring
	if (scoring):
		$AnimationPlayer.play("Score")

func _ready() -> void:
	$Label.text = str(Global.score)
#	$Tween.interpolate_property(self, "tween", -1.0, 1.0, 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(self, "tween", 0, 8, 0.36, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	
#func _process(_delta: float) -> void:
#	$Body.material.set_shader_param("DissolveRate", tween)
func _process(_delta: float) -> void:
	$AnimatedSprite.play_anim(tween)

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	if (!scoring):
		queue_free()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if (anim_name == "Score"):
		queue_free()
