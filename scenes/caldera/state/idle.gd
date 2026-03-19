extends CalderaState

const BASE_IDLE_TIME: float = 1.0
const IDLE_TIME_VARIANCE: float = 0.3

var _idle_time: float


func update(_delta: float) -> void:
	if !caldera.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	if caldera.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
			return

	if caldera.step_cooldown_timer.is_stopped():
		if caldera.player_controlled:
			if MoveInputController.get_move_input() != -1:
				state_machine.transition_to("Step")
		else:
			state_machine.transition_to("Step")


func enter(_data: Dictionary = {}) -> void:
	if caldera.player_controlled:
		_idle_time = BASE_IDLE_TIME
	else:
		_idle_time = BASE_IDLE_TIME + randf_range(-IDLE_TIME_VARIANCE, IDLE_TIME_VARIANCE)

	get_tree().create_timer(_idle_time).timeout.connect(_on_idle_timer_timeout)

	caldera.animation_player.play("idle")


func _on_idle_timer_timeout() -> void:
	if state_machine.current_state != self:
		return
