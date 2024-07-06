extends Path2D
class_name Unit

signal walk_finished


@export var move_range := 6
@export var skin: Texture: set = set_skin
@export var skin_offset := Vector2.ZERO: set = set_skin_offset
@export var move_speed := 600.0

var cell := Vector2.ZERO: set = set_cell
var is_selected := false: set = set_is_selected

var _is_walking := false: set = _set_is_walking

@onready var grid: Resource = preload("res://Grid.tres")
@onready var _sprite: Sprite2D = $PathFollow2D/Sprite
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $PathFollow2D

func _ready():
	set_process(false)
	
	cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
	
	if not Engine.is_editor_hint():
		curve = Curve2D.new()
		
		
func _process(delta: float):
	_path_follow.set_progress(_path_follow.get_progress() + move_speed * delta)
	if _path_follow.progress >= 1.0:
		_is_walking = false
		_path_follow.set_progress(0.0)
		position = grid.calculate_map_position(cell)
		curve.clear_points()
		walk_finished.emit()
		
func walk_along(path: PackedVector2Array):
	if path.is_empty():
		return
	
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
		cell = path[-1]
		_is_walking = true

func set_cell(value: Vector2):
	cell = grid.clamp(value)
	
func set_is_selected(value: bool):
	is_selected = value
	if is_selected:
		_anim_player.play("selected")
	else:
		_anim_player.play("idle")
		
func set_skin(value: Texture):
	skin = value
	if not _sprite:
		await self.ready
	_sprite.texture = value
	
func set_skin_offset(value: Vector2):
	skin_offset = value
	if not _sprite:
		await self.ready
	_sprite.position = value
	
func _set_is_walking(value: bool):
	_is_walking = value
	set_process(_is_walking)
