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
			if get_parent().fire_control == null:
				var fire_control = load("res://scenes/fire_control.tscn").instantiate();
				get_parent().add_child(fire_control);
				fire_control.start_fire(pos, Vector3.ZERO)
			else:
				pass
				get_parent().fire_control.start_fire(pos, Vector3.ZERO)
				
		else:
			$lightning.transform.origin = Vector3(randf_range(-30.0, 30.0),
			randf_range(15.0,30.0), randf_range(-30.0, 30.0))
			$lightning.show()
			$LightningAnimation.play("lightning")
			$lightning_timer.start(0.5)
	
