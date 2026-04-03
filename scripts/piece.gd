extends Node2D
class_name Piece


@onready var sprite = $Area2D/Sprite2D
var sprite_size = globals.SPRITE_SIZE
var sprite_mapping = globals.SPRITE_MAPPING
var type: globals.PIECE_TYPES = globals.PIECE_TYPES.COMMON
var color: globals.PIECE_COLORS
var board_handle: Board
var is_dragging = false
var last_position = Vector2(0.0, 0.0)
var cell

const RECT_MAPPING = {
	globals.PIECE_COLORS.WHITE: {
		globals.PIECE_TYPES.COMMON: Vector2(
			globals.SPRITE_MAPPING["white_common"][0],
			globals.SPRITE_MAPPING["white_common"][1]
		),
		globals.PIECE_TYPES.PROMOTED: Vector2(
			globals.SPRITE_MAPPING["white_promoted"][0],
			globals.SPRITE_MAPPING["white_promoted"][1]
		),
	},
	globals.PIECE_COLORS.BLACK: {
		globals.PIECE_TYPES.COMMON: Vector2(
			globals.SPRITE_MAPPING["black_common"][0],
			globals.SPRITE_MAPPING["black_common"][1]
		),
		globals.PIECE_TYPES.PROMOTED: Vector2(
			globals.SPRITE_MAPPING["black_promoted"][0],
			globals.SPRITE_MAPPING["black_promoted"][1]
		),
	},
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.input_event.connect(_on_input_event)
	z_index = 1
	sprite.region_rect =  Rect2(
		RECT_MAPPING[color][type],
		Vector2(sprite_size, sprite_size)
	)
	position = Vector2(
		globals.OFFSET_PIECE + position[0] * globals.CELL_SIZE,
		globals.OFFSET_PIECE + position[1] * globals.CELL_SIZE
	)
	last_position = position

func _on_input_event(_viewport, event, _shape_idx):
	# Check if the left mouse button was pressed or released
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		globals.is_dragging = event.pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_dragging:
		z_index = 1000
		# Update position to follow the mouse cursor
		global_position = get_global_mouse_position()
	
func _input(event):
	# Stop dragging if the mouse button is released anywhere on screen
	if is_dragging and event is InputEventMouseButton and not event.pressed:
		drop_piece()
		is_dragging = false
		globals.is_dragging = false

func drop_piece():
	z_index = 1
	SignalBus.piece_moved.emit(self)

func _on_area_2d_mouse_entered() -> void:
	sprite.modulate = Color(1.5, 1.5, 1.5) # Glow effect

func _on_area_2d_mouse_exited() -> void:
	sprite.modulate = Color.WHITE
