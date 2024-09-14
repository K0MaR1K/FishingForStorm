extends Node

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer
@onready var blink_canvas: CanvasLayer = $BlinkCanvas
@onready var map_canvas: CanvasLayer = $MapCanvas
@onready var hint_canvas: CanvasLayer = $HintCanvas

signal is_storm_changed(value)
signal zone_changed(value)

var is_storm: bool:
	set(value):
		is_storm = value
		is_storm_changed.emit(value)

enum ZONE {DEADMAN, BUCCANEER, SEAWITCH, STORMBREAKER}

var zone: ZONE:
	set(value):
		zone = value
		zone_changed.emit(value)

func _ready() -> void:
	hint_canvas.hide()
	zone = ZONE.DEADMAN
	blink_timer.wait_time = randf_range(35.0, 60.0)
	blink_timer.start()

func _on_blink_timer_timeout():
	blink_timer.wait_time = randf_range(35.0, 60.0)

	is_storm = !is_storm
	blink_canvas.blink()

func hint(text: String):
	$HintCanvas/HBoxContainer/Label.text = text
	$HintCanvas/AnimationPlayer.play("hint_popup")
