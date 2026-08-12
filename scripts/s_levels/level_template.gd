extends Node2D

@export var level_n: int
@export var keys1_n: int
@export var keys2_n: int
@export var keys3_n: int

func _ready() -> void:
	GameManager.act_level = level_n
	GameManager.keys1_t = keys1_n
	GameManager.keys2_t = keys2_n
	GameManager.keys3_t = keys3_n
	GameManager.keys1_col = 0
	GameManager.keys2_col = 0
	GameManager.keys3_col = 0
