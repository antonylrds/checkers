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
var pieces = {
	globals.PIECE_COLORS.WHITE: [],
	globals.PIECE_COLORS.BLACK: []
}

func _ready() -> void:
	SignalBus.piece_moved.connect(_on_piece_droped)
	SignalBus.gane_won.connect(handle_game_won)
	
func handle_game_won():
	pass
	
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
				piece = instantiate_piece(Vector2(x, y), globals.PIECE_COLORS.WHITE)
			elif coordinates in globals.INITIAL_POSITION_MAPPING[globals.PIECE_COLORS.BLACK]:
				piece = instantiate_piece(Vector2(x, y), globals.PIECE_COLORS.BLACK)
			if piece:
				pieces[piece.color].append(piece)
				piece.board_handle = self
				cell.piece = piece
				piece.cell = cell
				add_child(piece)
			cells.append(cell)
			piece = null
	
func instantiate_piece(pos: Vector2, color: globals.PIECE_COLORS):
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
		if should_promote(piece):
			piece.promote()
		if not pieces[globals.PIECE_COLORS.WHITE]:
			SignalBus.game_won.emit(globals.PIECE_COLORS.BLACK)
		elif not pieces[globals.PIECE_COLORS.BLACK]:
			SignalBus.game_won.emit(globals.PIECE_COLORS.WHITE)
	
func get_cell(board_coordinates: Array) -> Cell:
	for cell in cells:
		if [cell.board_coordinate[0], cell.board_coordinate[1]] == board_coordinates:
			return cell
	return null
	
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
	var diff = get_coordinate_diff(piece.cell.board_coordinate, dest_coordinate)
	if dest_coordinate[0] > 8 or dest_coordinate[1] > 8 or dest_coordinate[0] < 1 or dest_coordinate[1] < 1:
		return false
	if dest_cell.piece:
		return false
	if diff[0] != diff[1]:
		return false
	if piece.type == globals.PIECE_TYPES.COMMON:
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
		elif diff[0] > 0 and diff[1] > 0:
			if (
				dest_coordinate[1] < last_coordinate[1] and piece.color == globals.PIECE_COLORS.WHITE or
				dest_coordinate [1] > last_coordinate[1] and piece.color == globals.PIECE_COLORS.BLACK
			):
				return false
	else:
		var cells_found = beam_piece_search(last_coordinate, dest_coordinate)
		if len(cells_found) > 1:
			return false
		if len(cells_found) == 1:
			if cells_found[0].color == piece.color:
				return false
			else:
				cells_found[0].queue_free()
	return true
	
func beam_piece_search(last: Array, dest: Array) -> Array[Piece]:
	var pieces_found: Array[Piece] = []
	var direction_x = 1 if dest[0] > last[0] else -1
	var direction_y = 1 if dest[1] > last[1] else -1
	var current_coord = [last[0] + direction_x, last[1] + direction_y]
	while (
		(8 > current_coord[0] and current_coord[0] > 0) and 
		(8 > current_coord[1] and current_coord[1] > 0) 
	):
		if current_coord == dest:
			break
		var found_cell = get_cell(current_coord)
		if found_cell.piece:
			pieces_found.append(found_cell.piece)
		current_coord[0] += direction_x
		current_coord[1] += direction_y
		
	return pieces_found
		

func get_coordinate_diff(initial: Array, dest: Array):
	print("intial", initial)
	print("dest", dest)
	return [
		abs(initial[0] - dest[0]),
		abs(initial[1] - dest[1]),
	]
	
func should_promote(piece: Piece):
	if piece.type == globals.PIECE_TYPES.PROMOTED:
		return false
	if (
		piece.color == globals.PIECE_COLORS.WHITE and piece.cell.board_coordinate[1] == 8 or
		piece.color == globals.PIECE_COLORS.BLACK and piece.cell.board_coordinate[1] == 1
	):
		return true
	return false
