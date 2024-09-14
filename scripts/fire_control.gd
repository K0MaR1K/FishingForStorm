extends Node
class_name FireControl

var fire_task_scene = preload("res://scenes/Tasks/fire_task.tscn")
var fire_positions = []
var striking_ship_positions = []

func _process(_delta):
	if fire_positions.size() >= 24:
		if get_parent().get_parent().has_method("game_over"):
			get_parent().get_parent().game_over("Your ship has burned!")

func start_fire(parent_pos: Vector3, new_pos: Vector3) -> bool:
	if parent_pos == Vector3.ZERO:
		add_fire(parent_pos, new_pos)
		return true
	else:
		for fire in fire_positions:
			if new_pos.distance_to(fire) < 1:
				return false
		add_fire(parent_pos, new_pos)
		return true
	
func add_fire(parent_pos: Vector3, new_pos: Vector3):
	var fire = fire_task_scene.instantiate()
	add_child(fire)
	if parent_pos == Vector3.ZERO:
		#first fire position
		fire.global_position = new_pos
		fire_positions.append(parent_pos)
		fire.get_node("CollisionShape3D").disabled = false
	else:
		fire_positions.append(new_pos)
		fire.global_position = parent_pos
		var tween = get_tree().create_tween()
		tween.tween_property(fire, "global_position", new_pos, 1.0)
		tween.finished.connect(fire._on_my_position_tween_finished)
	
	
