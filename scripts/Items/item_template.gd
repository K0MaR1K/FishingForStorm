extends Node3D

var my_scene: PackedScene


func interact(_delta):
	print("NO INTERACT")

func walk_with(_is_walking):
	print("NO WALK WITH")

func picked_up():
	queue_free()
