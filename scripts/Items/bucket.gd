extends Item

var filled: float = 0
var fill_speed: float = 1

var water_start_pos: float = -0.18
var water_end_pos: float = 0.22
var water_start_rad: float = 0.18
var water_end_rad: float = 0.25

@onready var water_mesh: MeshInstance3D = $WaterMesh
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
	if water_lvl > 0:
		water_mesh.show()
		water_mesh.position.y = water_end_pos * water_lvl + water_start_pos * (1 - water_lvl)
		water_mesh.mesh.top_radius = water_end_rad * water_lvl + water_start_rad * (1 - water_lvl)
		water_mesh.mesh.bottom_radius = water_mesh.mesh.top_radius
	else:
		water_mesh.hide()

func interact(delta, task):
	if task.task_name == "bucket":
		if filled < 1:
			filled += delta * fill_speed
	elif task.task_name == "bucket_spill" and filled > 0:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", Vector3(deg_to_rad(-120), 0, 0), 0.4)
		
		await tween.finished
		
		spilling_particles.restart()
		
		filled = 0
	water_level(filled)
	
func _process(delta):
	if !spilling_particles.emitting and is_picked_up:
		global_rotation.x = lerp(global_rotation.x, 0.0, delta * 10)
		global_rotation.z = lerp(global_rotation.z, 0.0, delta * 10)

func dropped():
	super.dropped()
	global_rotation.x = 0.0
	global_rotation.z = 0.0
