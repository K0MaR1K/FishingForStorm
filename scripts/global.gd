extends Node

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer
@onready var blink_canvas: CanvasLayer = $BlinkCanvas
@onready var map_canvas: CanvasLayer = $MapCanvas
@onready var hint_canvas: CanvasLayer = $HintCanvas

signal is_storm_changed(value)
signal zone_changed(value)
var this_zone_storms_survived: int = 0
var overall_storms_survived: int = 0

var is_storm: bool:
	set(value):
		is_storm = value
		is_storm_changed.emit(value)

enum ZONE {DEADMAN, BUCCANEER, SEAWITCH, STORMBREAKER}

var zone: ZONE:
	set(value):
		overall_storms_survived += this_zone_storms_survived
		this_zone_storms_survived = 0;
		zone_changed.emit(value)

func _ready() -> void:
	hint_canvas.hide()
	zone = ZONE.DEADMAN
	blink_timer.wait_time = randf_range(35.0, 60.0)
	blink_timer.start()

func _on_blink_timer_timeout():
	is_storm = !is_storm
	if is_storm:
		blink_timer.wait_time = randf_range(35.0, 60.0)
	else:
		this_zone_storms_survived += 1
		blink_timer.wait_time = randf_range(35.0, 60.0) + (this_zone_storms_survived * 2.0 * zone)
		
	blink_canvas.blink()

func hint(text: String):
	$HintCanvas/HBoxContainer/Label.text = text
	$HintCanvas/AnimationPlayer.play("hint_popup")
