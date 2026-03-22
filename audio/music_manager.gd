extends Node


func play_main_theme() -> void:
	var main_theme_audio_stream: AudioStreamOggVorbis = load("res://audio/music/main_theme.ogg")
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_stream_player.stream = main_theme_audio_stream
	audio_stream_player.bus = "Music"

	LevelManager.add_child(audio_stream_player)
	audio_stream_player.play()
