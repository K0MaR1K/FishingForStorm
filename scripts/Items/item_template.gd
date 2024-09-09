extends Node3D

var my_scene: PackedScene


func interact(_delta, _task):
	print("NO INTERACT")

func picked_up():
	queue_free()
