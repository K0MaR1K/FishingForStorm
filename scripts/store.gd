extends Node3D

@onready var col_1: CollisionShape3D = $Shop/Col1/CollisionShape3D
@onready var col_2: CollisionShape3D = $Shop/Col2/CollisionShape3D
@onready var interact_area: CollisionShape3D = $InteractStoreArea/InteractArea
@onready var shopkeeper: Node3D = $Shopkeeper
@onready var talking_timer: Timer = $TalkingTimer

var first_entry: bool = true
var player_in_area: bool = false
var shark_info: bool = true

func _ready() -> void:
	Global.interaction_queue.append(Global.interactions["intro1"])
	Global.interaction_queue.append(Global.interactions["intro2"])
	Global.interaction_queue.append(Global.interactions["tutorial1"])
	Global.interaction_queue.append(Global.interactions["tutorial2"])
	Global.interaction_queue.append(Global.interactions["tutorial3"])
	Global.interaction_queue.append(Global.interactions["tutorial4"])
	Global.interaction_queue.append(Global.interactions["tutorial5"])
	Global.interaction_queue.append(Global.interactions["tutorial6"])
	Global.interaction_queue.append(Global.interactions["tutorial7"])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact2") and player_in_area:
		if talking_timer.is_stopped():
			talking_timer.start()
			_on_talking_timer_timeout()
		else:
			_on_talking_timer_timeout()
			talking_timer.start()

func enable():
	show()
	col_1.disabled = false
	col_2.disabled = false
	interact_area.disabled = false
	shopkeeper.whistle.play()
	
func disable():
	hide()
	col_1.disabled = true
	col_2.disabled = true
	interact_area.disabled = true
	shopkeeper.whistle.stop()
	

func _on_interact_store_area_body_entered(body: Node3D) -> void:
	player_in_area = true
	if first_entry:
		Global.hint("Press RMB to talk to the shopkeeper")
		first_entry = false
	elif Global.overall_storms_survived > 4 and shark_info:
		shark_info = false
		Global.interaction_queue.append(Global.interactions["sharks1"])
	elif Global.fish_caught == 0:
		Global.interaction_queue.append(Global.interactions["failed1"])
		Global.interaction_queue.append(Global.interactions["failed2"])
		Global.interaction_queue.append(Global.interactions["failed3"])

func _on_interact_store_area_body_exited(body: Node3D) -> void:
	player_in_area = false
	talking_timer.stop()
	shopkeeper.wave()


func _on_talking_timer_timeout() -> void:
	if Global.interaction_queue.size():
		shopkeeper.talk(Global.interaction_queue[0])
		Global.interaction_queue.pop_front()
	else:
		shopkeeper.talk("That's all for now, come back later!")
		talking_timer.stop()


func _on_fish_sell_area_body_entered(body: Node3D) -> void:
	if body.has_node("Fish"):
		if Global.money == 0:
			Global.interaction_queue.append(Global.interactions["tutorial21"])
			Global.interaction_queue.append(Global.interactions["tutorial22"])
			Global.interaction_queue.append(Global.interactions["tutorial23"])
			Global.interaction_queue.append(Global.interactions["tutorial24"])
			Global.interaction_queue.append(Global.interactions["tutorial25"])
			Global.interaction_queue.append(Global.interactions["tutorial26"])
		Global.money += body.adjusted_price
		if body.adjusted_price > 200:
			shopkeeper.talk(str(body.adjusted_price) + " for that piece, you earned it")
		elif body.adjusted_price > 100:
			shopkeeper.talk("That one's pretty rare,\n I'll give you " + str(body.adjusted_price))
		elif body.adjusted_price > 50:
			shopkeeper.talk("Not bad, " + str(body.adjusted_price) + " will do")
		elif body.adjusted_price > 40:
			shopkeeper.talk(str(body.adjusted_price) + " is a reasonable price")
		elif body.adjusted_price > 20:
			shopkeeper.talk(str(body.adjusted_price) + " for that, and a friendly advice.\nFind better spots for fishing")
		else:
			shopkeeper.talk(str(body.adjusted_price) + " and yeah, that's going to the dogs")
		
		body.queue_free()
