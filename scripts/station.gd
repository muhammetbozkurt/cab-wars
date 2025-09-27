extends Node3D

@export var client_scene: PackedScene

@onready var deploy_marker: Marker3D = $DeployMarker


var is_full = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not client_scene:
		printerr("client scene must be set")
	add_to_group("stations")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func add_client() -> bool:
	if is_full:
		return false
	is_full = true
	var client_instance = client_scene.instantiate()
	get_tree().current_scene.add_child(client_instance)
	client_instance.global_position = deploy_marker.global_position
	
	return true
