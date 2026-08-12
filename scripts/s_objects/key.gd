extends Area2D

enum type {
	green, red, blue
}

@export var variation: type

func _on_body_entered(body: Node2D) -> void:

	if variation == type.green:
		if body.is_in_group("player"):
			GameManager.keys1_col += 1
			Events.key_collected.emit()
			if GameManager.keys1_col == GameManager.keys1_t:
				SoundPlayer.play_sound("res://SFX/objects_sfx/Open_door.mp3")
			SoundPlayer.play_sound("res://SFX/objects_sfx/Key.mp3")
			queue_free()
			
	if variation == type.red:
		if body.is_in_group("player"):
			GameManager.keys2_col += 1
			Events.key_collected.emit()
			if GameManager.keys2_col == GameManager.keys2_t:
				SoundPlayer.play_sound("res://SFX/objects_sfx/Open_door.mp3")
			SoundPlayer.play_sound("res://SFX/objects_sfx/Key.mp3")
			queue_free()
			
	if variation == type.blue:
		if body.is_in_group("player"):
			GameManager.keys3_col += 1
			Events.key_collected.emit()
			if GameManager.keys3_col == GameManager.keys3_t:
				SoundPlayer.play_sound("res://SFX/objects_sfx/Open_door.mp3")
			SoundPlayer.play_sound("res://SFX/objects_sfx/Key.mp3")
			queue_free()
