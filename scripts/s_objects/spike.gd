extends Area2D

enum Direction {UP, RIGHT, DOWN, LEFT}
@export var direction: Direction
var spike_dir: Vector2

func _ready() -> void:
	if direction == Direction.UP:
		spike_dir = Vector2.UP
		
	elif direction == Direction.RIGHT:
		spike_dir = Vector2.RIGHT
		rotation_degrees = 90
		
	elif direction == Direction.DOWN:
		spike_dir = Vector2.DOWN
		rotation_degrees = 180
		
	else:
		spike_dir = Vector2.LEFT
		rotation_degrees = 270

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.act_dir == -spike_dir:
			body.die()
