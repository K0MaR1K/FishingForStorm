extends "res://scripts/Tasks/task_template.gd"

var starting_rotation

@export var mouse_sens: float = 0.0005

@onready var fishing_line: Node3D = $FishingLine
@onready var floaty: RigidBody3D = $Floaty
@onready var marker_3d: Marker3D = $FishingRod/Marker3D
@onready var fishing_rod: Node3D = $FishingRod

const FISH = preload("res://scenes/Items/fish.tscn")

var player: PhysicsBody3D
var skeleton: Skeleton3D

var bone_start_pos = [Quaternion(-0.009, -0.001, -0.011, 0.999), Quaternion(.004,0, -0.001, 1), Quaternion(-0.02, 0, 0.003, 0.999)]
var bone_end_pos = [Quaternion(-0.069, -0.001, -0.011, 0.999), Quaternion( -0.146,0, -0.001, 1), Quaternion(-0.255, 0, 0.003, 0.999)]
var marker_start_pos = Vector3(-0.003, 0.408, -2.371)
var marker_end_pos = Vector3(0.25,-0.9, -2.1)

var pull_strength: float = 0
var pull_speed: float = 0
var fish_caught: float = 0

enum {IDLE, WAIT, HOOK, CATCH}

var state = IDLE

var is_fishing: bool = false:
	set(value):
		is_fishing = value
		if is_fishing:
			$fish_timer.start(randf_range(7.0, 15.0))
			floaty.hide()
			floaty.freeze = true
			floaty.global_position = marker_3d.global_position
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
		fishing_rod.rotation.y += -event.relative.x * mouse_sens
		fishing_rod.rotation.z = clamp($FishingRod.rotation.z, -0.7, 0.7)
		fishing_rod.rotation.y = clamp($FishingRod.rotation.y, -PI*2/3, -PI/4)
		
func throw():
	floaty.show()
	floaty.freeze = false
	floaty.global_position = marker_3d.global_position
	floaty.linear_velocity = Vector3(10, 6, 6).normalized() * 12

func _ready() -> void:
	skeleton = fishing_rod.get_node("Armature/Skeleton3D")
	fishing_rod.position = Vector3.ZERO
	player = get_tree().get_root().get_node("TestScene/Player")
	required_object = null
	task_name = "fishing"
	starting_rotation = rotation_degrees.z
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact1") and state != IDLE:
		state = IDLE
		is_fishing = false
		player.is_fishing = false
		pull_strength = 0
		fish_caught = 0
		$AnimationPlayer.stop()
	
	if line_thrown:
		fishing_line.calc_line()
	elif fishing_line.lines.size():
		fishing_line.erase_line()
		
		
	if state == CATCH:
		fishing_rod.rotation.z = lerp(fishing_rod.rotation.z, -0.7 * floaty.move_ratio + 0.7 * (1 - floaty.move_ratio), delta)
		fishing_rod.rotation.y = lerp(fishing_rod.rotation.y, -PI*2/3 * floaty.move_ratio -PI/4 * (1 - floaty.move_ratio), delta)
		fishing_rod.rotation.y += sin(10*pull_strength*Time.get_ticks_msec())*0.05*pull_strength
		if fishing_rod.rotation.z * (floaty.move_ratio - 0.5) < 0:
			if pull_strength < 1:
				pull_strength += delta * pull_speed
			else:
				state = IDLE
				is_fishing = false
				player.is_fishing = false
				pull_strength = 0
				fish_caught = 0
		else:
			if fish_caught < 1:
				fish_caught += delta * 0.05
			else:
				state = IDLE
				is_fishing = false
				player.is_fishing = false
				pull_strength = 0
				fish_caught = 0
				var fish = FISH.instantiate()
				player.hand.add_child(fish)
			if pull_strength > 0:
				pull_strength -= delta * 0.1
	
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
