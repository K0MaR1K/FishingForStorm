extends "res://scripts/Items/item_template.gd"

var base_price: float = 200.0
var adjusted_price: float = 10.0

func _ready():
	my_scene = preload("res://scenes/fish/fish2.tscn");
	is_picked_up = true

func picked_up():
	super.picked_up()
	self.rotation = Vector3(-PI/4, -PI/2, 0)
