extends Node2D


var cell_scene: PackedScene = preload("res://scenes/cell.tscn")

func init_board():
	for i in range(globals.BOARD_SIZE[0]):
		for y in range(globals.BOARD_SIZE[1]):
			var cell = cell_scene.instantiate()
			cell.position = Vector2(
				i * globals.CELL_SIZE,
				y * globals.CELL_SIZE
			)
			cell.color = globals.COLORS[0] if (i + y) % 2 == 0 else globals.COLORS[1]
			add_child(cell)
			
