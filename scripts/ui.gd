extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var deliveries_label: Label = $VBoxContainer/DeliveriesLabel
@onready var combo_label: Label = $VBoxContainer/ComboLabel
@onready var clients_label: Label = $VBoxContainer/ClientsLabel
@onready var status_label: Label = $VBoxContainer/StatusLabel

var manager: Node3D

func _ready():
	# Find the manager node
	manager = get_tree().get_first_node_in_group("managers")
	if not manager:
		manager = get_node("../Manager")  # Fallback path
	
	if manager:
		# Connect to manager signals
		manager.game_stats_updated.connect(_on_game_stats_updated)
		manager.client_spawned.connect(_on_client_spawned)
		manager.client_delivered.connect(_on_client_delivered)
	
	# Find vehicle and connect signals
	var vehicle = get_tree().get_first_node_in_group("vehicles")
	if vehicle:
		vehicle.client_picked_up.connect(_on_client_picked_up)
	
	update_display()

func _on_game_stats_updated(deliveries: int, score: int, combo: int):
	update_display()

func _on_client_spawned(client):
	update_display()

func _on_client_delivered(client, score: int):
	update_display()

func _on_client_picked_up(client):
	update_display()

func update_display():
	if not manager:
		return
		
	var stats = manager.get_game_stats()
	
	if score_label:
		score_label.text = "Score: " + str(stats.current_score)
	
	if deliveries_label:
		deliveries_label.text = "Deliveries: " + str(stats.total_deliveries)
	
	if combo_label:
		combo_label.text = "Combo: " + str(stats.current_combo) + "x"
	
	if clients_label:
		clients_label.text = "Active Clients: " + str(stats.active_clients)
	
	# Update vehicle status
	if status_label:
		var vehicle = get_tree().get_first_node_in_group("vehicles")
		if vehicle:
			if vehicle.is_carrying_client():
				var client = vehicle.get_current_client()
				var destination_name = "Unknown"
				if client and client.has_method("get_destination_station"):
					var dest = client.get_destination_station()
					if dest:
						destination_name = dest.name
				status_label.text = "Status: Carrying client to " + destination_name
			else:
				status_label.text = "Status: Looking for clients"
		else:
			status_label.text = "Status: No vehicle found"
