extends RigidBody3D

var water_level: float = 0
var water_pressure: float = 14

var water_damp: float = 13

var fish_on_hook: bool = true

@onready var fish_pull_timer: Timer = $FishPullTimer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	get_parent().remove_child.call_deferred(self)
	get_tree().get_root().add_child.call_deferred(self)
	#water_level = get_tree().get_root().get_node("TestScene/Water").global_position.y
	$"..".fish_eating.connect(fish_eating)
	

func _process(delta: float) -> void:
	if global_position.y < water_level:
		linear_velocity.y += water_pressure * delta
		linear_velocity = lerp(linear_velocity, Vector3.ZERO, water_damp * delta)
	
	move_and_collide(linear_velocity * delta)

func fish_eating():
	fish_pull_timer.start()


func _on_fish_pull_timer_timeout() -> void:
	print("pull")
	linear_velocity.y -= 5
	$PullParticles.restart()
