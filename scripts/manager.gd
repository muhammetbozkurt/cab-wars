extends Node3D



@onready var timer: Timer = $Timer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var stations: Array[Node] = get_tree().get_nodes_in_group("stations")
	for  station in stations:
		if station.has_method("add_client"):
			print("add client")
			var res = station.call("add_client")
			if res:
				return
