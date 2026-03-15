extends HollowState


func update(_delta: float) -> void:
	if not hollow.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	if hollow.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
			return

	if hollow.step_cooldown_timer.is_stopped():
		if hollow.player_controlled:
			var move_input: Hollow.MoveInput = hollow.get_move_input()
			if move_input != -1:
				state_machine.transition_to("Step")
		else:
			state_machine.transition_to("Step")


func enter(_data: Dictionary = {}) -> void:
	hollow.animation_player.play("idle_right")
