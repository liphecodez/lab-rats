extends CharacterBody2D

const SPEED = 60.0
@onready var spr = $Sprite2D
var direction_y = 0
var direction_x = 0
enum Direction {UP_DOWN, LEFT_RIGHT}

@export var direction: Direction

func _ready() -> void:
	if direction == Direction.UP_DOWN:
		direction_y = -1
		direction_x = 0
	elif direction == Direction.LEFT_RIGHT:
		spr.rotation_degrees = 270
		direction_y = 0
		direction_x = -1
	velocity = Vector2(direction_x, direction_y) * SPEED

func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if direction == Direction.UP_DOWN:
			if direction_y == -1:
				direction_y = 1
				velocity.y = direction_y * SPEED
				spr.rotation_degrees = 180
			else:
				direction_y = -1
				velocity.y = direction_y * SPEED
				spr.rotation_degrees = 0
		else:
			if direction_x == -1:
				direction_x = 1
				velocity.x = direction_x * SPEED
				spr.rotation_degrees = 90
			else:
				direction_x = -1 
				velocity.x = direction_x * SPEED
				spr.rotation_degrees = 270
