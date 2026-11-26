extends Area2D

class_name Portal
@export var destination: Portal

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or is_instance_valid(body.portal_exit):
		return
	if not is_instance_valid(destination) or destination == self or not destination.is_inside_tree():
		return
	body.portal_exit = destination
	body.global_position = destination.global_position
	SoundPlayer.play_sound("res://SFX/objects_sfx/Teleport.mp3")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body.portal_exit == self:
		body.portal_exit = null
