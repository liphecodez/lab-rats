extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.idle = true
		body.global_position.x = round(global_position.x / 16) * 16
		body.global_position.y = round(global_position.y / 16) * 16
		body.act_dir = Vector2.ZERO
		body.velocity = Vector2.ZERO
