extends Node
class_name Level

signal level_complete
signal increase_score(amount)

var gate_scene = preload("res://scenes/gate.tscn")

@export var number_of_gates := 3
@export var gate_location_radius := 50.0
@export_range(0.5, 5, 0.5) var min_distance := 0.5
@export_range(1, 5.5, 0.5) var max_distance := 2.5

var gates_passed = 0
var gate_area_radius = 0

func _ready():
	gate_area_radius = gate_location_radius + max_distance
	size_stadium()
	spawn_gates()
	
func _process(_delta):
	if gates_passed >= number_of_gates:
		end_level()

func size_stadium():
	var stadium_size = gate_area_radius + 10.0
	var Stadium = get_node("Stadium")
	var current_size = Stadium.get_node("MeshInstance3D").mesh.size.x
	var new_scale = stadium_size / current_size
	Stadium.scale = Vector3(new_scale, new_scale, new_scale)
	
func spawn_gates():
	for i in range(number_of_gates):
		var gate: Gate = gate_scene.instantiate()
		gate.set_space_apart(min_distance, max_distance)
		get_node("Gates").add_child(gate)
		gate.transform.origin = Vector3(randf_range(-1*(gate_area_radius/2), (gate_area_radius/2)), 0, randf_range(-1*(gate_area_radius/2), (gate_area_radius/2)))
		gate.connect("gate_passed", _on_gate_passed)

func _on_gate_passed():
	gates_passed += 1
	increase_score.emit(1)

func end_level():
	level_complete.emit()
	
