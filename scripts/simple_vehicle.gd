extends CharacterBody3D

# Simple movement properties
var speed: float = 5.0
var turn_speed: float = 2.0

func _ready():
	add_to_group("vehicles")

func _physics_process(delta):
	# Get input direction
	var input_vector = Vector2.ZERO
	
	# Forward/backward
	if Input.is_action_pressed("ui_up"):
		input_vector.y = 1.0
	elif Input.is_action_pressed("ui_down"):
		input_vector.y = -1.0
	
	# Left/right turning
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1.0
	elif Input.is_action_pressed("ui_right"):
		input_vector.x = 1.0
	
	# Apply movement
	if input_vector.y != 0:
		# Move forward/backward
		velocity = -transform.basis.z * input_vector.y * speed
	else:
		# Stop when no input
		velocity = velocity.move_toward(Vector3.ZERO, speed * delta * 3)
	
	# Apply turning
	if input_vector.x != 0:
		rotation.y += input_vector.x * turn_speed * delta
	
	# Move the vehicle
	move_and_slide()