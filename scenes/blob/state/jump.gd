extends BlobState

const JUMP_IMPULSE_MAGNITUDE: float = 250.0

@onready var sound_effect_config_jump: SoundEffectConfig = preload(
	"res://scenes/blob/sound_effects/blob_jump.tres"
)


func enter(_data: Dictionary = {}) -> void:
	var impulse_direction: Vector2
	var move_input: Blob.MoveInput = blob.get_move_input()
	match move_input:
		Blob.MoveInput.LEFT:
			impulse_direction = Vector2(-1, -1).normalized()
		Blob.MoveInput.RIGHT:
			impulse_direction = Vector2(1, -1).normalized()
		-1:
			impulse_direction = Vector2.UP

	blob.apply_central_impulse(impulse_direction * JUMP_IMPULSE_MAGNITUDE)
	blob.animation_player.play("jump_right")
	SoundEffectManager.play_effect_at(sound_effect_config_jump, blob.global_position)
	state_machine.transition_to("Airborne")
	blob.jump_cooldown_timer.start()
