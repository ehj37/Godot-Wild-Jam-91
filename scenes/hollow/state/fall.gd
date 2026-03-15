extends HollowState


func update(_delta: float) -> void:
	if hollow.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Idle")
		return

	if hollow.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
