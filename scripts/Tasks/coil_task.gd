extends "res://scripts/Tasks/task_template.gd"

var is_reverse = false #for not finishing the toggle when releasing too early

var are_sails_down: bool = false:
	set(value):
		get_parent().get_node("Sail").are_sails_down = value
		are_sails_down = value;

func _ready():
	required_object = null;
	task_name = "coil"

func interact():
	if !$AnimationPlayer.is_playing():
		is_reverse = false
		
		if are_sails_down:
			$AnimationPlayer.play("rotate_back")
		else:
			$AnimationPlayer.play("rotate", -1, 1.0)
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
		
func release_interaction():
	if $AnimationPlayer.is_playing():
		is_reverse = true
		$AnimationPlayer.play($AnimationPlayer.current_animation, -1.0, -1.0)
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
			
func _on_body_exited(body):
	super(body)
	release_interaction()

func _on_animation_finished(_anim_name):
	$AnimationPlayer.stop()
	if !is_reverse:
		are_sails_down = !are_sails_down
		
	
