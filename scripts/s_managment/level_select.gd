extends Control

func _ready() -> void:
	for index in GameManager.LEVELS.size():
		var button: Button = $BoxContainer.get_child(index)
		button.pressed.connect(GameManager.open_level.bind(index + 1))

func _on_leave_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.MAIN_MENU)
