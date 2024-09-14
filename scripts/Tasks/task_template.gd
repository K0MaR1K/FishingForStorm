extends Area3D

var required_object
var task_name: String = "NONAME"

func _on_body_entered(body: Node3D) -> void:
	print(body, "entered", self)
	body.entered_interaction(self)

func _on_body_exited(body: Node3D) -> void:
	body.tasks.erase(self)
