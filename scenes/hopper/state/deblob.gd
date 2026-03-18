extends HopperState


func update(_delta: float) -> void:
	if !hopper.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	if !hopper.animation_player.is_playing():
		hopper.player_controlled = false
		hopper.spawn_blob()

		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	hopper.animation_player.play("deblob")
	SoundEffectManager.play_effect_at(_get_deblob_sound_effect_config(), hopper.global_position)
	TransferModeManager.disable_transfer_mode()


func exit() -> void:
	TransferModeManager.enable_transfer_mode()


func _get_deblob_sound_effect_config() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_deblob.tres")
