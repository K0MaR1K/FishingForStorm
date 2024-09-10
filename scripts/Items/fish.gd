extends "res://scripts/Items/item_template.gd"

func _ready():
	my_scene = preload("res://scenes/Items/fish.tscn");
	is_picked_up = true
