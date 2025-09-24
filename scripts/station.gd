extends Node3D

@export var client_scene: PackedScene


var is_full = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not client_scene:
		printerr("client scene must be set")
	add_to_group("stations")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
