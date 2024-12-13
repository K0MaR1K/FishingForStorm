extends "res://scripts/Tasks/task_template.gd"

var starting_rotation

@export var mouse_sens: float = 0.0005

@onready var fishing_line: Node3D = $FishingLine
@onready var floaty: RigidBody3D = $Floaty
@onready var marker_3d: Marker3D = $FishingRod/Marker3D
@onready var fishing_rod: Node3D = $FishingRod
@onready var tension_audio: AudioStreamPlayer3D = $TensionAudio

var fishes: Array[PackedScene] = [
 preload("res://scenes/fish/fish1.tscn"), #3.0 D B
 preload("res://scenes/fish/fish3.tscn"), #10.0 D B SW SB
 preload("res://scenes/fish/fish6.tscn"), #35.0 D B SW
 preload("res://scenes/fish/fish7.tscn"), #50.0 B SW SB
 preload("res://scenes/fish/fish5.tscn"), #80.0 SW SB
 preload("res://scenes/fish/fish4.tscn"), #100.0 SB
 preload("res://scenes/fish/fish2.tscn")] #150.0 SB
var shark = preload("res://scenes/fish/shark.tscn")

var player: PhysicsBody3D
var skeleton: Skeleton3D

var bone_start_pos = [Quaternion(-0.009, -0.001, -0.011, 0.999), Quaternion(.004,0, -0.001, 1), Quaternion(-0.02, 0, 0.003, 0.999)]
var bone_end_pos = [Quaternion(-0.069, -0.001, -0.011, 0.999), Quaternion( -0.146,0, -0.001, 1), Quaternion(-0.255, 0, 0.003, 0.999)]
var marker_start_pos = Vector3(-0.003, 0.408, -2.371)
var marker_end_pos = Vector3(0.25,-0.9, -2.1)

var pull_strength: float = 0
var pull_speed: float = 0.2
var fish_caught: float = 0

var first_fish: bool = true

enum {IDLE, WAIT, HOOK, CATCH}

var state = IDLE

func zone_changed(value):
	match value:
		Global.ZONE.DEADMAN:
			pull_speed = 0.05
		Global.ZONE.BUCCANEER:
			pull_speed = 0.1
		Global.ZONE.SEAWITCH:
			pull_speed = 0.2
		Global.ZONE.STORMBREAKER:
			pull_speed = 0.3

func handle_fish_price():
	var fish
	var f = randf()
	match Global.zone:
		Global.ZONE.DEADMAN:
			if f > 0.9:
				fish = fishes[2].instantiate()
			elif f > 0.5:
				fish = fishes[1].instantiate()
			else:
				fish = fishes[0].instantiate()
			
			var s = randf_range(0.7, 1.3)
			fish.scale = Vector3(s, s, s)
			fish.adjusted_price = fish.base_price + round(5.0 * s)
			
		Global.ZONE.BUCCANEER:
			if f > 0.9:
				fish = fishes[3].instantiate()
			elif f > 0.6:
				fish = fishes[2].instantiate()
			elif f > 0.2:
				fish = fishes[1].instantiate()
			else:
				fish = fishes[0].instantiate()
			
			var s = randf_range(0.7, 1.3)
			fish.scale = Vector3(s, s, s)
			fish.adjusted_price = fish.base_price + round(10.0 * s)
			
		Global.ZONE.SEAWITCH:
			if f > 0.9:
				fish = fishes[4].instantiate()
			elif f > 0.5:
				fish = fishes[3].instantiate()
			elif f > 0.3:
				fish = fishes[2].instantiate()
			else:
				fish = fishes[1].instantiate()
			
			var s = randf_range(0.7, 1.3)
			fish.scale = Vector3(s, s, s)
			fish.adjusted_price = fish.base_price + round(15.0 * s)
			
		Global.ZONE.STORMBREAKER:
			if f > 0.9:
				fish = fishes[6].instantiate()
			elif f > 0.75:
				fish = fishes[5].instantiate()
			elif f > 0.4:
				fish = fishes[4].instantiate()
			elif f > 0.1:
				fish = fishes[3].instantiate()
			else:
				fish = fishes[1].instantiate()
				
			var s = randf_range(0.7, 1.3)
			fish.scale = Vector3(s, s, s)
			fish.adjusted_price = fish.base_price + round(20.0 * s)
			
	if Global.is_storm and randf() > 0.5:
		fish = shark.instantiate()
		
		var s = randf_range(0.7, 1.3)
		fish.scale = Vector3(s, s, s)
		fish.adjusted_price = fish.base_price + round(20.0 * s)
	print(fish.adjusted_price)
	return fish

func end_fishing(win):
	if win:
		if first_fish:
			first_fish = false
			Global.hint("Price of the fish depends on it's rarity")
			Global.interaction_queue.append(Global.interactions["succeed1"])
			
		var fish = handle_fish_price()
		player.hand.add_child(fish)
		Global.fish_caught += 1
	state = IDLE
	player.is_fishing = false
	floaty.hide()
	floaty.freeze = true
	floaty.global_position = marker_3d.global_position
	rotation_degrees.z = starting_rotation
	$FishTimer.stop()
	floaty.fish_pull_timer.stop()
	fishing_line.erase_line()
	line_thrown = false
	pull_strength = 0
	fish_caught = 0
	tension_audio.playing = false
	$AnimationPlayer.stop()
	for i in range(1,4):
		skeleton.set_bone_pose_rotation(i, bone_end_pos[i-1] * pull_strength + bone_start_pos[i-1] * (1 - pull_strength))
		marker_3d.position = marker_end_pos * pull_strength + marker_start_pos * (1 - pull_strength)

var is_fishing: bool = false:
	set(value):
		is_fishing = value
		if is_fishing:
			$FishTimer.start(randf_range(7.0, 15.0))
			floaty.hide()
			floaty.freeze = true
			floaty.global_position = marker_3d.global_position
			$AnimationPlayer.play("throw")
		else:
			end_fishing(false)

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
	Global.zone_changed.connect(zone_changed)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact1") and state != IDLE:
		end_fishing(false)
	
	if line_thrown:
		fishing_line.calc_line()
	elif fishing_line.lines.size():
		fishing_line.erase_line()
		
	
	if state == CATCH:
		handle_tension(delta)
	
func handle_tension(delta):
	
	for i in range(1,4):
		skeleton.set_bone_pose_rotation(i, bone_end_pos[i-1] * pull_strength + bone_start_pos[i-1] * (1 - pull_strength))
		marker_3d.position = marker_end_pos * pull_strength + marker_start_pos * (1 - pull_strength)
		
	fishing_rod.rotation.z = lerp(fishing_rod.rotation.z, -0.7 * floaty.move_ratio + 0.7 * (1 - floaty.move_ratio), delta)
	fishing_rod.rotation.y = lerp(fishing_rod.rotation.y, -PI*2/3 * floaty.move_ratio -PI/4 * (1 - floaty.move_ratio), delta)
	fishing_rod.rotation.y += sin(10 * pull_strength * Time.get_ticks_msec()) * 0.05 * pull_strength
	
	tension_audio.pitch_scale = 1 + 2 * pull_strength
	tension_audio.volume_db = lerp(tension_audio.volume_db, pull_strength * 30 - 30, delta)
	tension_audio.playing = true
	
	if fishing_rod.rotation.z * (floaty.move_ratio - 0.5) < 0:
		if pull_strength < 1:
			pull_strength += delta * pull_speed
		else:
			$PopAudio.play(0.1)
			end_fishing(false)
	else:
		if fish_caught < 1:
			fish_caught += delta * 0.05
		else:
			end_fishing(true)

		if pull_strength > 0:
			pull_strength -= delta * 0.1
	
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
			floaty.fish_move_timer.wait_time = 3
		CATCH:
			pass

func _on_fish_timer_timeout():
	floaty.fish_eating()
	state = HOOK
