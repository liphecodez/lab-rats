extends Node

func play_sound(path):
	var audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = load(path)
	audio.play()
	audio.finished.connect(audio.queue_free)
