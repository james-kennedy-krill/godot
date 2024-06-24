extends Node3D
class_name Gate

signal gate_passed

var cone_scene = preload("res://scenes/cone.tscn")

var space_apart := 3.0
var gate_rotation := 0.0

@onready var gate_pivot = $GatePivot
@onready var cone1 = $GatePivot/Cone
@onready var cone2 = $GatePivot/Cone2
@onready var hit_area = $HitArea

func set_space_apart(min_distance, max_distance):
	space_apart = randf_range(min_distance, max_distance)

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_area.connect("body_entered", passed_through)
	cone1.transform.origin.x = -1 * (space_apart/2.0)
	cone2.transform.origin.x = space_apart/2.0

func _physics_process(_delta):
	var collision_shape_size = Vector3(space_apart, 1, 1)
	$HitArea/Collision.scale = collision_shape_size
	rotation.y = gate_rotation

func passed_through(_body):
	print("Body entered")
	cone1.queue_free()
	cone2.queue_free()
	gate_passed.emit()
