extends Area3D

var required_object = preload("res://scenes/bucket_scene.tscn")

func _on_body_entered(body: Node3D) -> void:
	print("entered Bucket task")
	body.entered_interaction(self)
