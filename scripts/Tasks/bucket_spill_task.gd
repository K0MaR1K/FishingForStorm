extends "res://scripts/Tasks/task_template.gd"

func _ready() -> void:
	required_object = preload("res://scenes/Items/bucket.tscn")
	task_name = "bucket_spill"

func _on_body_entered(body: Node3D) -> void:
	print("entered Bucket Spill task")
	body.entered_interaction(self)
