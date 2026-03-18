extends EffigyState


func update(_delta: float) -> void:
	if !effigy.animation_player.is_playing():
		var blob: Blob = _get_blob_packed_scene().instantiate()
		blob.initial_state_name = "Idle"
		LevelManager.current_level.add_child(blob)
		blob.global_position = effigy.global_position

		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	effigy.animation_player.play("deblob")
	SoundEffectManager.play_effect_at(_get_deblob_sound_effect_config(), effigy.global_position)
	TransferModeManager.disable_transfer_mode()


func exit() -> void:
	effigy.sprite_blob.visible = false
	TransferModeManager.enable_transfer_mode()
	effigy.player_controlled = false


func _get_deblob_sound_effect_config() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_deblob.tres")


func _get_blob_packed_scene() -> PackedScene:
	return load("res://scenes/blob/blob.tscn")
