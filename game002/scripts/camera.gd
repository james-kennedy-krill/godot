extends Camera2D

var zoom_min = Vector2(1, 1)
var zoom_max = Vector2(4, 4)
var zoom_speed = Vector2(.2, .2)
var des_zoom = zoom

func _process(delta):
	zoom = lerp(zoom, des_zoom, .2)

func _input(event):
	if event.is_action("zoom_out"):
		if des_zoom > zoom_min:
			des_zoom -= zoom_speed
	if event.is_action("zoom_in"):
		if des_zoom < zoom_max:
			des_zoom += zoom_speed
