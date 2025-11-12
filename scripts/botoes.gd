extends Control

@export var move_intensity := 0.005  # menor que o fundo pra dar profundidade

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_center = get_viewport_rect().size / 2
	var offset = (mouse_pos - screen_center) * move_intensity
	position = lerp(position, offset, 5 * delta)
