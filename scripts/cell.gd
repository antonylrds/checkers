extends Node2D
class_name Cell

var rect = Rect2(position, Vector2(globals.CELL_SIZE, globals.CELL_SIZE))
var color: Color

func _draw():
	draw_rect(rect, color, true)
