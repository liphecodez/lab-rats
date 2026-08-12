extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.LEVELS[GameManager.act_level])

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/management/level_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
 
