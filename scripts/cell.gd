extends Node2D
class_name Cell

var rect = Rect2(position, Vector2(globals.CELL_SIZE, globals.CELL_SIZE))
var color: Color
var piece: Piece = null
var board_coordinate


func _ready() -> void:
	$Area2D/CollisionShape2D.shape.size.x = globals.CELL_SIZE
	$Area2D/CollisionShape2D.shape.size.y = globals.CELL_SIZE
	$Area2D/CollisionShape2D.position.x += globals.OFFSET_PIECE
	$Area2D/CollisionShape2D.position.y += globals.OFFSET_PIECE
	

func _draw():
	z_index = -1
	draw_rect(rect, color, true)


func _on_area_2d_mouse_entered() -> void:
	if globals.is_dragging:
		self.modulate = Color(1.5, 1.5, 1.5) # Glow effect
	else:
		self.modulate = Color.WHITE


func _on_area_2d_mouse_exited() -> void:
	self.modulate = Color.WHITE
