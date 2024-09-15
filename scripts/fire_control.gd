extends Node
class_name FireControl

var fire_task_scene = preload("res://scenes/Tasks/fire_task.tscn")
var fires = []
var striking_ship_positions = []

func _process(_delta):
	if fires.size() >= 24:
		if get_parent().get_parent().has_method("game_over"):
			get_parent().get_parent().game_over("Your ship has burned!")

func start_fire(parent_pos: Vector3, new_pos: Vector3) -> bool:
	if parent_pos == Vector3.ZERO:
		add_fire(parent_pos, new_pos)
		return true
	else:
		for fire in fires:
			if fire:
				if new_pos.distance_to(fire.global_position) < 1:
					return false
		add_fire(parent_pos, new_pos)
		return true
	
func add_fire(parent_pos: Vector3, new_pos: Vector3):
	var fire = fire_task_scene.instantiate()
	add_child(fire)
	fires.append(fire)
	if parent_pos == Vector3.ZERO:
		#first fire position
		fire.global_position = new_pos
		fire.get_node("CollisionShape3D").disabled = false
	else:
		fire.global_position = parent_pos
		var tween = get_tree().create_tween()
		tween.tween_property(fire, "global_position", new_pos, 1.0)
		tween.finished.connect(fire._on_my_position_tween_finished)
	
	
