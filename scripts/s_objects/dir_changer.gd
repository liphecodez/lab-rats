extends Area2D

enum Direction {UP, RIGHT, DOWN, LEFT}
const DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

@export var direction: Direction

func _ready() -> void:
	$Sprite2D.rotation_degrees = direction * 90

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.global_position = global_position.snapped(Vector2(16, 16))
		body.slide(DIRECTIONS[direction])
