extends CanvasLayer

@onready var stormbreaker_button: TextureButton = $StormbreakerButton
@onready var seawitch_button: TextureButton = $SeawitchButton
@onready var deadman_button: TextureButton = $DeadmanButton
@onready var buccaneer_button: TextureButton = $BuccaneerButton

#var bool:

func _ready() -> void:
	hide()

	stormbreaker_button.disabled = false
	seawitch_button.disabled = false
	buccaneer_button.disabled = false
	deadman_button.disabled = true
	Global.zone = Global.ZONE.DEADMAN


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
		Global.hint("CANNOT TRAVEL IN STORM!")
	else:
		stormbreaker_button.disabled = true
		seawitch_button.disabled = false
		buccaneer_button.disabled = false
		deadman_button.disabled = false
		Global.blink_canvas.blink()
		Global.zone = Global.ZONE.STORMBREAKER
		print("STORMBREAKER")


func _on_seawitch_button_pressed() -> void:
	if Global.is_storm:
		Global.hint("CANNOT TRAVEL IN STORM!")
	else:
		stormbreaker_button.disabled = false
		seawitch_button.disabled = true
		buccaneer_button.disabled = false
		deadman_button.disabled = false
		Global.blink_canvas.blink()
		Global.zone = Global.ZONE.SEAWITCH
		print("SEAWITCH")


func _on_buccaneer_button_pressed() -> void:
	if Global.is_storm:
		Global.hint("CANNOT TRAVEL IN STORM!")
	else:
		stormbreaker_button.disabled = false
		seawitch_button.disabled = false
		buccaneer_button.disabled = true
		deadman_button.disabled = false
		Global.blink_canvas.blink()
		Global.zone = Global.ZONE.BUCCANEER
		print("BUCCANEER")


func _on_deadman_button_pressed() -> void:
	if Global.is_storm:
		Global.hint("CANNOT TRAVEL IN STORM!")
	else:
		stormbreaker_button.disabled = false
		seawitch_button.disabled = false
		buccaneer_button.disabled = false
		deadman_button.disabled = true
		Global.blink_canvas.blink()
		Global.zone = Global.ZONE.DEADMAN
		print("DEADMAN")
