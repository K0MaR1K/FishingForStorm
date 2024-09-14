extends CanvasLayer

@onready var stormbreaker_button: TextureButton = $StormbreakerButton
@onready var seawitch_button: TextureButton = $SeawitchButton
@onready var deadman_button: TextureButton = $DeadmanButton
@onready var buccaneer_button: TextureButton = $BuccaneerButton

var sail

var travel_to_stormbreaker = false
var travel_to_seawitch = false
var travel_to_buccaneer = false
var travel_to_deadman = false

func _ready() -> void:
	hide()

	stormbreaker_button.disabled = false
	seawitch_button.disabled = false
	buccaneer_button.disabled = false
	deadman_button.disabled = true
	Global.zone = Global.ZONE.DEADMAN
	
	sail = get_tree().get_root().get_node("TestScene/Ship/Sail")


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
	elif sail.are_sails_down:
		Global.hint("Cannot travel without sails!")
	else:
		if !travel_to_stormbreaker:
			Global.hint("Beware, storms here are cruel!")
			travel_to_stormbreaker = true
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
	elif sail.are_sails_down:
		Global.hint("Cannot travel without sails!")
	else:
		if !travel_to_seawitch:
			Global.hint("They say the water is purple here\n
			from the blood of the Sea Witch")
			travel_to_seawitch = true
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
	elif sail.are_sails_down:
		Global.hint("Cannot travel without sails!")
	else:
		if !travel_to_buccaneer:
			Global.hint("Harder storm means better fish")
			travel_to_buccaneer = true
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
	elif sail.are_sails_down:
		Global.hint("Cannot travel without sails!")
	else:
		if !travel_to_deadman:
			Global.hint("There are no storms here, drill your fishing skills!")
			travel_to_deadman = true
		stormbreaker_button.disabled = false
		seawitch_button.disabled = false
		buccaneer_button.disabled = false
		deadman_button.disabled = true
		Global.blink_canvas.blink()
		Global.zone = Global.ZONE.DEADMAN
		print("DEADMAN")
