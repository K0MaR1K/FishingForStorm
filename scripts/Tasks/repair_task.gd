extends "res://scripts/Tasks/task_template.gd"

var repair_speed: float = 0.3
var repaired: float = 0.0

func _ready() -> void:
	required_object = preload("res://scenes/Items/hammer.tscn")
	task_name = "repair"

func repair(delta):
	if repaired < 1:
		repaired += repair_speed * delta
	else:
		print("repaired")
