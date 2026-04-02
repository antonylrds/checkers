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


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		is_dragging = true
	elif event is InputEventMouseMotion and is_dragging:
		pass
		#selected_piece.position = get_global_mouse_position()
	elif Input.is_action_just_released("left_click") and is_dragging:
		is_dragging = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
