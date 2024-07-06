extends TileMap
class_name UnitOverlay

func draw(cells: Array):
	clear()
	for cell in cells:
		print(cell)
		set_cells_terrain_connect(0, cells, 0, 0)
