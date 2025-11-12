extends Node2D

@export var normal_texture: Texture2D
@export var hit_texture: Texture2D
@export var hit_duration := 0.1

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var whip_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	# garante que sempre começa com a textura normal
	if normal_texture:
		sprite.texture = normal_texture
	else:
		push_error(" normal_texture não atribuída!")

	timer.wait_time = hit_duration
	timer.one_shot = true

	# garante que o timer esteja conectado
	if not timer.is_connected("timeout", Callable(self, "_on_Timer_timeout")):
		timer.timeout.connect(_on_Timer_timeout)

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if hit_texture:
			sprite.texture = hit_texture
			whip_sound.play()
			timer.start()
		else:
			push_error("hit_texture não atribuída!")

func _on_Timer_timeout():
	sprite.texture = normal_texture
