extends Node

@onready var blink_timer: Timer = $BlinkCanvas/BlinkTimer
@onready var blink_canvas: CanvasLayer = $BlinkCanvas
@onready var map_canvas: CanvasLayer = $MapCanvas
@onready var hint_canvas: CanvasLayer = $HintCanvas
@onready var label_1: Label = $/root/TestScene/Ship/ScoreTracker/SubViewport/VBoxContainer/HBoxContainer/Label2
@onready var label_2: Label = $/root/TestScene/Ship/ScoreTracker/SubViewport/VBoxContainer/HBoxContainer2/Label2

signal is_storm_changed(value)
signal zone_changed(value)

var this_zone_storms_survived: int = 0
var overall_storms_survived: int = 0
var fish_caught: int = 0

var game_scene = load("res://scenes/test_scene.tscn")
var main_menu_scene = load("res://scenes/canvas_and_ui/main_menu_scene.tscn")

var current_game_scene;
var rstrt: bool = false

var score: int = 0
var interaction_queue: Array = []

var interactions = {"intro1" : "Hey, my name is Shawn the Shopkeeper.\n And your name is?", 
"intro2" : "Ah, nevermind, I see you a shy one\nso I'll need to teach you a few thing before you go.",
"tutorial1" : "Out there in the sea there's a wild storm.\nIt's seems like the waters are good, no sign of a storm.",
"tutorial2" : "And in a blink of an eye\nit appears, out of nowhere.\nWatch out for it, and try not to close your eyes.",
"tutorial3" : "We're now in a safe spot\nnear shore, in Deadman's Dock.\nThe further away you go from here, well...",
"tutorial4" : "You can fish here, but you see, everybody can\nso the fish here tastes worse than Greg's momma.",
"tutorial5" : "Trust me, I know. But just\nfor your expirience try catching some here.",
"tutorial6" : "Pull away from where the fish is pulling\nor your rod will snap.",
"tutorial7" : "If you need any more help, I'll be here.",
"failed1" : "Okay, so there are signs\nyou're pulling in the wrong direction",
"failed2" : "Like the rod bending\nand the line getting tighter",
"failed3" : "All you got to do is pull\nin the opposite direction of where\nthe fish wants to go",
"failed4" : "And start pulling when\nthe red bobber starts moving",
"succeed1" : "Nice one, now place it in here to sell it.\nI'll tell you it's price.",
"tutorial21" : "Good, now I'll give you some tips for the storm.\nFirst, don't forget the sails.",
"tutorial22" : "Make sure they are packed when entering storm.\nSecond, watch out for fire.",
"tutorial23" : "A lightning strike will easily burn\nyour whole ship if you don't put it out on time.",
"tutorial24" : "And at last, just don't let your ship sink\nthat'd be pretty stupid.",
"tutorial25" : "You can start your journey by going\nto the stirring wheel on your boat.",
"tutorial26" : "Good luck and come back.\nBring me something good and I'll tell you something new",
"sharks1" : "I've heard that you can catch\n a shark in the storm",

}

var money: 
	set(value):
		if money:
			if value - money >= 0:
				label_2.text = str(int(label_2.text) + value - money)
		else:
			label_2.text = str(0)
		label_1.text = str(value)
		money = value

var first_storm: bool = true

var is_storm: bool:
	set(value):
		is_storm = value
		if not rstrt:
			is_storm_changed.emit(value)

enum ZONE {DEADMAN, BUCCANEER, SEAWITCH, STORMBREAKER}

var zone: ZONE:
	set(value):
		zone = value
		overall_storms_survived += this_zone_storms_survived
		this_zone_storms_survived = 0;
		zone_changed.emit(value)

func _ready() -> void:
	money = 0
	hint_canvas.hide()
	zone = ZONE.DEADMAN
	blink_timer.wait_time = randf_range(35.0, 60.0)
	blink_timer.start()

func _on_blink_timer_timeout():
	if zone != ZONE.DEADMAN:
		if first_storm:
			hint("Storm can damage your sails!")
		is_storm = !is_storm
		if is_storm:
			blink_timer.wait_time = randf_range(35.0, 60.0)
		else:
			this_zone_storms_survived += 1
			blink_timer.wait_time = randf_range(35.0, 60.0) + (this_zone_storms_survived * 2.0 * zone)
		blink_canvas.blink()
		
func restart():
	rstrt = true
	current_game_scene.queue_free()
	var game_node = game_scene.instantiate()
	get_tree().get_root().add_child(game_node)
	is_storm = false
	this_zone_storms_survived = 0
	overall_storms_survived = 0
	score = 0
	map_canvas._ready()
	rstrt = false
	
func main_menu():
	current_game_scene.queue_free()
	var menu = main_menu_scene.instantiate()
	get_tree().get_root().add_child(menu)
	

func hint(text: String):
	$HintCanvas/HBoxContainer/Label.text = text
	$HintCanvas/AnimationPlayer.play("hint_popup")
