extends Node

class_name Level

var gate_scene = preload("res://scenes/gate.tscn")

@export var number_of_gates := 3
@export var gate_location_radius := 50.0
@export_range(0.5, 5, 0.5) var min_distance := 0.5
@export_range(1, 5.5, 0.5) var max_distance := 2.5

func _ready():
	spawn_gates()

func spawn_gates():
	for i in range(number_of_gates):
		var gate: Gate = gate_scene.instantiate()
		gate.set_space_apart(min_distance, max_distance)
		get_node("Gates").add_child(gate)
		gate.transform.origin = Vector3(randf_range(-1*gate_location_radius, gate_location_radius), 0, randf_range(-1*gate_location_radius, gate_location_radius))
