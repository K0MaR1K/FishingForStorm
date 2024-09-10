extends Node3D

var ship_health: float = 100.0
var water_filled: float = 0.0
var water_fill_speed: float = 0.01
var water_drain_speed: float = 0.1

var start_y: float = -0.57
var end_y: float = 1

var is_storm: 
	set(value):
		if value:
			$RepairTimer.start()
		else:
			$RepairTimer.stop()
		is_storm = value

var hole_count: int = 0

func _ready() -> void:
	for repair in $RepairTasks.get_children():
		repair.covered_up.connect(covered_up_a_hole)
	

func drain(delta):
	water_filled -=water_drain_speed * delta
	

func _process(delta: float) -> void:
	if water_filled < 1:
		water_filled += water_fill_speed * delta * hole_count
	else:
		print("YOU LOSE")
	$MeshInstance3D.mesh.size.y = end_y * water_filled + start_y * (1 - water_filled)


func _on_repair_timer_timeout() -> void:
	var repairs = $RepairTasks.get_child_count()
	var repair = $RepairTasks.get_child(randi_range(0, repairs - 1))
	hole_count += 1
	repair.make_a_hole()

func covered_up_a_hole():
	hole_count -= 1
