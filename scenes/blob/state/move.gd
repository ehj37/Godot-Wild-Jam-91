extends BlobState

const MOVE_FORCE_MAGNITUDE: float = 2100.0
const MOVE_LINEAR_DAMP: float = 10.0

@onready var _sound_effect_timer: Timer = $SoundEffectTimer


func physics_update(_delta: float) -> void:
	if not blob.is_grounded():
		state_machine.transition_to("Airborne")
		return

	var move_input: MoveInputController.MoveInput = MoveInputController.get_move_input()
	if move_input == -1:
		state_machine.transition_to("Idle")
		return

	var move_direction: Vector2
	match move_input:
		MoveInputController.MoveInput.LEFT:
			blob.sprite.flip_h = true
			move_direction = Vector2.LEFT
		MoveInputController.MoveInput.RIGHT:
			blob.sprite.flip_h = false
			move_direction = Vector2.RIGHT

	blob.apply_central_force(move_direction * MOVE_FORCE_MAGNITUDE)
	blob.animation_player.play("move_right")

	if Input.is_action_pressed("jump") and blob.jump_cooldown_timer.is_stopped():
		state_machine.transition_to("Jump")


func enter(_data: Dictionary = {}) -> void:
	blob.linear_damp = MOVE_LINEAR_DAMP
	_sound_effect_timer.start()


func exit() -> void:
	blob.linear_damp = 0.0
	_sound_effect_timer.stop()


func _get_crawl_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_crawl.tres")


func _on_sound_effect_timer_timeout() -> void:
	SoundEffectManager.play_effect(_get_crawl_sound_effect_config())
	_sound_effect_timer.start()
