extends "res://scripts/Tasks/task_template.gd"

func _ready():
	required_object = preload("res://scenes/Items/bucket.tscn")
	task_name = "tank"
