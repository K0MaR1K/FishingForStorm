extends SoftBody3D

@onready var wrapped_sail = $"../SailWrapped"

var sail_break_stream = load("res://assets/sounds_and_music/sounds/sail_break.wav")
var sail_deploy_stream = load("res://assets/sounds_and_music/sounds/sail_deploy.wav")

var pinned_points = 4;
var sail_unpin_time = 6;
var are_sails_down: bool = false:
	set(value):
		are_sails_down = value
		$AudioStreamPlayer.stream = sail_deploy_stream
		$AudioStreamPlayer.play()
		if are_sails_down:
			lower_sail();
		else:
			raise_sail()
			
func _ready():
	raise_sail()
	match Global.zone:
		Global.ZONE.DEADMAN:
			sail_unpin_time = 10.0
		Global.ZONE.BUCCANEER:
			sail_unpin_time = 6.0
		Global.ZONE.SEAWITCH:
			sail_unpin_time = 5.0
		Global.ZONE.STORMBREAKER:
			sail_unpin_time = 4.0
		
func lower_sail():
	wrapped_sail.show()
	wrapped_sail.set_physics_process(true)
	hide()
	set_physics_process(false)
	
func raise_sail():
	wrapped_sail.set_physics_process(false)
	wrapped_sail.hide()
	show()
	set_physics_process(true)
	
func _on_sail_destruction_timer_timeout():
	if are_sails_down: 
		$sail_destruction_timer.start(sail_unpin_time)
		return
	$AudioStreamPlayer.stream = sail_break_stream
	$AudioStreamPlayer.play()
	match pinned_points:
		4:
			set_point_pinned(0, false)
			pinned_points -= 1;
			$sail_destruction_timer.start(sail_unpin_time * 1.5)
		3:
			set_point_pinned(9, false)
			pinned_points -= 1;
			$sail_destruction_timer.start(sail_unpin_time * 1.5)
		2:
			set_point_pinned(90, false)
			pinned_points -= 1;
			if get_parent().get_parent().has_method("game_over"):
				get_parent().get_parent().game_over("You lost your sail!")
	
			
