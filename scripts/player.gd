extends CharacterBody3D

# PLAYER NODES

@onready var head: Node3D = $Head
@onready var standing_shape = $StandingShape
@onready var crouching_shape = $CrouchingShape
@onready var standing_ray = $StandingRay
@onready var point_ray = $Head/PointRay
@onready var test_scene: Node3D = $".."
@onready var pointer_indicator: TextureRect = $PointerIndicator
@onready var hand: Node3D = %Hand

#SPEED VARS

var current_speed: float = 5.0
@export var walking_speed: float = 3.0
@export var sprinting_speed: float = 8.0
@export var crouching_speed: float = 3.0

#MOVEMENT VARS

const JUMP_VELOCITY = 4.5

var lerp_speed: float = 10.0
var camera_shake: float = 0.05
var camera_shake_freq: float = 300

var crouching_depth: float = -0.5

var direction: Vector3 = Vector3.ZERO

var hand_start_pos: float 
var head_start_pos: float 


#INPUT VARS

@export var mouse_sens: float = 0.4

#OTHER VARS

var tasks: Array[Node3D]
var floaty: RigidBody3D

var is_fishing: bool:
	set(value):
		floaty = get_tree().get_root().get_node("TestScene/Floaty")
		is_fishing = value
		if value:
			position = Vector3(2.803, 5.688, 11.063)
		head.rotation = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hand_start_pos =  %Hand.position.y
	head_start_pos = head.position.y

func _input(event):
	if event is InputEventMouseMotion and !is_fishing:
		rotate_y(-event.relative.x * mouse_sens)
		head.rotate_x(-event.relative.y * mouse_sens)
		head.rotation.x = clamp(head.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_fishing:
		velocity.y = JUMP_VELOCITY
		
	# Handle dropping items.
	if %Hand.get_child_count() and !is_fishing:
		if Input.is_action_just_pressed("interact1"):
			var item = %Hand.get_child(0)
			item.sleeping = false
			item.freeze = false
			var global_pos = item.global_position
			var global_rot = item.global_rotation
			%Hand.remove_child(item)
			var items = test_scene.get_node("Items")
			items.add_child(item)
			item.global_position = global_pos
			item.global_rotation = global_rot
			item.is_picked_up = false
	
	if !is_fishing:
		handle_pointing()
		handle_movement_state(delta)
		handle_walking(delta)
		move_and_slide()
	else:
		head.look_at(floaty.global_position + Vector3.UP * 2)
	handle_tasks(delta)
	
func handle_walking(delta):
		# Directions from input
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	
	if !is_fishing:
		# Hand moving animation
		if (input_dir != Vector2.ZERO):
			%Hand.position.y = lerp(%Hand.position.y, hand_start_pos + sin(current_speed / camera_shake_freq * Time.get_ticks_msec() + PI/2) / 40, delta * lerp_speed)
			head.position.y = lerp(head.position.y, head_start_pos + camera_shake * sin(current_speed / camera_shake_freq * Time.get_ticks_msec()), delta * lerp_speed)
		
		# Moving the player
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * lerp_speed)
		if direction:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)

func handle_movement_state(delta):
	if Input.is_action_pressed("crouch"):
		
		#crouching
		head.position.y = lerp(head.position.y, 0.6 + crouching_depth, delta * lerp_speed)
		current_speed = crouching_speed
		standing_shape.disabled = true
		crouching_shape.disabled = false

	elif !standing_ray.is_colliding():
		
		#standing
		standing_shape.disabled = false
		crouching_shape.disabled = true
		head.position.y = lerp(head.position.y, 0.6, delta * lerp_speed)
		
		#HANDLE SPRINTING
		if Input.is_action_pressed("sprint"):
			#sprinting
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed

func handle_pointing():
	# For picking up items
	if point_ray.is_colliding():
		pointer_indicator.modulate.a = 0.9
		if Input.is_action_just_pressed("interact1"):
			var collider = point_ray.get_collider()
			if collider is RigidBody3D:
				var c = collider.get_node(".")
				c.get_parent().remove_child(c)
				%Hand.add_child(c)
				c.position = Vector3.ZERO
				c.is_picked_up = true
	else:
		pointer_indicator.modulate.a = 0.4

func handle_tasks(delta):
	if Input.is_action_pressed("interact2"):
		if %Hand.get_child_count():
			var current_object = %Hand.get_child(0)
			for task in tasks:
				if task.required_object:
					if task.required_object == current_object.my_scene:
						current_object.interact(delta, task)
						break
		else:
			for task in tasks:
				#this one could be useful for tasks that might not require item
				#it is only fishing rn
				if !task.required_object:
					task.interact()
					break

# CHANGED
func entered_interaction(new_task: Node3D):
	tasks.insert(0, new_task)
	
