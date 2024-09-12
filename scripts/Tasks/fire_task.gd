extends "res://scripts/Tasks/task_template.gd"

@onready var check_ship_ray = $check_ship_ray
var another_fire_offset = 2
var fire_growth_time = 4.0
var my_scene = preload("res://scenes/Tasks/fire_task.tscn")
var my_pos_checked: bool = false #this one is only for initial spreading check
var my_pos: Vector3 #gets set in fire_control

var occupied_points = []

var fire_health: float = 0.1:
	set(value):
		fire_health = value;
		if fire_health > 1.0: 
			fire_health = 1.0
		elif fire_health <= 0:
			$CollisionShape3D.disabled = true
			$fire_growth_timer.queue_free()
			$AnimationPlayer.play("dying")
			return
		$fire.draw_pass_1.size = Vector2(fire_health + 0.3, fire_health + 0.3)
		$CollisionShape3D.shape.size = Vector3(fire_health + 1.5, 1, fire_health + 1.5)

func _ready():
	required_object = preload("res://scenes/Items/bucket.tscn")
	task_name = "fire"
	$fire_growth_timer.start(fire_growth_time) #DONT FORGET TO CHANGE
		
func _on_my_position_tween_finished():
	if check_ship_ray.is_colliding():
		global_position = my_pos
		$CollisionShape3D.disabled = false
	else:
		get_parent().fire_positions.erase(my_pos)
		queue_free()
		
func _physics_process(_delta):
	if check_ship_ray.is_colliding():
		if check_ship_ray.get_collider() is Ship:
			if !my_pos_checked:
				var my_new_pos = check_ship_ray.get_collision_point()
				my_pos_checked = true;
				get_parent().fire_pos_checked(my_new_pos)
		else:
			queue_free()
	else:
		queue_free()
		
func get_random_pos() -> Vector3:
	match randi_range(0,7):
		0:
			return transform.origin + Vector3(another_fire_offset, 0, 0);
		1:
			return transform.origin + Vector3(-another_fire_offset, 0, 0)
		2:
			return transform.origin + Vector3(0, 0, another_fire_offset)
		3:
			return transform.origin + Vector3(0, 0, -another_fire_offset)
		4:
			return transform.origin + Vector3(another_fire_offset, 0, another_fire_offset)
		5:
			return transform.origin + Vector3(-another_fire_offset, 0, -another_fire_offset)
		6:
			return transform.origin + Vector3(-another_fire_offset, 0, another_fire_offset)
		_:
			return transform.origin + Vector3(another_fire_offset, 0, -another_fire_offset)

func _on_fire_growth_timer_timeout():
	if fire_health <= 0: return
	if fire_health == 1 and occupied_points.size() < 8:
		var new_pos = get_random_pos()
		if !get_parent().start_fire(transform.origin, new_pos):
			occupied_points.append(new_pos)
			_on_fire_growth_timer_timeout()
		else:
			$fire_growth_timer.start(fire_growth_time)
	elif fire_health < 1.0:
		fire_health += 0.1;
		$fire_growth_timer.start(fire_growth_time)

func _on_animation_player_animation_finished(_anim_name):
	get_parent().fire_positions.erase(my_pos)
	queue_free()
