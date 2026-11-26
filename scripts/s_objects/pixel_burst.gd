extends Node2D

var velocities: Array[Vector2] = []
var colors: Array[Color] = []
var ages: Array[float] = []
var elapsed := 0.0
var duration := 0.0

func emit(origin: Vector2, palette: Array[Color], count: int, direction := Vector2.ZERO) -> void:
	global_position = origin
	z_index = 3
	for index in count:
		var angle := randf_range(-PI, PI) if direction == Vector2.ZERO else direction.angle() + randf_range(-1.1, 1.1)
		velocities.append(Vector2.from_angle(angle) * randf_range(24.0, 85.0))
		colors.append(palette[index % palette.size()])
		var lifetime := randf_range(0.16, 0.34)
		ages.append(lifetime)
		duration = maxf(duration, lifetime)
	queue_redraw()

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= duration:
		queue_free()
	else:
		queue_redraw()

func _draw() -> void:
	for index in velocities.size():
		if elapsed >= ages[index]:
			continue
		var color := colors[index]
		color.a = 1.0 - elapsed / ages[index]
		var offset := (velocities[index] * elapsed + Vector2(0, 55.0 * elapsed * elapsed)).round()
		var side := 2.0 if index % 3 == 0 else 1.0
		draw_rect(Rect2(offset, Vector2.ONE * side), color)
