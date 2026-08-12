extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next") and visible == true:
		toggle_victory()
		get_tree().change_scene_to_file(GameManager.LEVELS[GameManager.act_level + 1])

func _on_exit_pressed() -> void:
	toggle_victory()
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")
	get_tree().change_scene_to_file("res://scenes/management/main_menu.tscn")

func _on_restart_pressed() -> void:
	toggle_victory()
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")
	get_tree().reload_current_scene()

func _on_next_pressed() -> void:
	toggle_victory()
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")
	get_tree().change_scene_to_file(GameManager.LEVELS[GameManager.act_level + 1])

func toggle_victory():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
