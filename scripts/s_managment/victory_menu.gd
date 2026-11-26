extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("next"):
		get_viewport().set_input_as_handled()
		_on_next_pressed()

func _on_exit_pressed() -> void:
	close_victory()
	get_tree().change_scene_to_file(GameManager.MAIN_MENU)

func _on_restart_pressed() -> void:
	close_victory()
	get_tree().reload_current_scene()

func _on_next_pressed() -> void:
	close_victory()
	if GameManager.act_level < GameManager.LEVELS.size():
		GameManager.open_level(GameManager.act_level + 1)
	else:
		get_tree().change_scene_to_file(GameManager.MAIN_MENU)

func show_victory() -> void:
	var last_level: bool = GameManager.act_level == GameManager.LEVELS.size()
	$CenterContainer/HBoxContainer/next.visible = not last_level
	$Panel/Title.text = "Maze cleared!" if last_level else "Level complete!"
	$Panel/Hint.text = "ENTER   BACK TO MENU" if last_level else "ENTER   NEXT LEVEL"
	get_tree().paused = true
	show()

func close_victory() -> void:
	hide()
	get_tree().paused = false
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")
