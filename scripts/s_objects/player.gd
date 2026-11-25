extends CharacterBody2D

const SPEED = 400.0
var idle = true
var dying = false
var portal_exit: Area2D
var moving_time = 0
var act_dir := Vector2.ZERO
@onready var spr = $"player_spr"

func _physics_process(delta: float) -> void:

	var direction_y := Input.get_axis("UP", "DOWN")
	var direction_x := Input.get_axis("LEFT", "RIGHT")

	var collision = move_and_collide(velocity * delta)

	if collision:
		idle = true
		global_position.x = round(global_position.x / 16) * 16
		global_position.y = round(global_position.y / 16) * 16
		velocity = Vector2.ZERO
		if moving_time > 15:
			SoundPlayer.play_sound("res://SFX/managment_sfx/Wall_hit.mp3")
			Events.camera_shake.emit(SPEED, 2.5)
		moving_time = 0

	if idle:
		if direction_x != 0 and direction_x != act_dir.x:
			slide(Vector2(direction_x, 0))
		elif direction_x == 0 and direction_y != 0 and direction_y != act_dir.y:
			slide(Vector2(0, direction_y))
	else:
		moving_time += 1

func slide(direction: Vector2) -> void:
	act_dir = direction
	velocity = direction * SPEED
	spr.rotation = Vector2.UP.angle_to(direction)
	idle = false

func die() -> void:
	if dying or VictoryMenu.visible:
		return
	dying = true
	get_tree().call_deferred("reload_current_scene")
	SoundPlayer.play_sound("res://SFX/managment_sfx/Death.mp3")
	SoundPlayer.play_sound("res://SFX/managment_sfx/Mouse_sniff.mp3")
