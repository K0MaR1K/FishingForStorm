extends Node3D

var my_scene: PackedScene


func interact(_delta):
	pass

func picked_up():
	queue_free()
