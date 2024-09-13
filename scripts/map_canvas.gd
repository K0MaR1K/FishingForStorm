extends CanvasLayer

func _ready() -> void:
	hide()

func open_map():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$OpeningSound.play()
	$AnimationPlayer.play("see_map")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func close_map():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$ClosingSound.play()
	$AnimationPlayer.play_backwards("see_map")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _on_stormbreaker_button_pressed() -> void:
	print("STORMBREAKER")


func _on_seawitch_button_pressed() -> void:
	print("SEAWITCH")


func _on_buccaneer_button_pressed() -> void:
	print("BUCCANEER")


func _on_deadman_button_pressed() -> void:
	print("DEADMAN")
