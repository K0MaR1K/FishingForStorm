extends Node3D

var my_scene = preload("res://scenes/bucket_scene.tscn")

@onready var water_mesh: MeshInstance3D = $WaterMesh
@onready var bucket: RigidBody3D = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	water_mesh.hide()

func interact():
	water_mesh.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	bucket.global_rotation.x = 0
	bucket.global_rotation.z = 0

func picked_up():
	queue_free()
