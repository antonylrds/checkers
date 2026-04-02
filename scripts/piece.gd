extends Node2D
class_name Piece

@onready var sprite = $Area2D/Sprite2D
var sprite_size = globals.SPRITE_SIZE
var sprite_mapping = globals.SPRITE_MAPPING
var type: globals.PIECE_TYPES = globals.PIECE_TYPES.COMMON
var color: globals.PIECE_COLORS
var offset_piece = globals.CELL_SIZE/2

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
	z_index += 1
	sprite.region_rect =  Rect2(
		RECT_MAPPING[color][type],
		Vector2(sprite_size, sprite_size)
	)
	position = Vector2(
		offset_piece + position[0] * globals.CELL_SIZE,
		offset_piece + position[1] * globals.CELL_SIZE
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	sprite.modulate = Color(1.5, 1.5, 1.5) # Glow effect


func _on_area_2d_mouse_exited() -> void:
	sprite.modulate = Color.WHITE
