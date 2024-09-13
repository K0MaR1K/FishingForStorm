extends "res://scripts/Tasks/task_template.gd"

@onready var check_ship_ray = $check_ship_ray
var fire_growth_time = 4.0
var my_scene = preload("res://scenes/Tasks/fire_task.tscn")

#var is_spreading: bool = false;
var another_fire_offset = 1.5
var is_falling: bool = true;
var is_dying: bool = false;
var velocity: Vector3 = Vector3.ZERO
var occupied_points = []
var ship_collision

var fire_health: float = 0.1:
	set(value):
		fire_health = value;
		if fire_health > 1.0: 
			fire_health = 1.0
		elif fire_health <= 0:
			kill_fire()
			return
		$fire.draw_pass_1.size = Vector2(fire_health + 0.5, fire_health + 0.5)
		$CollisionShape3D.shape.size = Vector3(fire_health + 1.5, 1, fire_health + 1.5)

func _ready():
	required_object = preload("res://scenes/Items/bucket.tscn")
	task_name = "fire"
	$fire_growth_timer.start(fire_growth_time) #DONT FORGET TO CHANGE
	ship_collision = get_parent().get_parent().get_node("collision")
		
func _physics_process(delta):
	if is_dying: return
	if is_falling:
		if is_on_ground():
			is_falling = false
		else:
			velocity = gravity_direction * gravity * delta
			global_position = global_position + velocity
			
func is_on_ground():
	if $check_ship_ray.is_colliding():
		if $check_ship_ray.get_collider().get_collision_layer() == 16:
			kill_fire()
			return true
		else:
			return true
	return false
	#return $area_for_ship.overlaps_body(ship_collision)
	#var space_state = get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(global_position, global_position + Vector3.DOWN * 0.1)
	#query.collide_with_areas = true
	#var result = space_state.intersect_ray(query)
	#if result:
		#if result.collider.get_collision_layer() == 16: 
			#water
			#kill_fire()
		#return true
	#return false
	
func kill_fire():
	if is_dying: return
	is_dying = true
	$CollisionShape3D.set_deferred("disabled", true)
	$fire_growth_timer.queue_free()
	$AnimationPlayer.play("dying")

func _on_fire_growth_timer_timeout():
	if fire_health <= 0: return
	if fire_health == 1 and occupied_points.size() < 8:
		var new_pos = get_random_pos()
		if !get_parent().start_fire(global_position, new_pos):
			occupied_points.append(new_pos)
			_on_fire_growth_timer_timeout()
		else:
			$fire_growth_timer.start(fire_growth_time)
	elif fire_health < 1.0:
		fire_health += 0.1;
		$fire_growth_timer.start(fire_growth_time)

func _on_animation_player_animation_finished(_anim_name):
	get_parent().fire_positions.erase(global_position)
	queue_free()
	
func _on_my_position_tween_finished():
	if is_on_ground():
		is_falling = false
		get_parent().fire_positions.append(global_position)
		$CollisionShape3D.disabled = false
	else:
		is_falling = true
	
func get_random_pos() -> Vector3:
	match randi_range(0,7):
		0:
			return global_position + Vector3(another_fire_offset, 0, 0);
		1:
			return global_position + Vector3(-another_fire_offset, 0, 0)
		2:
			return global_position + Vector3(0, 0, another_fire_offset)
		3:
			return global_position + Vector3(0, 0, -another_fire_offset)
		4:
			return global_position + Vector3(another_fire_offset, 0, another_fire_offset)
		5:
			return global_position + Vector3(-another_fire_offset, 0, -another_fire_offset)
		6:
			return global_position + Vector3(-another_fire_offset, 0, another_fire_offset)
		_:
			return global_position + Vector3(another_fire_offset, 0, -another_fire_offset)


func _on_area_for_ship_area_entered(_area):
	#water
	kill_fire()


func _on_area_for_ship_body_entered(_body):
	is_falling = false;
