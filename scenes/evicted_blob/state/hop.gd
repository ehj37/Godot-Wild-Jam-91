extends EvictedBlobState

const JUMP_IMPULSE_MAGNITUDE: float = 250.0


func enter(_data: Dictionary = {}) -> void:
	var impulse: Vector2 = Vector2(1, -1).normalized() * JUMP_IMPULSE_MAGNITUDE
	evicted_blob.apply_central_impulse(impulse)
	evicted_blob.hop_timer.start()
	SoundEffectManager.play_effect_at(_get_hop_sound_effect_config(), evicted_blob.global_position)

	state_machine.transition_to("Airborne", {"animation": "hop"})


func _get_hop_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_jump.tres")
