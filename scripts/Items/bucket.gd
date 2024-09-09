extends "res://scripts/Items/item_template.gd"

var filled: float = 0
var fill_speed: float = 1

var water_start_pos: float = -0.18
var water_end_pos: float = 0.22
var water_start_rad: float = 0.18
var water_end_rad: float = 0.25

@onready var water_mesh: MeshInstance3D = $WaterMesh
@onready var bucket: RigidBody3D = $"."
@onready var spilling_particles: GPUParticles3D = $SpillingParticles

var spilling_water: bool = false

func _ready():
	my_scene = preload("res://scenes/Items/bucket.tscn")
	water_mesh.position.y = water_start_pos
	water_mesh.mesh.top_radius = water_start_rad
	water_mesh.mesh.bottom_radius = water_start_rad
	water_mesh.hide()
	spilling_particles.emitting = false

func water_level(water_lvl):
	water_mesh.show()
	water_mesh.position.y = water_end_pos * water_lvl + water_start_pos * (1 - water_lvl)
	water_mesh.mesh.top_radius = water_end_rad * water_lvl + water_start_rad * (1 - water_lvl)
	water_mesh.mesh.bottom_radius = water_mesh.mesh.top_radius

func interact(delta, task):
	if task:
		if task.required_object == my_scene:
			if filled < 1:
				filled += delta * fill_speed
			else:
					var tween = get_tree().create_tween()
					tween.tween_property(bucket, "rotation", Vector3(deg_to_rad(-120), 0, 0), 0.4)
					
					await tween.finished
					
					spilling_particles.restart()
					
					filled = 0
					
					await get_tree().create_timer(0.5).timeout
					tween = get_tree().create_tween()
					tween.tween_property(bucket, "rotation", Vector3(0, 0, 0), 0.3)
			water_level(filled)
	
func _process(delta):
	bucket.global_rotation.x = lerp(bucket.global_rotation.x, 0.0, delta * 10)
	bucket.global_rotation.z = lerp(bucket.global_rotation.z, 0.0, delta * 10)
