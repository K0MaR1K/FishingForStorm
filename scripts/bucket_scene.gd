extends Node3D

var my_scene = "res://scenes/bucket_scene.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func picked_up():
	queue_free()
