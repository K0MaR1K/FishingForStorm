extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var talking_timer: Timer = $TalkingTimer

func _ready() -> void:
	animation_player.play("Wave")
	$Text.show()
	$Text/SubViewport/Label.text = "Hey there!"
	talking_timer.start()
	
	
func talk(text: String):
	animation_player.play("Talk")
	$Text.show()
	$Text/SubViewport/Label.text = text
	talking_timer.start()
	
func wave():
	animation_player.play("Wave")


func _on_talking_timer_timeout() -> void:
	$Text.hide()
