extends CalderaState


func update(_delta: float) -> void:
	if not caldera.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	caldera.animation_player.play("blob")
	SoundEffectManager.play_effect_at(_get_blob_sound_effect(), caldera.global_position)


func exit() -> void:
	TransferManager.transfer(caldera, caldera.transfer_area)
	TransferModeManager.enable_transfer_mode()
	caldera.player_controlled = true
	caldera.sprite_blob.visible = true


func _get_blob_sound_effect() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_blob.tres")
