extends CharacterBody3D

@onready var clientEnterExitTimer: Timer = $ClientEnterExitTimer


var speed: float = 5.0
var turn_speed: float = 2.0
var current_client: Node3D = null # depracated but we can use it in future
var has_client: bool = false
var possible_client: Node3D = null

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

func _on_client_enter_area_body_entered(body: Node3D) -> void:
	if has_client or not body.is_in_group("clients"):
		return
	possible_client = body
	# TODO: we can add a small deal mechanic
	possible_client.call("init_talk")
	clientEnterExitTimer.start(3)
	
	

func _on_client_enter_area_body_exited(body: Node3D) -> void:
	if body == possible_client:
		possible_client = null


func _on_client_enter_exit_timer_timeout() -> void:
	# TODO: can add timer on screen
	if possible_client and not has_client:
		#current_client = possible_client
		has_client = true
		possible_client.call("get_in_car")
		possible_client = null # currently not neccesary because in "get_in_car" invoke queue_free
