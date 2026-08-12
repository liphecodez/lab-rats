extends Area2D

class_name Portal
@export var destination: Portal

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and GameManager.in_teleport == false:
		GameManager.in_teleport = true
		SoundPlayer.play_sound("res://SFX/objects_sfx/Teleport.mp3")
		body.global_position = destination.global_position

func _on_body_exited(_body: Node2D) -> void:
	GameManager.in_teleport = false
