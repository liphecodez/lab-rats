extends CanvasLayer

enum Mode {QUIET, CHIME, DEATH}

var switching := false
var shade: ColorRect
var fade: Tween

func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	shade = ColorRect.new()
	shade.color = Color.BLACK
	shade.modulate.a = 0.0
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.hide()

func play(next_scene: String, mode: Mode = Mode.QUIET) -> void:
	if switching:
		return

	switching = true
	if fade and fade.is_running():
		fade.kill()
	shade.show()

	var tree := get_tree()
	var fade_to_black := create_tween()
	fade = fade_to_black
	if mode == Mode.DEATH:
		# Leave the level visible long enough to see the death particles.
		fade_to_black.tween_interval(0.13)
	else:
		tree.paused = true
	if mode == Mode.CHIME:
		SoundPlayer.play_transition()
	fade_to_black.tween_property(shade, "modulate:a", 1.0, 0.11)
	fade_to_black.tween_interval(0.05)
	await fade_to_black.finished

	var result := tree.reload_current_scene() if next_scene.is_empty() else tree.change_scene_to_file(next_scene)
	tree.paused = false
	switching = false
	if result == OK:
		await tree.scene_changed
	if fade != fade_to_black:
		return

	fade = create_tween()
	fade.tween_property(shade, "modulate:a", 0.0, 0.18)
	fade.tween_callback(shade.hide)
