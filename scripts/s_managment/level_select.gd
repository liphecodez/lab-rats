extends Control

func _ready() -> void:
	for index in GameManager.LEVELS.size():
		var button: Button = $BoxContainer.get_child(index)
		button.pressed.connect(_on_level_pressed.bind(index + 1))

func _on_level_pressed(number: int) -> void:
	SoundPlayer.play_click()
	GameManager.open_level(number)

func _on_leave_pressed() -> void:
	SoundPlayer.play_click()
	get_tree().change_scene_to_file(GameManager.MAIN_MENU)
