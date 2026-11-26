extends Node

@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_input(OS.has_feature("web"))
	if not OS.has_feature("web") and DisplayServer.get_name() != "headless":
		music.play()

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		music.play()
		set_process_input(false)

func play_sound(path: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	var audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = load(path)
	audio.play()
	audio.finished.connect(audio.queue_free)
