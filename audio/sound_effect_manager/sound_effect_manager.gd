extends Node2D

const MAX_DISTANCE: float = 400.0


class SoundEffectDetails:
	var audio_stream_player: AudioStreamPlayer2D
	var screen_coords: Vector2i
	var type: String

	func _init(asp: AudioStreamPlayer2D, sc: Vector2i, t: String) -> void:
		audio_stream_player = asp
		screen_coords = sc
		type = t


var _sound_effect_details_by_screen_coords: Dictionary = {}


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
	audio_stream_player.max_distance = MAX_DISTANCE

	add_child(audio_stream_player)

	# Only ever play one of the same sound effect at a given screen coordinate
	# at any one time.
	# Cancels any other sound effects of the same type currently playing.
	var sound_effects_at_screen_coords: Array = _sound_effect_details_by_screen_coords.get(
		screen_coords, []
	)
	var conflicts: Array[SoundEffectDetails]
	for potential_conflict: SoundEffectDetails in sound_effects_at_screen_coords:
		if potential_conflict.type == sound_effect_config.type:
			conflicts.append(potential_conflict)

	for conflict: SoundEffectDetails in conflicts:
		_remove_effect(conflict)

	var sound_effect_details: SoundEffectDetails = SoundEffectDetails.new(
		audio_stream_player, screen_coords, sound_effect_config.type
	)
	if _sound_effect_details_by_screen_coords.get(screen_coords) == null:
		_sound_effect_details_by_screen_coords[screen_coords] = [sound_effect_details]
	else:
		@warning_ignore("unsafe_cast")
		(_sound_effect_details_by_screen_coords[screen_coords] as Array).append(
			sound_effect_details
		)

	audio_stream_player.play()
	audio_stream_player.finished.connect(func() -> void: _remove_effect(sound_effect_details))


func _remove_effect(sound_effect_details: SoundEffectDetails) -> void:
	@warning_ignore("unsafe_cast")
	(_sound_effect_details_by_screen_coords.get(sound_effect_details.screen_coords) as Array).erase(
		sound_effect_details
	)
	sound_effect_details.audio_stream_player.queue_free()
