extends "res://scripts/Tasks/task_template.gd"

var deactivated: bool = false
var started_repair: bool = false

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

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact2"):
		$AnimationPlayer.active = false

func repair():
	if not started_repair:
		var planks = $AnimationPlayer.get_animation_list()
		$AnimationPlayer.play(planks[randi() % planks.size()])
		started_repair = true
	$AnimationPlayer.active = true

func fully_repaired():
	if !deactivated:
		$SpillingParticles.emitting = false
		$Hole.hide()
		deactivated = true
		self.monitoring = false
		$CollisionShape3D.disabled = true
		covered_up.emit()

func make_a_hole():
	$SpillingParticles.emitting = true
	$Hole.show()
	deactivated = false
	self.monitoring = true
	$CollisionShape3D.disabled = false
	started_repair = false
	for plank in $Planks.get_children():
		plank.hide()
