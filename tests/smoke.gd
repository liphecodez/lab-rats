extends Node

const ROUTES = [
	"RULULDRUR",
	"URU",
	"URDR",
	"RDRURDLDRURDLLURULDDULULD",
	"LDRURLULURRULDRDLULDURDRU",
	"RURULUR",
	"URLDRDL",
	"URRULDDRDL",
]
const ACTIONS = {"U": "UP", "R": "RIGHT", "D": "DOWN", "L": "LEFT"}

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

	assert(ROUTES.size() == GameManager.LEVELS.size())
	GameManager.open_level(1)
	await tree.scene_changed
	for number in range(1, ROUTES.size() + 1):
		assert(GameManager.act_level == number)
		GameManager.keys1_col = 1
		PauseMenu.toggle_pause()
		PauseMenu._on_restart_pressed()
		await tree.scene_changed
		assert(not tree.paused and not PauseMenu.visible and GameManager.keys1_col == 0)
		await play_route(ROUTES[number - 1])
		assert(VictoryMenu.visible, "Could not solve level %s" % number)
		if number == 1:
			VictoryMenu._on_restart_pressed()
			await tree.scene_changed
			assert(not tree.paused and not VictoryMenu.visible and GameManager.act_level == 1)
			await play_route(ROUTES[0])
		assert(VictoryMenu.visible and tree.paused)
		assert(VictoryMenu.get_node("CenterContainer/HBoxContainer/next").visible == (number < ROUTES.size()))
		# Exercise the same handler used by Enter and by the Next button.
		VictoryMenu._on_next_pressed()
		await tree.scene_changed
		assert(not VictoryMenu.visible and not tree.paused)
	assert(tree.current_scene.scene_file_path == GameManager.MAIN_MENU)

	# A held key must not immediately restart the slide from a stop tile.
	GameManager.open_level(6)
	await tree.scene_changed
	await play_route("R")
	var stopped_player = tree.current_scene.get_node("map/objects/player")
	var stop_position: Vector2 = tree.current_scene.get_node("map/objects/LowerStop").global_position
	Input.action_press("UP")
	for frame in 36:
		await tree.physics_frame
	assert(is_instance_valid(stopped_player) and stopped_player.idle and stopped_player.global_position == stop_position)
	Input.action_release("UP")
	await tree.physics_frame
	await tree.physics_frame
	Input.action_press("UP")
	await tree.physics_frame
	await tree.physics_frame
	Input.action_release("UP")
	assert(not stopped_player.idle and stopped_player.velocity.y < 0.0)
	await tree.scene_changed
	assert(GameManager.act_level == 6)

	# Test head-on approaches into both branches of level 6 with opposite input.
	for approach in [["UP", "DOWN"], ["LEFT", "RIGHT"]]:
		await play_route("RU")
		var before_death := tree.current_scene.get_instance_id()
		Input.action_press(approach[0])
		await tree.physics_frame
		await tree.physics_frame
		Input.action_release(approach[0])
		Input.action_press(approach[1])
		await tree.scene_changed
		Input.action_release(approach[1])
		assert(GameManager.act_level == 6 and tree.current_scene.get_instance_id() != before_death)

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


func play_route(route: String) -> void:
	var tree := get_tree()
	var player := tree.current_scene.get_node("map/objects/player")
	for frame in range(5):
		await tree.physics_frame
	for index in route.length():
		if GameManager.act_level == 8 and index == route.length() - 1:
			var patrol := tree.current_scene.get_node("map/objects/Patrol") as CharacterBody2D
			# Cross once the patrol is moving toward the far end of its vertical lane.
			while patrol.position.y >= 96.0 or patrol.velocity.y >= 0.0:
				await tree.physics_frame
		var action: String = ACTIONS[route[index]]
		Input.action_press(action)
		await tree.physics_frame
		await tree.physics_frame
		Input.action_release(action)
		for frame in range(1200):
			if not is_instance_valid(player):
				return
			if player.idle or VictoryMenu.visible:
				break
			await tree.physics_frame
		if VictoryMenu.visible:
			break
