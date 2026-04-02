extends Node2D


var cell_scene: PackedScene = preload("res://scenes/cell.tscn")
var piece_scene: PackedScene = preload("res://scenes/piece.tscn")
var board_size_x = globals.BOARD_SIZE[0]
var board_size_y = globals.BOARD_SIZE[1]
var cell_size = globals.CELL_SIZE
var light_cell_color = globals.BOARD_COLORS[0]
var dark_cell_color = globals.BOARD_COLORS[1]
var cells = []

func _ready() -> void:
	pass


func init_board():
	var piece: Piece = null
	for i in range(board_size_x):
		for y in range(board_size_y):
			var cell = cell_scene.instantiate()
			cell.position = Vector2(
				i * cell_size,
				y * cell_size
			)
			cell.color = light_cell_color if (i + y) % 2 == 0 else dark_cell_color
			add_child(cell)
			cells.append(cell)
			
			if [i, y] in globals.INITIAL_POSITION_MAPPING[globals.PIECE_COLORS.WHITE]:
				piece = set_piece(Vector2(i, y), globals.PIECE_COLORS.WHITE)
			elif [i, y] in globals.INITIAL_POSITION_MAPPING[globals.PIECE_COLORS.BLACK]:
				piece = set_piece(Vector2(i, y), globals.PIECE_COLORS.BLACK)
				
			cell.piece = piece
	
func set_piece(pos: Vector2, color: globals.PIECE_COLORS):
	var piece = piece_scene.instantiate()
	piece.position = pos
	piece.color = color
	piece.board_handle = self
	add_child(piece)
	return piece
