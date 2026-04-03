extends Node2D
class_name Board

var cell_scene: PackedScene = preload("res://scenes/cell.tscn")
var piece_scene: PackedScene = preload("res://scenes/piece.tscn")
var board_size_x = globals.BOARD_SIZE[0]
var board_size_y = globals.BOARD_SIZE[1]
var cell_size = globals.CELL_SIZE
var light_cell_color = globals.BOARD_COLORS[0]
var dark_cell_color = globals.BOARD_COLORS[1]
var cells = []

func _ready() -> void:
	SignalBus.piece_moved.connect(_on_piece_droped)
	
func _process(delta: float) -> void:
	pass


func init_board():
	var piece: Piece = null
	for x in range(board_size_x):
		for y in range(board_size_y):
			var coordinates = [x, y]
			var cell = cell_scene.instantiate()
			cell.position = Vector2(
				x * cell_size,
				y * cell_size
			)
			cell.board_coordinate = coordinates
			cell.color = light_cell_color if (x + y) % 2 == 0 else dark_cell_color
			add_child(cell)
			
			if coordinates in globals.INITIAL_POSITION_MAPPING[globals.PIECE_COLORS.WHITE]:
				piece = set_piece(Vector2(x, y), globals.PIECE_COLORS.WHITE)
			elif coordinates in globals.INITIAL_POSITION_MAPPING[globals.PIECE_COLORS.BLACK]:
				piece = set_piece(Vector2(x, y), globals.PIECE_COLORS.BLACK)
			if piece:
				piece.board_handle = self
				cell.piece = piece
				piece.cell = cell
				add_child(piece)
			cells.append(cell)
			piece = null
	
func set_piece(pos: Vector2, color: globals.PIECE_COLORS):
	var piece = piece_scene.instantiate()
	piece.position = pos
	piece.color = color
	piece.board_handle = self
	
	return piece
	
func _on_piece_droped(piece: Piece):
	adjust_piece_placement(piece)
	var cell = get_cell(piece.position)
	if cell.piece or  not is_valid_move(piece.position, piece.last_position):
		piece.position = piece.last_position
	else:
		piece.last_position = piece.position
		piece.cell.piece = null
		piece.cell = cell
		cell.piece = piece
	
func get_cell(pos: Vector2):
	var board_coordinates = get_board_coordinates(pos)
	for cell in cells:
		if [cell.board_coordinate[0] + 1, cell.board_coordinate[1] + 1] == board_coordinates:
			return cell
	
func get_board_coordinates(pos: Vector2):
	var rounded_x = round(pos[0])
	var rounded_y = round(pos[1])
	return [int(ceil(rounded_x/globals.CELL_SIZE)), int(ceil(rounded_y/globals.CELL_SIZE))]
	
func adjust_piece_placement(piece: Piece):
	var board_coordinates = get_board_coordinates(piece.position)
	piece.position.x = -globals.OFFSET_PIECE + board_coordinates[0] * globals.CELL_SIZE
	piece.position.y = -globals.OFFSET_PIECE + board_coordinates[1] * globals.CELL_SIZE
	
func is_valid_move(dest, source):
	if dest.x > 128 or dest.y > 128 or dest.x < 0 or dest.y < 0:
		return false
	return true
