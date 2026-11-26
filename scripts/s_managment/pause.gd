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
	if scene == null or scene.is_in_group("cannot_pause") or VictoryMenu.visible or GameManager.is_transitioning():
		return
	var player := get_tree().get_first_node_in_group("player")
	if player != null and player.dying:
		return
	if event.is_action_pressed("pause"):
		toggle_pause()
	elif event.is_action_pressed("reload"):
		reload(true)

func _on_exit_pressed() -> void:
	SoundPlayer.play_click()
	toggle_pause()
	GameManager.return_to_menu()
	
func _on_resume_pressed() -> void:
	toggle_pause()
	SoundPlayer.play_click()

func _on_restart_pressed() -> void:
	SoundPlayer.play_click()
	reload()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	
func reload(with_chime := false) -> void:
	if get_tree().paused == true:
		toggle_pause()
	GameManager.restart_level(with_chime)
