extends HollowState

const STEP_IMPULSE_MAGNITUDE: float = 600.0


func update(_delta: float) -> void:
	if !hollow.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")

	if not hollow.animation_player.is_playing():
		state_machine.transition_to("Idle")

	if hollow.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
			return


func enter(_data: Dictionary = {}) -> void:
	hollow.animation_player.play("step_right")

	var step_direction: Vector2
	if hollow.player_controlled:
		var move_input: Hollow.MoveInput = hollow.get_move_input()
		match move_input:
			Hollow.MoveInput.LEFT:
				step_direction = Vector2.LEFT
			Hollow.MoveInput.RIGHT:
				step_direction = Vector2.RIGHT
	else:
		var not_going_off_ledge: bool = hollow.ledge_detector.has_overlapping_bodies()
		var not_going_into_obstacle: bool = not hollow.obstacle_detector.has_overlapping_bodies()
		if not_going_off_ledge && not_going_into_obstacle:
			# It's probably weird that I'm using the sprite flip_h to track the
			# direction the Hollow is going.
			if hollow.sprite.flip_h:
				step_direction = Vector2.LEFT
			else:
				step_direction = Vector2.RIGHT
		else:
			if hollow.sprite.flip_h:
				step_direction = Vector2.RIGHT
			else:
				step_direction = Vector2.LEFT

	if step_direction.x < 0:
		hollow.ground_detector.position.x = -abs(hollow.ground_detector.position.x)
		hollow.obstacle_detector.position.x = -abs(hollow.obstacle_detector.position.x)
		hollow.deblob_cavity.position.x = -abs(hollow.deblob_cavity.position.x)
	else:
		hollow.ground_detector.position.x = abs(hollow.ground_detector.position.x)
		hollow.obstacle_detector.position.x = abs(hollow.obstacle_detector.position.x)
		hollow.deblob_cavity.position.x = abs(hollow.deblob_cavity.position.x)

	hollow.sprite.flip_h = step_direction.x < 0
	hollow.apply_central_impulse(step_direction * STEP_IMPULSE_MAGNITUDE)
	hollow.step_cooldown_timer.start()
