extends Node3D

@onready var storm_timer = $storm_timer
var is_storm: bool = false
var storm_env = load("res://environments/storm_scene.tres")
var peace_env = load("res://environments/test_scene.tres")


func _ready():
	storm_timer.wait_time = randf_range(5.0, 8.0)
	$storm_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_storm_timer_timeout():
	if is_storm:
		storm_end()
	else:
		storm_start()
	
func storm_start():
	$WorldEnvironment.environment = storm_env
	is_storm = true
	storm_timer.wait_time = randf_range(5.0, 8.0)
	
func storm_end():
	$WorldEnvironment.environment = peace_env
	is_storm = false
	storm_timer.wait_time = randf_range(5.0, 8.0)
