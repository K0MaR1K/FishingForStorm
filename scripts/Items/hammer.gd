extends "res://scripts/Items/item_template.gd"

func _ready():
	my_scene = preload("res://scenes/Items/hammer.tscn")
	is_picked_up = false

func picked_up():
	super.picked_up()
	self.rotation = Vector3(0, 0, -PI/2)
