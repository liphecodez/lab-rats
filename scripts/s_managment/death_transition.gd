extends CanvasLayer

func play(level: Node) -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	var shade := ColorRect.new()
	shade.color = Color.BLACK
	shade.modulate.a = 0.0
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var fade_to_black := create_tween()
	fade_to_black.tween_interval(0.13)
	fade_to_black.tween_property(shade, "modulate:a", 1.0, 0.11)
	fade_to_black.tween_interval(0.05)
	await fade_to_black.finished

	var tree := get_tree()
	if not is_instance_valid(level) or tree.current_scene != level or tree.reload_current_scene() != OK:
		queue_free()
		return
	await tree.scene_changed

	var fade_from_black := create_tween()
	fade_from_black.tween_property(shade, "modulate:a", 0.0, 0.18)
	await fade_from_black.finished
	queue_free()
