extends HollowState

const BASE_IDLE_TIME: float = 1.1
const IDLE_TIME_VARIATION: float = 0.2


func update(_delta: float) -> void:
	if not hollow.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	if hollow.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
			return

	if hollow.player_controlled && hollow.step_cooldown_timer.is_stopped():
		var move_input: MoveInputController.MoveInput = MoveInputController.get_move_input()
		if move_input != -1:
			state_machine.transition_to("Step")


func enter(_data: Dictionary = {}) -> void:
	hollow.animation_player.play("idle_right")

	var idle_time: float = BASE_IDLE_TIME + randf_range(-IDLE_TIME_VARIATION, IDLE_TIME_VARIATION)
	get_tree().create_timer(idle_time).timeout.connect(_on_idle_timer_timeout)


func _on_idle_timer_timeout() -> void:
	if state_machine.current_state != self || hollow.player_controlled:
		return

	state_machine.transition_to("Step")
