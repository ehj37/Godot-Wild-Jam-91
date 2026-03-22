extends BlobState


func update(_delta: float) -> void:
	if !blob.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	blob.animation_player.play("desplat_right")
	SoundEffectManager.play_effect(_get_desplat_sound_effect_config())


func _get_desplat_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_desplat.tres")
