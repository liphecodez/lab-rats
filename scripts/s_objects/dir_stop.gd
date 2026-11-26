extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.stop_at(global_position.snapped(Vector2(16, 16)))
