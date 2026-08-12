extends Area2D

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		VictoryMenu.toggle_victory()
		SoundPlayer.play_sound("res://SFX/objects_sfx/Goal.mp3")
		queue_free()
