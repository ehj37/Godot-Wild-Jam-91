extends EvictedBlobState


func update(_delta: float) -> void:
	if !evicted_blob.animation_player.is_playing():
		evicted_blob.hop_timer.start()
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	evicted_blob.animation_player.play("splat_desplat")


func _get_splat_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_splat.tres")


func _play_splat_sound_effect() -> void:
	SoundEffectManager.play_effect_at(
		_get_splat_sound_effect_config(), evicted_blob.global_position
	)


func _get_desplat_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_desplat.tres")


func _play_desplat_sound_effect() -> void:
	SoundEffectManager.play_effect_at(
		_get_desplat_sound_effect_config(), evicted_blob.global_position
	)
