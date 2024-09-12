extends "res://scripts/Tasks/task_template.gd"

var starting_rotation

@export var mouse_sens: float = 0.001

@onready var fishing_line: Node3D = $FishingLine
@onready var floaty: RigidBody3D = $Floaty
@onready var marker_3d: Marker3D = $FishingRod/Marker3D
@onready var fishing_rod: Node3D = $FishingRod

var player: PhysicsBody3D
var skeleton: Skeleton3D

var bone_start_pos = [Quaternion(-0.009, -0.001, -0.011, 0.999), Quaternion(.004,0, -0.001, 1), Quaternion(-0.02, 0, 0.003, 0.999)]
var bone_end_pos = [Quaternion(-0.069, -0.001, -0.011, 0.999), Quaternion( -0.146,0, -0.001, 1), Quaternion(-0.255, 0, 0.003, 0.999)]
var marker_start_pos = Vector3(-0.003, 0.408, -2.371)
var marker_end_pos = Vector3(0.25,-0.9, -2.1)

var pull_strength: float = 0

enum {IDLE, WAIT, HOOK, CATCH}

var state = IDLE

var is_fishing: bool = false:
	set(value):
		is_fishing = value
		if is_fishing:
			$fish_timer.start(randf_range(7.0, 15.0))
			$AnimationPlayer.play("throw")
		else:
			floaty.hide()
			floaty.freeze = true
			floaty.global_position = marker_3d.global_position
			rotation_degrees.z = starting_rotation
			fishing_line.erase_line()
			line_thrown = false

@export var line_thrown: bool = false

func _input(event):
	if event is InputEventMouseMotion and state != IDLE:
		fishing_rod.rotation.z += -event.relative.x * mouse_sens
		fishing_rod.rotation.z = clamp($FishingRod.rotation.z, -0.4, 0.7)
		
func throw():
	floaty.show()
	floaty.freeze = false
	floaty.global_position = marker_3d.global_position
	floaty.linear_velocity = Vector3(10, 6, 6).normalized() * 10

func _ready() -> void:
	skeleton = fishing_rod.get_node("Armature/Skeleton3D")
	fishing_rod.position = Vector3.ZERO
	player = get_tree().get_root().get_node("TestScene/Player")
	required_object = null
	task_name = "fishing"
	starting_rotation = rotation_degrees.z
	
func _process(delta: float) -> void:
	if line_thrown:
		fishing_line.calc_line()
	elif fishing_line.lines.size():
		fishing_line.erase_line()
		
	if state != IDLE:
		if pull_strength < 1:
			pull_strength += delta * 0.01
	
	for i in range(1,4):
		skeleton.set_bone_pose_rotation(i, bone_end_pos[i-1] * pull_strength + bone_start_pos[i-1] * (1 - pull_strength))
		marker_3d.position = marker_end_pos * pull_strength + marker_start_pos * (1 - pull_strength)
	
func interact() -> void:
	match state:
		IDLE:
			is_fishing = true
			player.is_fishing = true
			state = WAIT
		WAIT:
			pass
		HOOK:
			state = CATCH
			floaty.fish_pull_timer.stop()
			floaty.fish_move_timer.start()
		CATCH:
			pass

func _on_fish_timer_timeout():
	floaty.fish_eating()
	state = HOOK
