extends Node3D

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer

var is_storm: bool = false
var storm_env = load("res://environments/storm_env.tres")
var peace_env = load("res://environments/peace_env.tres")
@onready var blink_canvas: CanvasLayer = $BlinkCanvas

var blink_counter: int = 0
var blinks_to_storm: int = 3

func _ready():
	$BlinkCanvas.get_node("AnimationPlayer").animation_finished.connect(_on_anim_finished)
	blink_timer.wait_time = randf_range(15.0, 20.0)

func _process(_delta):
	pass

func _on_blink_timer_timeout():
	blink_timer.wait_time = randf_range(5.0, 8.0)
	blink_timer.wait_time = randf_range(15.0, 20.0)
	blink_canvas.blink()
	
func storm_start():
	$WorldEnvironment.environment = storm_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 0.75
	is_storm = true
	
func storm_end():
	$WorldEnvironment.environment = peace_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
	is_storm = false
	
func _on_anim_finished(anim_name: String):
	if anim_name == "blink":
		if blink_counter < blinks_to_storm:
			blink_counter += 1
		else:
			blink_counter = 0
			if is_storm:
				storm_end()
			else:
				storm_start()
		
		
