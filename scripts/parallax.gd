extends Parallax2D

@export var parallax_speed := 0.1 
@onready var screen_center := get_viewport_rect().size / 1

func _ready():

	position = screen_center
	scroll_offset = Vector2.ZERO

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var offset = (mouse_pos - screen_center) * parallax_speed
	

	scroll_offset = lerp(scroll_offset, offset, 5 * delta)
