extends RigidBody3D

var water_level: float = 0
var water_pressure: float = 0.5

var water_damp: float = 20
var air_damp: float = 1


@onready var spawn_point: Marker3D = $"../FishingRod/Marker3D"
var spawned: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	get_parent().remove_child.call_deferred(self)
	get_tree().get_root().add_child.call_deferred(self)
	#water_level = get_tree().get_root().get_node("TestScene/Water").global_position.y
	
	

func _process(delta: float) -> void:
	if not spawned:
		self.global_position = spawn_point.global_position
		spawned = true
	if global_position.y < water_level:
		linear_velocity.y += water_pressure * delta
		linear_velocity = lerp(linear_velocity, Vector3.ZERO, water_damp * delta)
	
	move_and_collide(linear_velocity * delta)
