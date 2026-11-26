extends CharacterBody2D

const SPEED = 300.0
const MOVE_ACTIONS: Array[StringName] = [&"UP", &"DOWN", &"LEFT", &"RIGHT"]
const PixelBurst = preload("res://scripts/s_objects/pixel_burst.gd")
const WALL_DUST: Array[Color] = [Color("#ff9757"), Color("#d4662f"), Color("#f8ffb8")]
const DEATH_DUST: Array[Color] = [Color("#ff74aa"), Color("#ff9757"), Color("#f8ffb8")]
var idle = true
var dying = false
var portal_exit: Area2D
var moving_time = 0
var act_dir := Vector2.ZERO
var bounce_tween: Tween
var slide_distance := 0.0
var dust_cooldown := 0.0
var held_at_stop: Array[StringName] = []
@onready var spr: Sprite2D = $player_spr
@onready var sprite_rest_position := spr.position

func _physics_process(delta: float) -> void:

	var direction_y := movement_strength(&"DOWN") - movement_strength(&"UP")
	var direction_x := movement_strength(&"RIGHT") - movement_strength(&"LEFT")

	dust_cooldown = maxf(0.0, dust_cooldown - delta)
	var previous_position := global_position
	var collision := move_and_collide(velocity * delta)
	slide_distance += previous_position.distance_to(global_position)

	if collision:
		var normal := collision.get_normal()
		bounce_sprite(normal, slide_distance)
		if slide_distance >= 64.0 and is_zero_approx(dust_cooldown):
			emit_burst(collision.get_position(), WALL_DUST, 7, normal)
			dust_cooldown = 0.55
		slide_distance = 0.0
		idle = true
		global_position.x = round(global_position.x / 16) * 16
		global_position.y = round(global_position.y / 16) * 16
		velocity = Vector2.ZERO
		if moving_time > 15:
			SoundPlayer.play_sound("res://SFX/managment_sfx/Wall_hit.mp3")
			Events.camera_shake.emit(SPEED, 2.5)
		moving_time = 0
		# Let Area2D signals see the incoming direction before reading a new one.
		return

	if idle:
		if direction_x != 0 and direction_x != act_dir.x:
			slide(Vector2(direction_x, 0))
		elif direction_x == 0 and direction_y != 0 and direction_y != act_dir.y:
			slide(Vector2(0, direction_y))
	else:
		moving_time += 1

func movement_strength(action: StringName) -> float:
	if not held_at_stop.has(action):
		return Input.get_action_strength(action)
	if not Input.is_action_pressed(action):
		held_at_stop.erase(action)
	return 0.0

func stop_at(grid_position: Vector2) -> void:
	held_at_stop.clear()
	for action in MOVE_ACTIONS:
		if Input.is_action_pressed(action):
			held_at_stop.append(action)

	global_position = grid_position
	idle = true
	act_dir = Vector2.ZERO
	velocity = Vector2.ZERO
	moving_time = 0

func slide(direction: Vector2) -> void:
	if idle:
		slide_distance = 0.0
	reset_sprite_bounce()
	act_dir = direction
	velocity = direction * SPEED
	spr.rotation = Vector2.UP.angle_to(direction)
	idle = false

func bounce_sprite(normal: Vector2, distance: float) -> void:
	reset_sprite_bounce()
	var rebound := lerpf(1.0, 6.0, clampf(distance / 144.0, 0.0, 1.0))
	bounce_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	bounce_tween.tween_property(spr, "position", sprite_rest_position + normal * rebound, 0.06).set_ease(Tween.EASE_OUT)
	bounce_tween.tween_property(spr, "position", sprite_rest_position, 0.13).set_ease(Tween.EASE_IN_OUT)

func reset_sprite_bounce() -> void:
	if bounce_tween and bounce_tween.is_running():
		bounce_tween.kill()
	spr.position = sprite_rest_position

func die() -> void:
	if dying or VictoryMenu.visible or GameManager.is_transitioning():
		return
	dying = true
	set_physics_process(false)
	set_deferred("collision_layer", 0)
	begin_death.call_deferred()
	SoundPlayer.play_sound("res://SFX/managment_sfx/Death.mp3")
	SoundPlayer.play_sound("res://SFX/managment_sfx/Mouse_sniff.mp3")


func begin_death() -> void:
	emit_burst(spr.global_position, DEATH_DUST, 24)
	spr.hide()
	GameManager.restart_after_death()

func emit_burst(origin: Vector2, palette: Array[Color], count: int, direction := Vector2.ZERO) -> void:
	var burst := PixelBurst.new()
	get_tree().current_scene.add_child(burst)
	burst.emit(origin, palette, count, direction)
