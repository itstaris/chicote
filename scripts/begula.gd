extends RigidBody2D

@export var max_force := 2000.0
@export var charge_speed := 1000.0
@export var extra_boost := 1250.0
@export var max_extra_clicks := 3
@export var spin_speed := 360.0
@export var hit_flash_time := 0.1 

var force := 0.0
var charging := false
var launched := false
var extra_clicks := 0
var music_started := false

@onready var sprite_idle = $SpriteIdle
@onready var sprite_hit = $SpriteHit
@onready var hit_timer = $HitTimer
@onready var whip_icons := [
	get_tree().get_root().find_child("Whip1", true, false),
	get_tree().get_root().find_child("Whip2", true, false),
	get_tree().get_root().find_child("Whip3", true, false)
]
@onready var music_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var barra_forca: ProgressBar

func _ready():
	barra_forca = get_tree().get_root().find_child("StrengthBar", true, false)
	sprite_hit.visible = false
	hit_timer.wait_time = hit_flash_time
	hit_timer.one_shot = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if !launched:
				start_charging()
			else:
				give_extra_boost()
		elif !event.pressed and charging and !launched:
			launch()

func _process(delta):
	if charging and !launched:
		force = clamp(force + charge_speed * delta, 0, max_force)
		barra_forca.value = force

func start_charging():
	charging = true
	force = 0
	barra_forca.visible = true
	barra_forca.value = 0

func launch():
	var direction = Vector2.RIGHT.rotated(deg_to_rad(-30))
	apply_central_impulse(direction * force)
	launched = true
	charging = false
	barra_forca.visible = false
	force = 0
	extra_clicks = 0
	update_whip_icons()
	if not music_started:
		music_player.play()
		music_started = true

func give_extra_boost():
	if extra_clicks < max_extra_clicks:
		var boost_dir = Vector2.RIGHT.rotated(deg_to_rad(randf_range(-20, -70)))
		apply_central_impulse(boost_dir * extra_boost)
		extra_clicks += 1
		show_hit_sprite()
		update_whip_icons()

func _physics_process(delta):
	if launched and linear_velocity.length() > 10:
		rotation_degrees += spin_speed * delta

# --- ANIMAÇÃO DE HIT ---
func show_hit_sprite():
	sprite_idle.visible = false
	sprite_hit.visible = true
	hit_timer.start()

func _on_HitTimer_timeout():
	sprite_idle.visible = true
	sprite_hit.visible = false

func update_whip_icons():
	for i in range(max_extra_clicks):
		if whip_icons[i]:
			whip_icons[i].visible = i >= extra_clicks


func _on_Timer_timeout() -> void:
	pass # Replace with function body.
