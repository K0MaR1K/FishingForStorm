extends "res://scripts/Tasks/task_template.gd"

func _ready() -> void:
	required_object = preload("res://scenes/Items/hammer.tscn")
	task_name = "repair"
