class_name FinalEffigy

extends StaticBody2D

signal game_end_text_ready

const EVICTED_BLOB_SPAWN_DELAY: float = 2.0
const POST_CLAIM_TIME_TO_EVICT: float = 1.5
const SPAWN_IMPULSE_MAGNITUDE: float = 800.0
const POST_SPAWN_DURATION_UNTIL_GAME_END_TEXT: float = 3.5

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("idle")


func _on_transfer_area_transfer_requested() -> void:
	animation_player.play("rehome")
	SoundEffectManager.play_effect(_get_blob_sound_effect_config())

	await animation_player.animation_finished

	await get_tree().create_timer(POST_CLAIM_TIME_TO_EVICT).timeout

	SoundEffectManager.play_effect(_get_deblob_sound_effect())

	var evicted_blob: EvictedBlob = _get_evicted_blob_packed_scene().instantiate()
	LevelManager.current_level.add_child(evicted_blob)

	evicted_blob.global_position = self.global_position + Vector2(0, -52)
	evicted_blob.apply_central_impulse(Vector2.UP * SPAWN_IMPULSE_MAGNITUDE)

	await get_tree().create_timer(POST_SPAWN_DURATION_UNTIL_GAME_END_TEXT).timeout

	game_end_text_ready.emit()


func _get_evicted_blob_packed_scene() -> PackedScene:
	return load("res://scenes/evicted_blob/evicted_blob.tscn")


func _get_blob_sound_effect_config() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_blob.tres")


func _get_effigy_claimed_sound_effect() -> SoundEffectConfig:
	return load("res://scenes/final_effigy/sound_effects/final_effigy_claimed.tres")


func _get_deblob_sound_effect() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/player_deblob.tres")


func _play_effigy_claimed_sound_effect() -> void:
	SoundEffectManager.play_effect(_get_effigy_claimed_sound_effect())
