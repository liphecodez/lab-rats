extends Node

var act_level = 1
var keys1_col = 0
var keys1_t = 0
var keys2_col = 0
var keys2_t = 0
var keys3_col = 0
var keys3_t = 0

const SceneTransition = preload("res://scripts/s_managment/scene_transition.gd")
const MAIN_MENU = "res://scenes/management/main_menu.tscn"
const LEVELS = [
	"res://scenes/levels/level1.tscn",
	"res://scenes/levels/level2.tscn",
	"res://scenes/levels/level3.tscn",
	"res://scenes/levels/level4.tscn",
	"res://scenes/levels/level5.tscn",
	"res://scenes/levels/level6.tscn",
	"res://scenes/levels/level7.tscn",
	"res://scenes/levels/level8.tscn",
]

var transition := SceneTransition.new()

func _ready() -> void:
	add_child(transition)

func open_level(number: int, with_chime := false) -> void:
	if number >= 1 and number <= LEVELS.size():
		transition.play(LEVELS[number - 1], transition_mode(with_chime))

func restart_level(with_chime := false) -> void:
	transition.play("", transition_mode(with_chime))

func restart_after_death() -> void:
	transition.play("", SceneTransition.Mode.DEATH)

func transition_mode(with_chime: bool) -> SceneTransition.Mode:
	return SceneTransition.Mode.CHIME if with_chime else SceneTransition.Mode.QUIET

func return_to_menu() -> void:
	transition.play(MAIN_MENU)

func is_transitioning() -> bool:
	return transition.switching
