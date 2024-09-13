extends Node

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer
@onready var blink_canvas: CanvasLayer = $BlinkCanvas

signal is_storm_changed(value)

var is_storm: bool:
	set(value):
		is_storm = value
		is_storm_changed.emit(value)

enum ZONE {DEADMAN, BUCCANEER, SEAWITCH, STORMBREAKER}

var zone: ZONE = ZONE.DEADMAN

func _ready() -> void:
	blink_timer.wait_time = randf_range(35.0, 60.0)
	blink_timer.start()

func _on_blink_timer_timeout():
	blink_timer.wait_time = randf_range(35.0, 60.0)

	is_storm = !is_storm
	blink_canvas.blink()
