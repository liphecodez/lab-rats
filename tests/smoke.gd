extends Node

func _ready() -> void:
	# Keep this runner alive while the main scenes are replaced.
	get_tree().current_scene = null
	run.call_deferred()

func run() -> void:
	var tree := get_tree()
	for directory in ["scenes/objects", "scenes/levels", "scenes/management"]:
		for file in DirAccess.get_files_at("res://" + directory):
			if file.ends_with(".tscn"):
				assert(load("res://%s/%s" % [directory, file]).can_instantiate())
	for directory in ["s_objects", "s_levels", "s_managment"]:
		for file in DirAccess.get_files_at("res://scripts/" + directory):
			if file.ends_with(".gd"):
				assert(load("res://scripts/%s/%s" % [directory, file]).can_instantiate())

	GameManager.open_level(1)
	await tree.scene_changed
	for number in range(1, 6):
		assert(GameManager.act_level == number)
		GameManager.keys1_col = 1
		PauseMenu.toggle_pause()
		PauseMenu._on_restart_pressed()
		await tree.scene_changed
		assert(not tree.paused and not PauseMenu.visible and GameManager.keys1_col == 0)
		var player = tree.current_scene.get_node("map/objects/player")
		var goal = tree.current_scene.get_node("map/objects/Goal")
		goal._on_body_entered(player)
		assert(VictoryMenu.visible and tree.paused)
		assert(VictoryMenu.get_node("CenterContainer/HBoxContainer/next").visible == (number < 5))
		# Exercise the same handler used by Enter and by the Next button.
		VictoryMenu._on_next_pressed()
		await tree.scene_changed
		assert(not VictoryMenu.visible and not tree.paused)
	assert(tree.current_scene.scene_file_path == GameManager.MAIN_MENU)

	GameManager.open_level(3)
	await tree.scene_changed
	var objects := tree.current_scene.get_node("map/objects")
	var rat = objects.get_node("player")
	var redirect = objects.get_node("Dir_Changer")
	var spike = objects.get_node("Spike")
	redirect._on_body_entered(rat)
	assert(rat.act_dir == Vector2.DOWN and rat.velocity == Vector2.DOWN * rat.SPEED)
	spike._on_body_entered(rat)
	assert(rat.dying)
	spike._on_body_entered(rat)
	objects.get_node("Goal")._on_body_entered(rat)
	assert(not VictoryMenu.visible)
	await tree.scene_changed
	assert(GameManager.act_level == 3)

	objects = tree.current_scene.get_node("map/objects")
	rat = objects.get_node("player")
	var portal_scene := preload("res://scenes/objects/teleport1.tscn")
	var entry: Portal = portal_scene.instantiate()
	var exit: Portal = portal_scene.instantiate()
	entry.position = Vector2(-100, -100)
	exit.position = Vector2(-200, -100)
	objects.add_child(entry)
	objects.add_child(exit)
	var start: Vector2 = rat.global_position
	entry._on_body_entered(rat)
	assert(rat.global_position == start)
	entry.destination = entry
	entry._on_body_entered(rat)
	assert(rat.global_position == start)
	entry.destination = exit
	exit.destination = entry
	entry._on_body_entered(rat)
	entry._on_body_exited(rat)
	exit._on_body_entered(rat)
	assert(rat.global_position == exit.global_position and rat.portal_exit == exit)
	exit._on_body_exited(rat)
	assert(rat.portal_exit == null)

	print("Lab Rats smoke checks passed")
	tree.quit()
