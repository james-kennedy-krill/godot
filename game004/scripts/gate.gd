extends Node3D
class_name Gate

signal gate_passed

var cone_scene = preload("res://scenes/cone.tscn")

var space_apart := 3.0
var gate_rotation := 0.0

@onready var gate_pivot = $GatePivot
@onready var paint: Node3D = $GatePivot/Paint
@onready var cone1 = $GatePivot/Cone
@onready var cone2 = $GatePivot/Cone2
@onready var hit_area = $GatePivot/HitArea
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer3D

func set_space_apart(min_distance, max_distance):
	space_apart = randf_range(min_distance, max_distance)

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_area.connect("body_entered", passed_through)
	cone1.transform.origin.x = -1 * (space_apart/2.0)
	cone2.transform.origin.x = space_apart/2.0
	paint.scale.x = space_apart
	gate_pivot.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(randf_range(0.1, 179.9)))

func _physics_process(_delta):
	var collision_shape_size = Vector3(space_apart, 1, 1)
	if hit_area != null:
		$GatePivot/HitArea/Collision.scale = collision_shape_size
		rotation.y = gate_rotation

func passed_through(_body):
	hit_area.queue_free()
	animation_player.play("passed_through")
	gate_passed.emit()
	
