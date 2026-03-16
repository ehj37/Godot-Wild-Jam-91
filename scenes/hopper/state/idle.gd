extends HopperState

const NON_PLAYER_CONTROLLED_HOP_PROBABILITY: float = 0.3


func update(_delta: float) -> void:
	if !hopper.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	if hopper.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
			return

	if hopper.player_controlled:
		var move_input: MoveInputController.MoveInput = MoveInputController.get_move_input()
		if move_input != -1:
			hopper.sprite.flip_h = move_input == MoveInputController.MoveInput.LEFT

		if Input.is_action_pressed("jump") && hopper.hop_cooldown_timer.is_stopped():
			state_machine.transition_to("Hop")
	else:
		if hopper.hop_cooldown_timer.is_stopped():
			# If not player controlled, only hop some percentage of the time.
			if randf() < NON_PLAYER_CONTROLLED_HOP_PROBABILITY:
				state_machine.transition_to("Hop")
			else:
				hopper.hop_cooldown_timer.start()
				state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	hopper.animation_player.play("idle")
