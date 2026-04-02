extends Node


const CELL_SIZE = 16
const SPRITE_SIZE = 16
enum PIECE_TYPES {
	COMMON, PROMOTED
}
enum PIECE_COLORS {
	WHITE, BLACK
}
const SPRITE_MAPPING = {
	"white_common": [0, 0],
	"white_promoted": [16, 0],
	"black_common": [32, 0],
	"black_promoted": [48, 0],
}
const BOARD_COLORS = [Color.BURLYWOOD, Color.CHOCOLATE]
const BOARD_SIZE = [8, 8]
const INITIAL_POSITIONS_WHITE = [
	[0,0],
	[1,0],
	[2,0],
	[3,0],
	[4,0],
	[5,0],
	[6,0],
	[7,0],
	[0,1],
	[1,1],
	[2,1],
	[3,1],
	[4,1],
	[5,1],
	[6,1],
	[7,1],
]
const INITIAL_POSITIONS_BLACK = [
	[0,6],
	[1,6],
	[2,6],
	[3,6],
	[4,6],
	[5,6],
	[6,6],
	[7,6],
	[0,7],
	[1,7],
	[2,7],
	[3,7],
	[4,7],
	[5,7],
	[6,7],
	[7,7],
]

const INITIAL_POSITION_MAPPING = {
	PIECE_COLORS.WHITE: INITIAL_POSITIONS_WHITE,
	PIECE_COLORS.BLACK: INITIAL_POSITIONS_BLACK,
}
