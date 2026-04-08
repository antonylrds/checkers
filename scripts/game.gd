extends Node2D

@onready var board = $Board
@onready var offset_board_size_x = globals.BOARD_SIZE[0] * globals.CELL_SIZE /2
@onready var offset_board_size_y = globals.BOARD_SIZE[1] * globals.CELL_SIZE /2
var is_dragging = false
var selected_piece: Piece = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	board.position = Vector2(viewport_size.x/2 - offset_board_size_x, viewport_size.y/2 - offset_board_size_y)
	board.init_board()
	SignalBus.game_won.connect(handle_game_won)
	
func handle_game_won(color):
	board.init_board()
