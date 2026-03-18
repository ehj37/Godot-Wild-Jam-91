extends HollowState


func update(_delta: float) -> void:
	if not hollow.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	hollow.animation_player.play("blob")
	SoundEffectManager.play_effect_at(_get_blob_sound_effect(), hollow.global_position)


func exit() -> void:
	TransferManager.transfer(hollow, hollow.transfer_area)
	TransferModeManager.enable_transfer_mode()
	hollow.player_controlled = true
	hollow.sprite_blob.visible = true


func _get_blob_sound_effect() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_blob.tres")
