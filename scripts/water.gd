extends Node3D

@onready var water_mesh: MeshInstance3D = $WaterMesh

func _ready() -> void:
	Global.is_storm_changed.connect(storm_changed)
	Global.zone_changed.connect(zone_changed)

func storm_changed(value):
	if value:
		water_mesh.mesh.material.set("shader_parameter/Speed1",Vector2(0.01, 0.06))
		water_mesh.mesh.material.set("shader_parameter/Speed2", Vector2(-0.01, 0.02))
		water_mesh.mesh.material.set("shader_parameter/Speed3",Vector2(0.01, 0.06))
		water_mesh.mesh.material.set("shader_parameter/Speed4", Vector2(-0.01, 0.02))
		water_mesh.mesh.material.set("shader_parameter/Multiplier", Vector3(2, 2, 2))
	else:
		water_mesh.mesh.material.set("shader_parameter/Speed1",Vector2(0.01, 0.02))
		water_mesh.mesh.material.set("shader_parameter/Speed2", Vector2(-0.01, -0.01))
		water_mesh.mesh.material.set("shader_parameter/Speed3",Vector2(0.01, 0.02))
		water_mesh.mesh.material.set("shader_parameter/Speed4", Vector2(-0.01, -0.01))
		water_mesh.mesh.material.set("shader_parameter/Multiplier", Vector3(1, 1, 1))
		

func zone_changed(zone):
	await get_tree().create_timer(0.10).timeout
	match zone:
		Global.ZONE.DEADMAN:
			water_mesh.mesh.material.set("shader_parameter/ColorParameter", Color("007396"))
		Global.ZONE.BUCCANEER:
			water_mesh.mesh.material.set("shader_parameter/ColorParameter", Color("004488"))
		Global.ZONE.SEAWITCH:
			water_mesh.mesh.material.set("shader_parameter/ColorParameter", Color("6800f1"))
		Global.ZONE.STORMBREAKER:
			water_mesh.mesh.material.set("shader_parameter/ColorParameter", Color("1d000a"))
