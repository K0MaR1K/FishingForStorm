extends "res://scripts/Items/item_template.gd"

func _ready():
	my_scene = preload("res://scenes/Items/hammer.tscn")
	is_picked_up = false

func picked_up():
	super.picked_up()
	self.rotation = Vector3(0, 0, -PI/2)

func interact(delta, task):
	if task:
		if task.task_name == "repair":
			if task.repaired < 1:
				task.repair(delta)
				$AnimationPlayer.play("impact")
			else:
				task.fully_repaired()
