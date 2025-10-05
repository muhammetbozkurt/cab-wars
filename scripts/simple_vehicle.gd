extends CharacterBody3D

@onready var clientEnterExitTimer: Timer = $ClientEnterExitTimer
@onready var direction_arrow: MeshInstance3D = $DirectionArrow
@onready var stunt_timer: Timer = $StuntTimer

@export var player_id: String = "player1" 


var speed: float = 5.0
var turn_speed: float = 2.0
var current_client: Node3D = null # depracated but we can use it in future
var has_client: bool = false
var possible_client: Node3D = null
var current_target_station_area_id: int = -1
var current_station_area_id: int = -1 
var is_stunt = false

func _ready():
	add_to_group("vehicles")
	
func get_player_action(base_name: String) -> String:
	return "%s_%s" % [player_id, base_name]

func _physics_process(delta):
	if is_stunt:
		return
	
	if has_client and current_target_station_area_id > 0:
		var stations: Array[Node] = get_tree().get_nodes_in_group("stations")
		for station in stations:
			var station_area: Area3D = station.get_node("Area3D")
			if station_area and station_area.get_rid().get_id() == current_target_station_area_id:
				direction_arrow.look_at(station.global_transform.origin, Vector3.UP)
				break
	# Get input direction
	var input_vector = Vector2.ZERO
	
	# Forward/backward
	if Input.is_action_pressed(get_player_action("move_forward")):
		input_vector.y = 1.0
	elif Input.is_action_pressed(get_player_action("move_back")):
		input_vector.y = -1.0
	
	# Left/right turning
	if Input.is_action_pressed(get_player_action("move_left")):
		input_vector.x = -1.0
	elif Input.is_action_pressed(get_player_action("move_right")):
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
	current_target_station_area_id = possible_client.call("init_talk")
	clientEnterExitTimer.start(3)
	
	

func _on_client_enter_area_body_exited(body: Node3D) -> void:
	if body == possible_client:
		possible_client = null


func _on_client_enter_exit_timer_timeout() -> void:
	# TODO: can add timer on screen
	if possible_client and not has_client:
		#current_client = possible_client
		has_client = true
		direction_arrow.visible = true
		possible_client.call("get_in_car")
		possible_client = null # currently not neccesary because in "get_in_car" invoke queue_free
	elif has_client and current_station_area_id > 0 and current_station_area_id == current_target_station_area_id:
		has_client = false
		direction_arrow.visible = false
		current_target_station_area_id = -1
		current_station_area_id = -1
		print("client is gone :D")
		#TODO: increase point


func _on_client_enter_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if has_client and current_target_station_area_id == area_rid.get_id():
		current_station_area_id = area_rid.get_id()
		print("we are at right station")
		clientEnterExitTimer.start(3)


func _on_client_enter_area_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if current_station_area_id == area_rid.get_id():
		current_station_area_id = -1

func got_stunt():
	if not is_stunt:
		is_stunt = true
		stunt_timer.start(15)
		


func _on_stunt_timer_timeout() -> void:
	is_stunt = false


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("vehicles") and body.player_id != player_id:
		body.call("got_stunt")
