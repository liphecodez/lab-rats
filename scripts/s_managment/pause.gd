extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	
func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().current_scene.is_in_group("cannot_pause"):
			return
		elif VictoryMenu.visible:
			return
			
		toggle_pause()

	if event.is_action_pressed("reload"):
		if VictoryMenu.visible:
			return
		reload()

func _on_exit_pressed() -> void:
	toggle_pause()
	SoundPlayer.play_sound("res://SFX/managment_sfx/UI_click.mp3")
	get_tree().change_scene_to_file("res://scenes/management/main_menu.tscn")
	
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
