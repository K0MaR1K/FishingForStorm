extends Node3D

var ship_health: float = 100.0

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_repair_timer_timeout() -> void:
	var repairs = $RepairTasks.get_child_count()
	var repair = $RepairTasks.get_child(randi_range(0, repairs - 1))
	
	repair.make_a_hole()
