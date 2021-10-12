extends CanvasLayer

var _err

onready var debag = $debag
func _add_text_debag(text_value : String) -> void:
	debag.text += text_value + "\n"

func _ready() -> void:
	MobileAds.request_user_consent()
	_err = MobileAds.connect("consent_info_update_failure", self, "_on_MobileAds_consent_info_update_failure")
	_err = MobileAds.connect("consent_status_changed", self, "_on_MobileAds_consent_status_changed")
	
	_err = MobileAds.connect("rewarded_ad_loaded", self, "_on_MobileAds_rewarded_ad_loaded")
	_err = MobileAds.connect("rewarded_ad_failed_to_load", self, "_on_MobileAds_rewarded_ad_failed_to_load" )
	_err = MobileAds.connect("user_earned_rewarded", self, "_on_MobileAds_user_earned_rewarded")
	_err = MobileAds.connect("rewarded_ad_closed", self, "_on_MobileAds_rewarded_ad_closed")
	
	MobileAds.load_rewarded("lolcat_rewarded")
	
	_err = Global.connect("ammo_changed", self, "update_GUI_ammo")
	_err = Global.connect("life_changed", self, "update_GUI_life")
	_err = Global.connect("game_over", self, "game_over")
	update_GUI_ammo(Global.ammo)
	update_GUI_life(Global.life)
	
	$OverContainer/GameOver/Continue.disabled = true

func _process(_delta: float) -> void:
	$CenterContainer.visible = Global.fps_output
	if Global.fps_output:
		$CenterContainer/FPS.set_text("FPS: " + str(Engine.get_frames_per_second()))

func update_GUI_ammo(var ammo) -> void:
	for N in $RightContainer/Balls.get_children():
		if (int(N.name) <= ammo):
			N.visible = true
		else:
			N.visible = false

func update_GUI_life(var life) -> void:
	for N in $LeftContainer/Hearts.get_children():
		if (int(N.name) <= life):
			N.visible = true
		else:
			N.visible = false

func game_over() -> void:
	get_tree().paused = true
	$OverContainer/AnimationHide.play("GameOver")
	$OverContainer/GameOver.popup_centered()
	$OverContainer/GameOver.popup()

func _on_Continue_pressed() -> void:
	MobileAds.show_rewarded()
	$OverContainer/GameOver/Continue.disabled = true
	_add_text_debag("press continue")

func _on_Cancel_pressed() -> void:
	Global.return_to_menu()
	get_tree().paused = false
	$OverContainer/GameOver.hide()

func _on_MobileAds_user_earned_rewarded(currency : String, amount : int) -> void:
	Global.update_life(amount)
	$OverContainer/AnimationHide.play("RESET")
	$OverContainer/GameOver.visible = false
	get_tree().paused = false
	MobileAds.load_rewarded("lolcat_rewarded")
	_add_text_debag("earned rewarded done: " + currency + " " + str(amount))

func _on_MobileAds_rewarded_ad_loaded() -> void:
	$OverContainer/GameOver/Continue.disabled = false
	_add_text_debag("loaded rewarded done")

func _on_MobileAds_rewarded_ad_failed_to_load() -> void:
	$OverContainer/GameOver/Continue.disabled = true
	MobileAds.load_rewarded("lolcat_rewarded")
	_add_text_debag("loaded rewarded failed")



func _on_MobileAds_consent_info_update_failure(_error_code : int, error_message : String) -> void:
	_add_text_debag("consent update failure:")
	_add_text_debag(str(_error_code) + " " + error_message)

func _on_MobileAds_consent_status_changed(status_message : String) -> void:
	_add_text_debag("consent status changed:")
	_add_text_debag(status_message)
	
