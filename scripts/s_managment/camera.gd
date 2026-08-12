extends Camera2D

var shake_force := 0.0
var shake_time := 0.0
var size_multiplayer := 0.0

enum Size {SMALL, MEDIUM, BIG}

@export var size: Size

func _ready() -> void:
	Events.camera_shake.connect(_on_camera_shake)
	
	if size == Size.SMALL:
		size_multiplayer = 250
	elif size == Size.MEDIUM:
		size_multiplayer = 120
	else:
		size_multiplayer = 50

func _on_camera_shake(speed, duration):
	shake_force = speed / size_multiplayer
	shake_time = duration

func _process(delta: float) -> void:
	if shake_time > 0:
		
		offset = Vector2(
			randf_range(-shake_force, shake_force),
			randf_range(-shake_force, shake_force)
		)
		
		shake_force = lerp(shake_force, 0.0, delta*10)
		shake_time -= delta
	else:
		offset = Vector2.ZERO
