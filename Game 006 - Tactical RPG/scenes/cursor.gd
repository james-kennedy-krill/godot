
extends Node2D
class_name Cursor

signal accept_pressed(cell)
signal moved(new_cell)


@export var ui_cooldown := 0.1

var cell := Vector2.ZERO: set = set_cell

@onready var grid: Resource = preload("res://Grid.tres")
@onready var _timer: Timer = $Timer

func _ready():
	_timer.wait_time = ui_cooldown
	position = grid.calculate_map_position(cell)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# TODO Need to figure out a way to get the coordinates of the grid below the mouse (with zoom)
		cell = grid.calculate_grid_coordinates(event.position)
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		accept_pressed.emit(cell)

		
	var should_move = event.is_pressed()
	
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
		
	if not should_move:
		return
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	cell += direction
	
func _draw():
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.ALICE_BLUE, false, 2.0)
	
func set_cell(value: Vector2):
	var new_cell: Vector2 = grid.clamp(value)
	if new_cell.is_equal_approx(cell):
		return
	
	cell = new_cell
	
	position = grid.calculate_map_position(cell)
	moved.emit(cell)
	_timer.start()
