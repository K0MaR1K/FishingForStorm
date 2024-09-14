extends Node3D

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
	water_mesh = water.get_node("WaterMesh")
	$WorldEnvironment.environment = peace_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
	$Player.get_node("rain").hide()
	ship.get_node("DroppedItems").body_entered.connect(_on_body_overboard)
	Global.is_storm_changed.connect(storm_changed)
	play_music(load("res://assets/sounds_and_music/music.wav"))
	Global.zone_changed.connect(zone_changed)
	
func play_music(_stream: AudioStream):
	music_stream.stream = _stream;
	music_stream.play()
	
func _input(event):
	if event.is_action_pressed("restart"):
		restart()
		
func restart():
	get_tree().change_scene_to_packed(load("res://scenes/test_scene.tscn"))
	
func _on_body_overboard(body: Node3D):
	if body is Player:
		body.global_position = $PlayerRespawn.global_position
	else:
		body.global_position = ship.get_node("DroppedItems/ItemsRespawn").global_position
		body.linear_velocity = Vector3.ZERO
		
func zone_changed(value):
	await get_tree().create_timer(0.10).timeout
	if value == Global.ZONE.DEADMAN:
		$Store.enable()
	else:
		$Store.disable()
		
func storm_changed(value):
	await get_tree().create_timer(0.10).timeout
	if value:
		$WorldEnvironment.environment = storm_env
		$WorldEnvironment/DirectionalLight3D.light_energy = 0.05
		storm_node = storm_effects_scene.instantiate()
		add_child(storm_node)
		storm_node.striking_ship_positions = ship.get("striking_ship_positions")
		$Player.get_node("rain").show()
	else:
		$WorldEnvironment.environment = peace_env
		$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
		storm_node.queue_free()
		$Player.get_node("rain").hide()
	
func game_over(reason):
	#rn this function is called from two places
	#1. ship's _proccess function (sinking)
	#2. fire_control's _proccess function (burning)
	#3 ship's sail unpin timer (losing sail)
	$Player.get_node("Head/Camera3D").current = false;
	$Player.set_process(false);
	$TransitionCamera.current = true;
	play_music(load("res://assets/sounds_and_music/game_over.wav"))
	$UICanvas.game_over(reason)
