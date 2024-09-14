extends Node3D

func _ready() -> void:
	Global.is_storm_changed.connect(change_animation)
	$AnimationPlayer.play("light_rocking")

func change_animation(is_storm):
	$AnimationPlayer.play("hard_rocking" if is_storm else "light_rocking")
