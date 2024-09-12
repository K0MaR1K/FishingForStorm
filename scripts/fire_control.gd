extends Node
class_name FireControl

var fire_task_scene = preload("res://scenes/Tasks/fire_task.tscn")
var fire_positions = []
var striking_ship_positions = []

func _process(_delta):
	if fire_positions.size() >= 12:
		if get_parent().has_method("game_over"):
			get_parent().game_over("Your ship has burned!")

func start_fire(parent_pos: Vector3, new_pos: Vector3) -> bool:
	if fire_positions.is_empty():
		add_fire(parent_pos, new_pos)
		return true
	elif new_pos != Vector3.ZERO and !fire_positions.has(new_pos):
		return false
	else:
		return false
	

func add_fire(parent_pos: Vector3, new_pos: Vector3):
	var fire = fire_task_scene.instantiate()
	add_child(fire)
	fire.global_position = parent_pos
	if new_pos == Vector3.ZERO:
		#first fire position
		fire.my_pos_checked = true
		fire_positions.append(parent_pos)
		fire.my_pos = parent_pos #not sure if this is necessary though
		fire.get_node("CollisionShape3D").disabled = false
	else:
		fire_positions.append(new_pos)
		fire.my_pos = new_pos #not sure if this is necessary though
		var tween = get_tree().create_tween()
		tween.tween_property(fire, "global_position", new_pos, 1.0)
		tween.finished.connect(fire._on_my_position_tween_finished)
	
	
