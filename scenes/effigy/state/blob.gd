extends EffigyState


func update(_delta: float) -> void:
	if not effigy.animation_player.is_playing() && effigy.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
			return


func enter(_data: Dictionary = {}) -> void:
	effigy.animation_player.play("blob")
	SoundEffectManager.play_effect_at(_get_blob_sound_effect(), effigy.global_position)

	TransferManager.transfer(effigy, effigy.transfer_area)
	TransferModeManager.enable_transfer_mode()
	effigy.sprite_blob.visible = true

	effigy.player_controlled = true


func _get_blob_sound_effect() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_blob.tres")
