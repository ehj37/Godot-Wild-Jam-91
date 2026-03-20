extends HopperState


func update(_delta: float) -> void:
	if !hopper.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	if !hopper.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	hopper.animation_player.play("blob")
	hopper.sprite_blob.visible = true
	SoundEffectManager.play_effect_at(_get_blob_sound_effect(), hopper.global_position)


func exit() -> void:
	TransferManager.transfer(hopper, hopper.transfer_area)
	TransferModeManager.enable_transfer_mode()
	hopper.player_controlled = true


func _get_blob_sound_effect() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_blob.tres")
