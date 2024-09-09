extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$lightning_timer.start(randf_range(2.0,3.0))
	$lightning.hide()

func _on_lightning_timer_timeout():
	if $lightning.visible:
		$lightning.hide()
		$lightning_timer.start(randf_range(2.0,3.0))
	else:
		$lightning.transform.origin = Vector3(randf_range(-30.0, 30.0),
		randf_range(15.0,30.0), randf_range(-30.0, 30.0))
		$lightning.show()
		$lightning_timer.start(0.5)
