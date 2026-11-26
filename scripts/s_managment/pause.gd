extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	
func _input(event: InputEvent) -> void:
	if OS.has_feature("web") and event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_F:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		get_viewport().set_input_as_handled()
		return

	var scene := get_tree().current_scene
	if scene == null or scene.is_in_group("cannot_pause") or VictoryMenu.visible:
		return
	var player := get_tree().get_first_node_in_group("player")
	if player != null and player.dying:
		return
	if event.is_action_pressed("pause"):
		toggle_pause()
	elif event.is_action_pressed("reload"):
		reload()

func _on_exit_pressed() -> void:
	toggle_pause()
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")
	get_tree().change_scene_to_file(GameManager.MAIN_MENU)
	
func _on_resume_pressed() -> void:
	toggle_pause()
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")

func _on_restart_pressed() -> void:
	reload()
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	
func reload():
	if get_tree().paused == true:
		toggle_pause()
	get_tree().reload_current_scene()
