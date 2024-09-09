extends Node3D

var my_scene: PackedScene

var is_picked_up:
	get():
		return is_picked_up
	set(value):
		is_picked_up = value
		if value:
			picked_up()
		else:
			dropped()


func interact(_delta, _task):
	print("NO INTERACT")

func picked_up():
	self.freeze = true
	
func dropped():
	self.freeze = false
