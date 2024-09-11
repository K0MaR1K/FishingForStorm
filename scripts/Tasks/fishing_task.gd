extends "res://scripts/Tasks/task_template.gd"

signal fish_eating

var starting_rotation

@onready var fishing_line: Node3D = $FishingLine
@onready var floaty: RigidBody3D = $Floaty
@onready var marker_3d: Marker3D = $FishingRod/Marker3D

var is_fish_on_hook: bool = false

var is_fishing: bool = false:
	set(value):
		is_fishing = value
		if is_fishing:
			$fish_timer.start(randf_range(7.0, 15.0))
			$AnimationPlayer.play("throw")
		else:
			floaty.hide()
			floaty.freeze = true
			floaty.global_position = marker_3d.global_position
			rotation_degrees.z = starting_rotation
			fishing_line.erase_line()
			line_thrown = false

@export var line_thrown: bool = false

func throw():
	floaty.show()
	floaty.freeze = false
	floaty.global_position = marker_3d.global_position
	floaty.linear_velocity = Vector3(10, 6, 6).normalized() * 15

func _ready() -> void:
	required_object = null
	task_name = "fishing"
	starting_rotation = rotation_degrees.z
	
func _process(_delta: float) -> void:
	if line_thrown:
		fishing_line.calc_line()
	elif fishing_line.lines.size():
		fishing_line.erase_line()
	
func interact() -> bool:
	if is_fishing:
		is_fishing = false
		return true
	elif !is_fishing:
		is_fishing = true
		return false
	else:
		return false

func _on_fish_timer_timeout():
	fish_eating.emit()
