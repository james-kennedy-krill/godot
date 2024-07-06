# Draws the unit's movement path using an autotile.
class_name UnitPath
extends TileMap

@onready var grid: Resource = preload("res://Grid.tres")

# This variable holds a reference to a PathFinder object. We'll create a new one every time the 
# player select a unit.
var _pathfinder: PathFinder
# This property caches a path found by the _pathfinder above.
# We cache the path so we can reuse it from the game board. If the player decides to confirm unit
# movement with the cursor, we can pass the path to the unit's walk_along() function.
var current_path := PackedVector2Array()


func _ready() -> void:
	# These two points define the start and the end of a rectangle of cells.
	var rect_start := Vector2(4, 4)
	var rect_end := Vector2(10, 8)

	# The following lines generate an array of points filling the rectangle from rect_start to rect_end.
	var points := []
	# In a for loop, writing a number or expression that evaluates to a number after the "in" 
	# keyword implicitly calls the range() function.
	# For example, "for x in 3" is a shorthand for "for x in range(3)".
	for x in rect_end.x - rect_start.x + 1:
		for y in rect_end.y - rect_start.y + 1:
			points.append(rect_start + Vector2(x, y))

	# We can use the points to generate our PathFinder and draw a path.
	initialize(points)

# Creates a new PathFinder that uses the AStar algorithm we use to find a path between two cells 
# among the `walkable_cells`.
# We'll call this function every time the player selects a unit.
func initialize(walkable_cells: Array) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)


## Finds and draws the path between `cell_start` and `cell_end`.
#func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	## We first clear any tiles on the tilemap, then let the Astar2D (PathFinder) find the
	## path for us.
	#clear()
	#current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	## And we draw a tile for every cell in the path.
	#for cell in current_path:
		#set_cellv(cell, 0)
	## The function below updates the auto-tiling. Without it, you wouldn't get the nice path with curves
	## and the arrows on either end.
	#update_bitmask_region()


func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	# We first clear any tiles on the tilemap, then let the Astar2D (PathFinder) find the path for us.
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)

	# And we set a tile for every cell in the path.
	#for cell in current_path:
		#set_cell(0, cell, -1)  # Assuming layer 0 and -1 as the tile index

	var cells = []
	for location in current_path:
		cells.append(location)
	set_cells_terrain_connect(0, cells, 0, 0)

# Stops drawing, clearing the drawn path and the `_pathfinder`.
func stop() -> void:
	_pathfinder = null
	clear()