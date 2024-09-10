extends Node3D

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer

var is_storm: bool = false
var storm_env = load("res://environments/storm_env.tres")
var peace_env = load("res://environments/peace_env.tres")
var storm_effects_scene = load("res://scenes/storm_effects.tscn")
var storm_node;
@onready var blink_canvas: CanvasLayer = $BlinkCanvas

var blink_counter: int = 0
var blinks_to_storm: int = 1

func _ready():
	blink_timer.wait_time = randf_range(15.0, 20.0)

func _process(_delta):
	pass

func _on_blink_timer_timeout():
	blink_timer.wait_time = randf_range(15.0, 20.0)
		
	if blink_counter < blinks_to_storm:
		blink_counter += 1
	else:
		blink_counter = 0
		if is_storm:
			storm_end()
		else:
			storm_start()
			
	blink_canvas.blink()
	
func storm_start():
	await get_tree().create_timer(0.10).timeout
	$WorldEnvironment.environment = storm_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 0.75
	storm_node = storm_effects_scene.instantiate()
	add_child(storm_node)
	$Player.get_node("rain").show()
	is_storm = true
	
func storm_end():
	await get_tree().create_timer(0.10).timeout
	$WorldEnvironment.environment = peace_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
	storm_node.queue_free()
	$Player.get_node("rain").hide()
	is_storm = false
