extends Node2D

var debug = false

func _ready():
	for p in get_tree().get_nodes_in_group("units"):
		$Camera2D.add_target(p)
		
	var r = $Map.get_used_rect()
	$Camera2D.limit_left = r.position.x * $Map.tile_set.tile_size.x
	$Camera2D.limit_right = r.end.x * $Map.tile_set.tile_size.x
	$Camera2D.limit_bottom = r.end.y * $Map.tile_set.tile_size.y

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		debug = !debug

var cam_rect = Rect2()
func draw_cam_rect(r):
	cam_rect = r
	queue_redraw()
	
func _draw():
	if !debug:
		return
	draw_circle($Camera2D.position, 10, Color.CORAL)
	draw_rect(cam_rect, Color.CORAL, false, 4.0)
