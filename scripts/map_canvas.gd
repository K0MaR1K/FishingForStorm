extends CanvasLayer

func _ready() -> void:
	hide()

func open_map():
	$OpeningSound.play()
	$AnimationPlayer.play("see_map")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func close_map():
	$ClosingSound.play()
	$AnimationPlayer.play_backwards("see_map")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _on_stormbreaker_button_pressed() -> void:
	if Global.is_storm:
		print("CANNOT TRAVEL IN STORM!")
	else:
		Global.zone = Global.ZONE.STORMBREAKER
		print("STORMBREAKER")


func _on_seawitch_button_pressed() -> void:
	if Global.is_storm:
		print("CANNOT TRAVEL IN STORM!")
	else:
		Global.zone = Global.ZONE.SEAWITCH
		print("SEAWITCH")


func _on_buccaneer_button_pressed() -> void:
	if Global.is_storm:
		print("CANNOT TRAVEL IN STORM!")
	else:
		Global.zone = Global.ZONE.BUCCANEER
		print("BUCCANEER")


func _on_deadman_button_pressed() -> void:
	if Global.is_storm:
		print("CANNOT TRAVEL IN STORM!")
	else:
		Global.zone = Global.ZONE.DEADMAN
		print("DEADMAN")
