extends Area3D

var time: float

func _physics_process(delta):
	time += delta
	wind_force_magnitude = abs(sin(time * 90) * 4)
