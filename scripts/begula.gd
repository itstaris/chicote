extends RigidBody2D

@export var max_force := 1000.0
@export var charge_speed := 500.0
@export var extra_boost := 1000.0
@export var max_extra_clicks := 3

var force := 0.0
var charging := false
var launched := false
var extra_clicks := 0

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if !launched:
				charging = true
			else:
				give_extra_boost()

		elif !event.pressed and charging and !launched:
			launch()

func _process(delta):
	if charging and !launched:
		force = clamp(force + charge_speed * delta, 0, max_force)

func launch():
	var direction = Vector2.RIGHT.rotated(deg_to_rad(-30))
	apply_central_impulse(direction * force)
	launched = true
	charging = false
	force = 0
	extra_clicks = 0

func give_extra_boost():
	if extra_clicks < max_extra_clicks:
		var boost_dir = Vector2.RIGHT.rotated(deg_to_rad(randf_range(-20, -70)))
		apply_central_impulse(boost_dir * extra_boost)
		extra_clicks += 1
		print("chicote bum; total:", extra_clicks)
