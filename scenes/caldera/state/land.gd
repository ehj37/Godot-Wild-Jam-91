extends CalderaState


func update(_delta: float) -> void:
	if !caldera.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	caldera.animation_player.play("land")
	SoundEffectManager.play_effect_at(_get_land_sound_effect_config(), caldera.global_position)


func _get_land_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/caldera/sound_effects/caldera_land.tres")
