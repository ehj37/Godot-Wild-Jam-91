extends HollowState

const DEBLOB_IMPULSE_MAGNITUDE: float = 800.0

@onready var blob_packed_scene: PackedScene = preload("res://scenes/blob/blob.tscn")


func update(_delta: float) -> void:
	if !hollow.animation_player.is_playing():
		var blob: Blob = blob_packed_scene.instantiate()
		blob.initial_state_name = "Idle"
		LevelManager.current_level.add_child(blob)
		blob.global_position = hollow.deblob_cavity.global_position

		var deblob_direction: Vector2
		if hollow.sprite.flip_h:
			deblob_direction = Vector2(-1, -1).normalized()
		else:
			deblob_direction = Vector2(1, -1).normalized()

		blob.sprite.flip_h = deblob_direction.x < 0
		blob.apply_central_impulse(deblob_direction * DEBLOB_IMPULSE_MAGNITUDE)

		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	hollow.animation_player.play("deblob")
	SoundEffectManager.play_effect_at(_get_deblob_sound_effect_config(), hollow.global_position)
	TransferModeManager.disable_transfer_mode()


func exit() -> void:
	hollow.player_controlled = false
	hollow.sprite_blob.visible = false
	TransferModeManager.enable_transfer_mode()


func _get_deblob_sound_effect_config() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_deblob.tres")
