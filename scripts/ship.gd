extends Node3D
class_name Ship

@onready var lanterns: Node3D = $Lanterns
@onready var repair_timer: Timer = $RepairTimer

var ship_health: float = 100.0
var water_filled: float = 0.0
var water_fill_speed: float = 0.01
var water_drain_speed: float = 0.1

var start_dim_y: float = 0
var end_dim_y: float = 1
var start_pos_y: float = -4.489
var end_pos_y: float = -3.969

var is_storm: 
	set(value):
		if value:
			repair_timer.start()
			$RockingAnimation.play("heavy_rocking")
			for lantern in lanterns.get_children():
				lantern.get_node("Cube/Light").visible = true
		else:
			repair_timer.stop()
			$RockingAnimation.play("light_rocking")
			for lantern in lanterns.get_children():
				lantern.get_node("Cube/Light").visible = false
		is_storm = value
		
var striking_ship_positions: Array:
	get():
		if striking_ship_positions.is_empty():
			for c in $LightningStrikePositions.get_children():
				striking_ship_positions.append(c.global_position)
		return striking_ship_positions

var hole_count: int = 0

func _ready() -> void:
	$RepairTimer.stop()
	$RockingAnimation.play("light_rocking")
	for lantern in lanterns.get_children():
		lantern.get_node("Cube/Light").visible = false
	for repair in $RepairTasks.get_children():
		repair.covered_up.connect(covered_up_a_hole)
	
func drain(delta):
	water_filled -=water_drain_speed * delta
	water_filled = 0 if water_filled <= 0 else water_filled
	
func _process(delta: float) -> void:
	if water_filled < 1:
		water_filled += water_fill_speed * delta * hole_count
	else:
		if get_parent().has_method("game_over"): #is ship in main menu or game?
			get_parent().game_over("Your ship has sunk!")
	var new_size_y = end_dim_y * water_filled + start_dim_y * (1 - water_filled)
	$WaterRising.mesh.size.y = new_size_y
	$WaterRising.position.y = end_pos_y * water_filled + start_pos_y * (1 - water_filled)
	$WaterRising/Area3D/CollisionShape3D.shape.size.y = new_size_y
	
func _on_repair_timer_timeout() -> void:
	match Global.ZONE:
		Global.ZONE.DEADMAN:
			repair_timer.wait_time = randi_range(20, 30)
		Global.ZONE.BUCCANEER:
			repair_timer.wait_time = randi_range(15, 25)
		Global.ZONE.SEAWITCH:
			repair_timer.wait_time = randi_range(10, 15)
		Global.ZONE.STORMBREAKER:
			repair_timer.wait_time = randi_range(5, 15)

	var repairs = $RepairTasks.get_child_count()
	var repair = $RepairTasks.get_child(randi_range(0, repairs - 1))
	hole_count += 1
	repair.make_a_hole()

func covered_up_a_hole():
	hole_count -= 1


func _on_map_area_body_entered(_body: Node3D) -> void:
	Global.map_canvas.open_map()


func _on_map_area_body_exited(_body: Node3D) -> void:
	Global.map_canvas.close_map()
