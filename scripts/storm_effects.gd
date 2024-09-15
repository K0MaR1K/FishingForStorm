extends Node3D

var lightning_impact_scene = load("res://scenes/lightning_impact.tscn")
var striking_ship_positions = []

var lightning_sounds = [
	load("res://assets/sounds_and_music/sounds/lightning_hit.wav"),
	load("res://assets/sounds_and_music/sounds/lightning_hit2.wav")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$lightning_timer.start(randf_range(2.0,10.0))
	$lightning.hide()
	

func _on_lightning_timer_timeout():
	$lightning/Lightning_strike.stream = lightning_sounds.pick_random();
	if $lightning.visible:
		$lightning.hide()
		$lightning_timer.start(randf_range(2.0,10.0))
	else:
		if is_lightning_to_hit_ship():
			if striking_ship_positions.is_empty(): return
			var pos = striking_ship_positions.pick_random()
			striking_ship_positions.erase(pos)
			$lightning.global_position = pos
			$lightning.show()
			$lightning/Lightning_strike.play()
			$LightningAnimation.play("lightning")
			$lightning_timer.start(0.5)
			var impact = lightning_impact_scene.instantiate();
			for camera in get_tree().get_nodes_in_group("player_camera"):
				camera._camera_shake()
			add_child(impact)
			impact.global_position = pos
			for c in impact.get_children():
				c.emitting = true;
			await get_tree().create_timer(0.6).timeout
			impact.queue_free()
			get_parent().ship.get_node("FireControl").start_fire(Vector3.ZERO, pos)
		else:
			var ship_pos = get_parent().ship.global_position
			$lightning.global_position = generate_random_pos(ship_pos)
			$lightning.show()
			$lightning/Lightning_strike.play()
			$LightningAnimation.play("lightning")
			$lightning_timer.start(0.5)
			
func is_lightning_to_hit_ship():
	var zone_multiplayer = 0.1 + Global.zone * 0.1
	return randf_range(0, 1) > zone_multiplayer
			
func generate_random_pos(ship_pos):
	var potential_pos = Vector3(
		randf_range(-40.0, 40.0),
		randf_range(15.0,40.0), 
		randf_range(-40.0, 40.0)
		)
	if potential_pos.distance_to(ship_pos) < 20:
		return generate_random_pos(ship_pos)
	else:
		return potential_pos
	
func _on_rain_sounds_finished():
	$RainSounds.play()
