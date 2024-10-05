extends Node3D

@export var target : Node3D

@export_range(0.0, 2.0) var rotation_speed = PI/2

# mouse properties
@export var mouse_control = false
@export_range(0.001, 0.1) var mouse_sensitivity = 0.005
@export var invert_y = false
@export var invert_x = false

# zoom settings
@export var max_zoom = 3.0
@export var min_zoom = 0.4
@export_range(0.05, 1.0) var zoom_speed = 0.09

var zoom = 1.5

@onready var inner = $InnerGimbal

func _ready():
	if mouse_control:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		if event.is_action_pressed("main_click"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("cam_zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("cam_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
	if mouse_control and event is InputEventMouseMotion:
		if event.relative.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var dir = 1 if invert_y else -1
			var y_rotation = clamp(event.relative.y, -30, 30)
			inner.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)

func get_input_keyboard(delta):
	# Rotate outer gimbal around y axis
	var y_rotation = Input.get_axis("cam_left", "cam_right")
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	# Rotate inner gimbal around local x axis
	var x_rotation = Input.get_axis("cam_up", "cam_down")
	x_rotation = -x_rotation if invert_y else x_rotation
	inner.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)

func _process(delta):
	if !mouse_control:
		get_input_keyboard(delta)
	inner.rotation.x = clamp(inner.rotation.x, -1.4, -0.01)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	if target:
		global_position = target.global_position
