extends Node2D

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		body.die()
