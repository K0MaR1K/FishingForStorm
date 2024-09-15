extends Node3D
					#THIS IS MAIN MENU
					
var storm_env = load("res://environments/storm_env.tres")
var peace_env = load("res://environments/peace_env.tres")
var storm_effects_scene = load("res://scenes/storm_effects.tscn")
var storm_node;

@onready var ship: Node3D = $Ship
@onready var water: Node3D = $Water
@onready var music_stream = $MusicStream
var water_mesh

var blink_counter: int = 0
var blinks_to_storm: int = 1


func _ready():
	Global.current_game_scene = self
	water_mesh = water.get_node("WaterMesh")
	$WorldEnvironment.environment = peace_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
	Global.is_storm_changed.connect(storm_changed)
	play_music(load("res://assets/sounds_and_music/music.wav"))
	
func play_music(_stream: AudioStream):
	music_stream.stream = _stream;
	music_stream.play()
		
func storm_changed(value):
	await get_tree().create_timer(0.10).timeout
	if value:
		$WorldEnvironment.environment = storm_env
		$WorldEnvironment/DirectionalLight3D.light_energy = 0.05
		storm_node = storm_effects_scene.instantiate()
		add_child(storm_node)
		storm_node.striking_ship_positions = ship.get("striking_ship_positions")
	else:
		$WorldEnvironment.environment = peace_env
		$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
		storm_node.queue_free()
	
func game_over(_reason):
	#rn this function is called from two places
	#1. ship's _proccess function (sinking)
	#2. fire_control's _proccess function (burning)
	#3 ship's sail unpin timer (losing sail)
	Global.main_menu()

func _on_start_button_pressed():
	Global.restart()
	
