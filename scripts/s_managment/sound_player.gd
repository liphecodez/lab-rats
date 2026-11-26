extends Node

const SFX_PITCH := Vector2(0.94, 1.06)

@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_input(OS.has_feature("web"))
	if not OS.has_feature("web") and DisplayServer.get_name() != "headless":
		_start_music()

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		_start_music()
		set_process_input(false)

func _start_music() -> void:
	# Keep the loop in the audio mixer, including on the Web export.
	music.playback_type = AudioServer.PLAYBACK_TYPE_STREAM
	music.play()
	var drift := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	drift.tween_property(music, "pitch_scale", 1.009, 14.0)
	drift.tween_property(music, "pitch_scale", 0.993, 17.0)
	drift.tween_property(music, "pitch_scale", 1.0, 19.0)

func play_transition() -> void:
	play_sound("res://SFX/managment_sfx/Transicao_fase.mp3", -26.0, 0.22)

func play_click() -> void:
	play_sound("res://SFX/managment_sfx/UI_click.mp3", 4.0, 0.02)

func play_sound(path: String, volume_db := 0.0, from_position := 0.0) -> void:
	if DisplayServer.get_name() == "headless":
		return
	var audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = load(path)
	audio.volume_db = volume_db
	audio.pitch_scale = randf_range(SFX_PITCH.x, SFX_PITCH.y)
	audio.finished.connect(audio.queue_free)
	audio.play(from_position)
