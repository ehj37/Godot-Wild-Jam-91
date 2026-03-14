extends BlobState

const MOVE_FORCE_MAGNITUDE: float = 1520.0


func physics_update(_delta: float) -> void:
	if not blob.is_grounded():
		state_machine.transition_to("Airborne")
		return

	var move_input: Blob.MoveInput = blob.get_move_input()
	if move_input == -1:
		state_machine.transition_to("Idle")
		return

	var move_direction: Vector2
	match move_input:
		Blob.MoveInput.LEFT:
			blob.sprite.flip_h = true
			move_direction = Vector2.LEFT
		Blob.MoveInput.RIGHT:
			blob.sprite.flip_h = false
			move_direction = Vector2.RIGHT

	blob.apply_central_force(move_direction * MOVE_FORCE_MAGNITUDE)
	blob.animation_player.play("move_right")

	if Input.is_action_just_pressed("jump") and blob.jump_cooldown_timer.is_stopped():
		state_machine.transition_to("Jump")
