extends StaticBody2D

enum type {
	green, red, blue
}

@export var variation: type

func _ready() -> void:
	Events.key_collected.connect(_on_key_collected)

func _on_key_collected():
	if variation == type.green:
		if GameManager.keys1_col == GameManager.keys1_t:
			queue_free()
	if variation == type.red:
		if GameManager.keys2_col == GameManager.keys2_t:
			queue_free()
	if variation == type.blue:
		if GameManager.keys3_col == GameManager.keys3_t:
			queue_free()
