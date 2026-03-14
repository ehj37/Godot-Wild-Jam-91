extends Node2D


# Plays sound effect at center of screen for given global position
# Void for now; if the need for sound effect cancellation arises, will need to
# change to return reference to instantiated audio stream player
func play_effect_at(
	sound_effect_config: SoundEffectConfig, effect_global_position: Vector2
) -> void:
	var screen_coords: Vector2i = ScreenCoordsHelper.get_screen_coords(effect_global_position)

	var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_stream_player.stream = sound_effect_config.audio_stream
	audio_stream_player.global_position = ScreenCoordsHelper.get_screen_center_global_position(
		screen_coords
	)

	add_child(audio_stream_player)

	audio_stream_player.play()
	audio_stream_player.finished.connect(func() -> void: audio_stream_player.queue_free())
