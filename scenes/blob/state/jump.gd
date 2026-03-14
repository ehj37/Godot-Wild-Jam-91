extends BlobState

const JUMP_IMPULSE_MAGNITUDE: float = 200.0


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
	state_machine.transition_to("Airborne")
	blob.jump_cooldown_timer.start()
