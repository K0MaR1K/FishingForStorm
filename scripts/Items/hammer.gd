extends "res://scripts/Items/item_template.gd"

func _ready():
	my_scene = preload("res://scenes/Items/hammer.tscn")
	is_picked_up = false

func picked_up():
	super.picked_up()
	self.rotation = Vector3(0, 0, -PI/2)

func interact(_delta, task):
	if task.task_name == "repair":
		if not task.deactivated:
			task.repair()
			$AnimationPlayer.play("impact")
