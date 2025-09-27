extends CharacterBody3D

var start_station: Node3D = null
var target_station_area_rid: int = -1

func _ready() -> void:
	add_to_group("clients")
	if start_station:
		set_target_station()


func set_target_station() -> void:
	var target_station: Node3D = null
	var stations: Array[Node] = get_tree().get_nodes_in_group("stations")
	if len(stations) == 1:
		return
	
	stations.shuffle()
	for station in stations:
		if station != start_station:
			target_station_area_rid = station.area.get_rid().get_id()
			return


func init_talk() -> int:
	print("hi car, my target area: ", target_station_area_rid)
	return target_station_area_rid


func get_in_car() -> void:
	if start_station:
		if start_station.has_method("clear_station"):
			start_station.clear_station()
	queue_free()
