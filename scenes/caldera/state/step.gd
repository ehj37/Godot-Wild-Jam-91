extends CalderaState

const STEP_TIME: float = 0.3
const STEP_IMPULSE_MAGNITUDE: float = 150.0
const MAX_COMBO_NUM: int = 2

var _current_combo_num: int = 0
var _direction: Vector2


func enter(data: Dictionary = {}) -> void:
	_current_combo_num = data.get("combo_num", 0)

	caldera.animation_player.play("step")
	SoundEffectManager.play_effect_at(_get_step_sound_effect_config(), caldera.global_position)
	if caldera.player_controlled:
		var move_input: MoveInputController.MoveInput = MoveInputController.get_move_input()
		match move_input:
			MoveInputController.MoveInput.LEFT:
				_direction = Vector2.LEFT
			MoveInputController.MoveInput.RIGHT:
				_direction = Vector2.RIGHT
			-1:
				push_warning("Not expected to be in player controlled move state w/ no move input")
	else:
		# Attempt to keep going in current direction, turn otherwise.
		match _direction:
			Vector2.LEFT:
				if (
					!caldera.ledge_detector_left.has_overlapping_bodies()
					|| caldera.obstacle_detector_left.has_overlapping_bodies()
				):
					_direction = Vector2.RIGHT
			Vector2.RIGHT:
				if (
					!caldera.ledge_detector_right.has_overlapping_bodies()
					|| caldera.obstacle_detector_right.has_overlapping_bodies()
				):
					_direction = Vector2.LEFT

	caldera.apply_central_impulse(_direction * STEP_IMPULSE_MAGNITUDE)

	caldera.sprite.flip_h = _direction == Vector2.LEFT
	caldera.sprite_blob.flip_h = caldera.sprite.flip_h

	get_tree().create_timer(STEP_TIME).timeout.connect(_on_step_timer_timeout)


func _ready() -> void:
	super()

	await owner.ready

	# Pick a random initial direction
	_direction = [Vector2.RIGHT, Vector2.LEFT].pick_random()
	caldera.sprite.flip_h = _direction == Vector2.LEFT
	caldera.sprite_blob.flip_h = _direction == Vector2.RIGHT


func _get_step_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/caldera/sound_effects/caldera_step.tres")


func _on_step_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	if !caldera.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	var should_combo: bool = false
	if _current_combo_num < MAX_COMBO_NUM:
		if caldera.player_controlled:
			var move_input: MoveInputController.MoveInput = MoveInputController.get_move_input()
			if move_input != -1:
				should_combo = true
		else:
			should_combo = true

	if should_combo:
		state_machine.transition_to("Step", {"combo_num": _current_combo_num + 1})
	else:
		caldera.step_cooldown_timer.start()
		state_machine.transition_to("Idle")
