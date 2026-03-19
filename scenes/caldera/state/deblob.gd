extends CalderaState

const DEBLOB_IMPULSE_MAGNITUDE: float = 1200.0

@onready var blob_packed_scene: PackedScene = preload("res://scenes/blob/blob.tscn")


func update(_delta: float) -> void:
	if !caldera.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	caldera.animation_player.play("deblob")
	SoundEffectManager.play_effect_at(_get_deblob_sound_effect_config(), caldera.global_position)
	TransferModeManager.disable_transfer_mode()


func exit() -> void:
	var blob: Blob = blob_packed_scene.instantiate()
	blob.global_position = caldera.global_position + Vector2(0, -16)
	blob.initial_state_name = "Airborne"
	blob.initial_state_data = {"animation": "jump_up"}
	blob.apply_central_impulse(Vector2.UP * DEBLOB_IMPULSE_MAGNITUDE)
	LevelManager.current_level.add_child(blob)

	caldera.player_controlled = false
	caldera.sprite_blob.visible = false
	TransferModeManager.enable_transfer_mode()


func _get_deblob_sound_effect_config() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_deblob.tres")
