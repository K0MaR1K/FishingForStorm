extends "res://scripts/Tasks/task_template.gd"

var repair_speed: float = 0.3
var repaired: float = 0.0

func _ready() -> void:
	required_object = preload("res://scenes/Items/hammer.tscn")
	task_name = "repair"

func repair(delta):
	repaired += repair_speed * delta

func fully_repaired():
	$SpillingParticles.emitting = false
	var planks = $Planks.get_child_count()
	var plank = $Planks.get_child(randi_range(0, planks - 1))
	plank.show()
