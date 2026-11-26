extends Control

func _ready() -> void:
	if OS.has_feature("web"):
		$VBoxContainer/quit.hide()

func _on_play_pressed() -> void:
	GameManager.open_level(GameManager.act_level)

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/management/level_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
