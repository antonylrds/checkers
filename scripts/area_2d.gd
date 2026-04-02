extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered():
	# Change the sprite modulate to highlight it
	$Sprite2D.modulate = Color(1.5, 1.5, 1.5) # Glow effect

func _on_area_2d_mouse_exited():
	$Sprite2D.modulate = Color.WHITE
