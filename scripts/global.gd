extends Node

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer

signal is_storm_changed(value)

var is_storm: bool:
	set(value):
		is_storm = value
		is_storm_changed.emit(value)

enum ZONE {DEADMAN, BUCCANEER, SEAWITCH, STORMBREAKER}

var zone: ZONE = ZONE.DEADMAN

func _on_blink_timer_timeout():
	blink_timer.wait_time = randf_range(15.0, 20.0)
