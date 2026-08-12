extends CharacterBody2D

const SPEED = 400.0
var idle = true
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
		if direction_x != 0:
			if direction_x == act_dir.x:
				pass
			else:
				act_dir = Vector2(direction_x, 0)
				if direction_x == 1:
					spr.rotation_degrees = 90
				else:
					spr.rotation_degrees = 270
				velocity.x = direction_x * SPEED
				velocity.y = 0
				idle = false

		elif direction_y != 0:
			if direction_y == act_dir.y:
				pass
			else:
				act_dir = Vector2(0, direction_y)
				if direction_y == 1:
					spr.rotation_degrees = 180
				else:
					spr.rotation_degrees = 0
				velocity.y = direction_y * SPEED
				velocity.x = 0
				idle = false
	else:
		moving_time += 1

func die():
	get_tree().call_deferred("reload_current_scene")
	SoundPlayer.play_sound("res://SFX/managment_sfx/Death.mp3")
	SoundPlayer.play_sound("res://SFX/managment_sfx/Mouse_sniff.mp3")
