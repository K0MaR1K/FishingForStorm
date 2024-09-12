extends RigidBody3D

enum {IDLE, WAIT, HOOK, CATCH}

var water_level: float = 0
var water_pressure: float = 14

var water_damp: float = 13

var fish_on_hook: bool = true

var far_right: Vector3 = Vector3(1, 0, -1).normalized() * 8
var far_left: Vector3 = Vector3(-1, 0, 1).normalized() * 8
var move_ratio: float

var center: Vector3

var target_pos: Vector3

@onready var fish_move_timer: Timer = $FishMoveTimer
@onready var fish_pull_timer: Timer = $FishPullTimer
@onready var task: Area3D = $".."

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	get_parent().remove_child.call_deferred(self)
	get_tree().get_root().get_node("TestScene").add_child.call_deferred(self)

func _process(delta: float) -> void:
	if global_position.y < water_level:
		linear_velocity.y += water_pressure * delta
		linear_velocity = lerp(linear_velocity, Vector3.ZERO, water_damp * delta)
	if task.state == CATCH:
		global_position = lerp(global_position, target_pos, delta)
	
	move_and_collide(linear_velocity * delta)

func fish_eating():
	center = global_position
	target_pos = center
	fish_pull_timer.start()

func _on_fish_pull_timer_timeout() -> void:
	print("pull")
	linear_velocity.y -= 5
	$PullParticles.restart()


func _on_fish_move_timer_timeout() -> void:
	move_ratio = randf()
	target_pos = center + far_left * move_ratio + far_right * (1 - move_ratio)
