extends "res://scripts/Tasks/task_template.gd"

var repair_speed: float = 0.3
var repaired: float = 0.0
var deactivated: bool = false

signal covered_up

func _ready() -> void:
	required_object = preload("res://scenes/Items/hammer.tscn")
	task_name = "repair"
	$SpillingParticles.emitting = false
	$Hole.hide()
	self.monitoring = false
	$CollisionShape3D.disabled = true
	for plank in $Planks.get_children():
		plank.hide()

func repair(delta):
	repaired += repair_speed * delta

func fully_repaired():
	if !deactivated:
		$SpillingParticles.emitting = false
		var planks = $Planks.get_child_count()
		var plank = $Planks.get_child(randi_range(0, planks - 1))
		plank.show()
		$Hole.hide()
		deactivated = true
		covered_up.emit()

func make_a_hole():
	repaired = 0.0
	$SpillingParticles.emitting = true
	$Hole.show()
	deactivated = false
	self.monitoring = true
	$CollisionShape3D.disabled = false
	for plank in $Planks.get_children():
		plank.hide()
