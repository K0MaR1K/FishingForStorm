extends "res://scripts/Items/item_template.gd"

func _ready():
	my_scene = preload("res://scenes/Items/fish.tscn");
	is_picked_up = true

func picked_up():
	super.picked_up()
	self.rotation = Vector3(-PI/4, -PI/2, 0)
