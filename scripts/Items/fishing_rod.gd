extends Item

var is_fishing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	my_scene = preload("res://scenes/Items/fishing_rod.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(delta, task):
	if task:
		if task.task_name == "bucket_spill" and !is_fishing:
			is_fishing = true;
