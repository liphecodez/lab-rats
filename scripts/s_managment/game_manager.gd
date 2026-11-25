extends Node

var act_level = 1
var keys1_col = 0
var keys1_t = 0
var keys2_col = 0
var keys2_t = 0
var keys3_col = 0
var keys3_t = 0

const MAIN_MENU = "res://scenes/management/main_menu.tscn"
const LEVELS = [
	"res://scenes/levels/level1.tscn",
	"res://scenes/levels/level2.tscn",
	"res://scenes/levels/level3.tscn",
	"res://scenes/levels/level4.tscn",
	"res://scenes/levels/level5.tscn",
]

func open_level(number: int) -> void:
	if number >= 1 and number <= LEVELS.size():
		get_tree().change_scene_to_file(LEVELS[number - 1])
