extends "res://scripts/Items/item_template.gd"

var hammer_hits = [
	load("res://assets/sounds_and_music/sounds/hammer_hit.wav"),
	load("res://assets/sounds_and_music/sounds/hammer_hit2.wav"),
	load("res://assets/sounds_and_music/sounds/hammer_hit3.wav")
]

func _ready():
	my_scene = preload("res://scenes/Items/hammer.tscn")
	is_picked_up = false

func picked_up():
	super.picked_up()
	self.rotation = Vector3(0, 0, -PI/2)

func interact(_delta, task):
	if task.task_name == "repair":
		if not task.deactivated:
			task.repair()
			if not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("impact")
			if not $AudioStream.playing:
				$AudioStream.stream = hammer_hits.pick_random()
				$AudioStream.play()
