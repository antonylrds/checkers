extends Area2D

var is_dragging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	# Check if the left mouse button was pressed or released
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_dragging:
		# Update position to follow the mouse cursor
		global_position = get_global_mouse_position()
	
func _input(event):
	# Stop dragging if the mouse button is released anywhere on screen
	if is_dragging and event is InputEventMouseButton and not event.pressed:
		drop_piece()
		is_dragging = false

func drop_piece():
	position.x = int(round(position.x/globals.CELL_SIZE)) * globals.CELL_SIZE
	position.y = int(round(position.y/globals.CELL_SIZE)) * globals.CELL_SIZE

func _on_area_2d_mouse_entered():
	# Change the sprite modulate to highlight it
	$Sprite2D.modulate = Color(1.5, 1.5, 1.5) # Glow effect

func _on_area_2d_mouse_exited():
	$Sprite2D.modulate = Color.WHITE
