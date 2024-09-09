extends "res://scripts/Items/item_template.gd"


func picked_up():
	super.picked_up()
	self.rotation = Vector3(0, 0, -PI/2)
