extends CharacterBody3D

var start_station: Node3D = null

func _ready() -> void:
	add_to_group("clients")


func init_talk() -> void:
	print("hi car")


func get_in_car() -> void:
	if start_station:
		if start_station.has_method("clear_station"):
			start_station.clear_station()
	queue_free()
