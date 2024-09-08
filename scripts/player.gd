extends CharacterBody3D

# PLAYER NODES

@onready var head: Node3D = $Head
@onready var standing_shape = $StandingShape
@onready var crouching_shape = $CrouchingShape
@onready var standing_ray = $StandingRay
@onready var point_ray = $Head/PointRay


#SPEED VARS

var current_speed: float = 5.0
@export var walking_speed: float = 3.0
@export var sprinting_speed: float = 8.0
@export var crouching_speed: float = 3.0

#MOVEMENT VARS

const JUMP_VELOCITY = 4.5

var lerp_speed: float = 10.0

var crouching_depth: float = -0.5

var direction: Vector3 = Vector3.ZERO

#INPUT VARS

@export var mouse_sens: float = 0.4

var task: Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sens)
		head.rotate_x(-event.relative.y * mouse_sens)
		head.rotation.x = clamp(head.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	
	#HANDLE MOVEMENT STATE
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
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	handle_pointing()
	handle_tasks(delta)
	move_and_slide()

func handle_pointing():
	if point_ray.is_colliding():
		if Input.is_action_just_pressed("interact1"):
			var collider = point_ray.get_collider()
			if collider is RigidBody3D:
				collider.picked_up()
				var c = collider.my_scene.instantiate()
				c.sleeping = true
				c.freeze = true
				%Hand.add_child(c)

func handle_tasks(delta):
	if Input.is_action_pressed("interact2"):
		var current_object = %Hand.get_child(0)
		if current_object and task:
			if task.required_object == current_object.my_scene:
				current_object.interact(delta)
			

func entered_interaction(etask: Node3D):
	task = etask
