extends Node2D

@export var normal_texture: Texture2D
@export var hit_texture: Texture2D
@export var hit_duration := 0.1  # tempo que o sprite de ataque fica visível

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func _ready():
	timer.wait_time = hit_duration
	timer.one_shot = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # mantém o cursor normal visível

func _process(delta):
	# chicote segue o mouse
	global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		sprite.texture = hit_texture
		timer.start()

func _on_Timer_timeout():
	sprite.texture = normal_texture
