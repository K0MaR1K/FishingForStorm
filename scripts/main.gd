extends Node3D

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer

var is_storm: bool = false
var storm_env = load("res://environments/storm_env.tres")
var peace_env = load("res://environments/peace_env.tres")
var storm_effects_scene = load("res://scenes/storm_effects.tscn")
var storm_node;

@onready var blink_canvas: CanvasLayer = $BlinkCanvas
@onready var ship: Node3D = $Ship
@onready var fire_control = $FireControl
@onready var water: Node3D = $Water
var water_mesh

var blink_counter: int = 0
var blinks_to_storm: int = 1


func _ready():
	water_mesh = water.get_node("WaterMesh")
	blink_timer.wait_time = randf_range(5.0, 10.0)
	$WorldEnvironment.environment = peace_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
	$Player.get_node("rain").hide()
	$UICanvas.hide()
	water_mesh.mesh.material.set("shader_parameter/Speed1",Vector2(0.01, 0.02))
	water_mesh.mesh.material.set("shader_parameter/Speed2", Vector2(-0.01, -0.01))
	water_mesh.mesh.material.set("shader_parameter/Speed3",Vector2(0.01, 0.02))
	water_mesh.mesh.material.set("shader_parameter/Speed4", Vector2(-0.01, -0.01))
	water_mesh.mesh.material.set("shader_parameter/Multiplier", Vector3(1, 1, 1))

func _process(_delta):
	pass

func _on_blink_timer_timeout():
	blink_timer.wait_time = randf_range(15.0, 20.0)
		
	if blink_counter < blinks_to_storm:
		blink_counter += 1
	else:
		blink_counter = 0
		if is_storm:
			storm_end()
		else:
			storm_start()
			
	blink_canvas.blink()
	
func storm_start():
	await get_tree().create_timer(0.10).timeout
	$WorldEnvironment.environment = storm_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 0.05
	storm_node = storm_effects_scene.instantiate()
	add_child(storm_node)
	if fire_control.striking_ship_positions.is_empty():
		for c in ship.get_node("LightningStrikePositions").get_children():
			fire_control.striking_ship_positions.append(c.global_position)
	storm_node.striking_ship_positions = fire_control.striking_ship_positions
	$Player.get_node("rain").show()
	water_mesh.mesh.material.set("shader_parameter/Speed1",Vector2(0.01, 0.06))
	water_mesh.mesh.material.set("shader_parameter/Speed2", Vector2(-0.01, 0.02))
	water_mesh.mesh.material.set("shader_parameter/Speed3",Vector2(0.01, 0.06))
	water_mesh.mesh.material.set("shader_parameter/Speed4", Vector2(-0.01, 0.02))
	water_mesh.mesh.material.set("shader_parameter/Multiplier", Vector3(2, 2, 2))
	is_storm = true
	ship.is_storm = true
	
func storm_end():
	await get_tree().create_timer(0.10).timeout
	$WorldEnvironment.environment = peace_env
	$WorldEnvironment/DirectionalLight3D.light_energy = 1.0
	storm_node.queue_free()
	$Player.get_node("rain").hide()
	water_mesh.mesh.material.set("shader_parameter/Speed1",Vector2(0.01, 0.02))
	water_mesh.mesh.material.set("shader_parameter/Speed2", Vector2(-0.01, -0.01))
	water_mesh.mesh.material.set("shader_parameter/Speed3",Vector2(0.01, 0.02))
	water_mesh.mesh.material.set("shader_parameter/Speed4", Vector2(-0.01, -0.01))
	water_mesh.mesh.material.set("shader_parameter/Multiplier", Vector3(1, 1, 1))
	is_storm = false
	ship.is_storm = false
	
func game_over(reason):
	#rn this function is called from two places
	#1. ship's _proccess function (sinking)
	#2. fire_control's _proccess function (burning)
	$UICanvas.game_over(reason)
