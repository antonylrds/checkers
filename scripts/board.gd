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
			cell.board_coordinate = [coordinates[0] + 1, coordinates[1] + 1]
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
	var cell = get_cell(get_board_coordinates(piece.position))
	if not is_valid_move(piece, cell):
		piece.position = piece.last_position
	else:
		piece.last_position = piece.position
		piece.cell.piece = null
		piece.cell = cell
		cell.piece = piece
	
func get_cell(board_coordinates: Array):
	for cell in cells:
		if [cell.board_coordinate[0], cell.board_coordinate[1]] == board_coordinates:
			return cell
	
func get_board_coordinates(pos: Vector2):
	var rounded_x = round(pos[0])
	var rounded_y = round(pos[1])
	return [int(ceil(rounded_x/globals.CELL_SIZE)), int(ceil(rounded_y/globals.CELL_SIZE))]
	
func adjust_piece_placement(piece: Piece):
	var board_coordinates = get_board_coordinates(piece.position)
	piece.position.x = -globals.OFFSET_PIECE + board_coordinates[0] * globals.CELL_SIZE
	piece.position.y = -globals.OFFSET_PIECE + board_coordinates[1] * globals.CELL_SIZE
	
func is_valid_move(piece: Piece, dest_cell: Cell):
	var dest_coordinate = get_board_coordinates(piece.position)
	var last_coordinate = get_board_coordinates(piece.last_position)
	print("last", last_coordinate)
	if piece.position.x > 128 or piece.position.y > 128 or piece.position.x < 0 or piece.position.y < 0:
		return false
	if dest_cell.piece:
		return false
	var diff = get_coordinate_diff(piece.cell.board_coordinate, dest_coordinate)
	print("diff", diff)
	if diff[0] > 2 or diff[1] > 2:
		return false
	elif diff[0] > 1 and diff[1] > 1:
		var middle_x = dest_coordinate[0] + 1 if dest_coordinate[0] < last_coordinate[0] else dest_coordinate[0] - 1
		var middle_y = dest_coordinate[1] + 1 if dest_coordinate[1] < last_coordinate[1] else dest_coordinate[1] - 1
		var middle_cell = get_cell([middle_x, middle_y])
		print("middle",middle_cell.board_coordinate)
		if not middle_cell.piece:
			return false
		elif middle_cell.piece.color == piece.color:
			return false
		else:
			middle_cell.piece.queue_free()
	elif diff[0] != diff[1]:
		return false
	
		
	return true

func get_coordinate_diff(initial: Array, dest: Array):
	print("intial", initial)
	print("dest", dest)
	return [
		abs(initial[0] - dest[0]),
		abs(initial[1] - dest[1]),
	]
