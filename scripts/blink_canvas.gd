extends CanvasLayer

@onready var blink_canvas: CanvasLayer = $"."

func _ready() -> void:
	blink_canvas.hide()

func blink():
	$AnimationPlayer.play("blink")
