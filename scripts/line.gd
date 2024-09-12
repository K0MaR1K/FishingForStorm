extends Node3D

@export var line_dots = 10	
@onready var marker_3d_2: Marker3D = $"../Floaty/Marker3D2"
@onready var marker_3d: Marker3D = $"../FishingRod/Marker3D"

var lines: Array

func erase_line():
	for line in lines:
		line.queue_free()
		lines.erase(line)
	

func calc_line():
	erase_line()
	var a = 0.01
	var x1 = marker_3d.global_position.x
	var y1 = marker_3d.global_position.y
	var z1 = marker_3d.global_position.z
	var x2 = marker_3d_2.global_position.x
	var y2 = marker_3d_2.global_position.y
	var z2 = marker_3d_2.global_position.z
	var b = (y1 - y2 - a * (x1 ** 2 - x2 ** 2)) / (x1 - x2)
	var c = y1 - a * x1 ** 2 - b * x1
	var v1 = marker_3d.global_position
	for dot in range(1, line_dots+1):
		var x = x1 + (x2 - x1) * dot / line_dots
		var v2 = Vector3(x,
		 a * x ** 2 + b * x + c,
		 z1 + (z2 - z1) * dot / line_dots)
		draw_line(v1, v2)
		v1 = v2
		
func draw_line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child.call_deferred(mesh_instance)
	lines.append(mesh_instance)
