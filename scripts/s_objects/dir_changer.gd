extends Area2D

enum Direction {UP, RIGHT, DOWN, LEFT}

@export var direction: Direction

func _ready() -> void:
	if direction == Direction.RIGHT:
		$Sprite2D.rotation_degrees = 90
	elif direction == Direction.DOWN:
		$Sprite2D.rotation_degrees = 180
	elif direction == Direction.LEFT:
		$Sprite2D.rotation_degrees = 270

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		
		body.global_position.x = round(global_position.x / 16) * 16
		body.global_position.y = round(global_position.y / 16) * 16
		
		if direction == Direction.UP:
			body.velocity.x = 0
			body.velocity.y = body.SPEED * -1
			body.act_dir = Vector2(body.velocity.x, body.velocity.y)
			body.spr.rotation_degrees = 0
		elif direction == Direction.RIGHT:
			body.velocity.x = body.SPEED * 1
			body.velocity.y = 0
			body.act_dir = Vector2(body.velocity.x, body.velocity.y)
			body.spr.rotation_degrees = 90
		elif direction == Direction.DOWN:
			body.velocity.x = 0
			body.velocity.y = body.SPEED * 1
			body.act_dir = Vector2(body.velocity.x, body.velocity.y)
			body.spr.rotation_degrees = 180
		elif direction == Direction.LEFT:
			body.velocity.x = body.SPEED * -1
			body.velocity.y = 0
			body.act_dir = Vector2(body.velocity.x, body.velocity.y)
			body.spr.rotation_degrees = 270
