extends AnimatedSprite

func play_anim(fr: int):
	$"../Body".visible = false
	visible = true
	frame = fr
	if fr == 8:
		visible = false
