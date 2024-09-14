extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Wave")

func talk():
	animation_player.play("Talk")
	
func wave():
	animation_player.play("Wave")
