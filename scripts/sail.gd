extends SoftBody3D

@onready var wrapped_sail = $"../SailWrapped"

var pinned_points = 4;
var sail_unpin_time = 6;
var are_sails_down: bool = false:
	set(value):
		are_sails_down = value
		if are_sails_down:
			lower_sail();
		else:
			raise_sail()
			
func _ready():
	raise_sail()
		
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
	match pinned_points:
		4:
			set_point_pinned(0, false)
			pinned_points -= 1;
			$sail_destruction_timer.start(sail_unpin_time * 2)
		3:
			set_point_pinned(9, false)
			pinned_points -= 1;
			$sail_destruction_timer.start(sail_unpin_time * 2)
		2:
			set_point_pinned(90, false)
			pinned_points -= 1;
			if get_parent().get_parent().has_method("game_over"):
				get_parent().get_parent().game_over("You lost your sail!")
			
