extends BlobState


func physics_update(_delta: float) -> void:
	if not blob.is_grounded():
		state_machine.transition_to("Airborne")
		return

	if Input.is_action_pressed("jump") and blob.jump_cooldown_timer.is_stopped():
		state_machine.transition_to("Jump")
		return

	if MoveInputController.get_move_input() != -1:
		state_machine.transition_to("Move")


func enter(_data: Dictionary = {}) -> void:
	blob.sprite.visible = true
	blob.sprite_statue.visible = false
	blob.animation_player.play("idle")
