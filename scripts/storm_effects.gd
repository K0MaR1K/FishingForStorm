extends Node3D

var lightning_impact_scene = load("res://scenes/lightning_impact.tscn")
var is_lightning_to_hit_ship = true;
var striking_ship_positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$lightning_timer.start(randf_range(2.0,10.0))
	$lightning.hide()

func _on_lightning_timer_timeout():
	if $lightning.visible:
		$lightning.hide()
		$lightning_timer.start(randf_range(2.0,10.0))
	else:
		if is_lightning_to_hit_ship:
			is_lightning_to_hit_ship = false
			var pos = striking_ship_positions.pick_random()
			striking_ship_positions.erase(pos)
			$lightning.global_position = pos
			$lightning.show()
			$LightningAnimation.play("lightning")
			$lightning_timer.start(0.5)
			var impact = lightning_impact_scene.instantiate();
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
			$LightningAnimation.play("lightning")
			$lightning_timer.start(0.5)
			
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
	
