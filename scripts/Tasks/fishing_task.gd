extends "res://scripts/Tasks/task_template.gd"

var starting_rotation

var is_fishing: bool = false:
	set(value):
		is_fishing = value
		if is_fishing:
			rotation_degrees.z = 4.0
			if $fish_timer.is_stopped() and !fish_caught:
				$fish_timer.start(randf_range(2.0, 10.0))
		else:
			rotation_degrees.z = starting_rotation
			
var fish_caught: bool = false;

func _ready() -> void:
	required_object = null
	task_name = "fishing"
	starting_rotation = rotation_degrees.z


func _on_fish_timer_timeout():
	fish_caught = true;
