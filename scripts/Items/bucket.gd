extends "res://scripts/Items/item_template.gd"

var filled: float = 0
var fill_speed: float = 1

var water_start_pos: float = -0.18
var water_end_pos: float = 0.22
var water_start_rad: float = 0.18
var water_end_rad: float = 0.25

@onready var water_mesh: MeshInstance3D = $WaterMesh
@onready var bucket: RigidBody3D = $"."
@onready var walking_particles: GPUParticles3D = $WalkingParticles


func _ready():
	my_scene = preload("res://scenes/Items/bucket.tscn")
	water_mesh.position.y = water_start_pos
	water_mesh.mesh.top_radius = water_start_rad
	water_mesh.mesh.bottom_radius = water_start_rad
	water_mesh.hide()

func interact(delta):
	if filled < 1:
		filled += delta * fill_speed
		water_mesh.show()
		water_mesh.position.y = water_end_pos * filled + water_start_pos * (1 - filled)
		water_mesh.mesh.top_radius = water_end_rad * filled + water_start_rad * (1 - filled)
		water_mesh.mesh.bottom_radius = water_mesh.mesh.top_radius
	
func walk_with(is_walking):
	if filled:
		walking_particles.emitting = is_walking
	
func _process(_delta):
	bucket.global_rotation.x = 0
	bucket.global_rotation.z = 0
