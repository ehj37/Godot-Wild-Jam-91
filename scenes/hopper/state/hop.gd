extends HopperState

const FULL_CHARGE_TIME: float = 0.6
const BASE_CHARGE_MULT: float = 0.5
const MAX_HOP_IMPULSE_MAGNITUDE: float = 250.0

var _is_charging: bool = true
var _charge_time: float = 0.0


func update(delta: float) -> void:
	if !is_grounded():
		state_machine.transition_to("Fall")
		return

	if hopper.player_controlled:
		if Input.is_action_just_pressed("deblob"):
			state_machine.transition_to("Deblob")
			return

		if _is_charging:
			if Input.is_action_pressed("jump"):
				_charge_time = min(_charge_time + delta, FULL_CHARGE_TIME)
				if !hopper.hop_progress_bar.value == hopper.hop_progress_bar.max_value:
					hopper.hop_progress_bar.value = _charge_time / FULL_CHARGE_TIME
					if hopper.hop_progress_bar.value == hopper.hop_progress_bar.max_value:
						SoundEffectManager.play_effect_at(
							_get_hop_fully_charged_sound_effect_config(), hopper.global_position
						)
			else:
				_handle_jump()
			return

	if is_grounded():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Fall")


func enter(_data: Dictionary = {}) -> void:
	_is_charging = true
	_charge_time = 0.0
	hopper.hop_progress_bar.value = 0.0

	if !hopper.player_controlled:
		_handle_jump()
	else:
		hopper.animation_player.play("hop_charge")
		SoundEffectManager.play_effect_at(
			_get_hop_charge_sound_effect_config(), hopper.global_position
		)
		hopper.hop_progress_bar.show()


func exit() -> void:
	hopper.hop_cooldown_timer.start()
	hopper.hop_progress_bar.hide()


func is_grounded() -> bool:
	return hopper.ground_detector.has_overlapping_bodies()


func _handle_jump() -> void:
	_is_charging = false
	hopper.animation_player.play("hop")
	SoundEffectManager.play_effect_at(_get_hop_sound_effect_config(), hopper.global_position)
	var move_direction: Vector2
	var move_input: MoveInputController.MoveInput
	if hopper.player_controlled:
		move_input = MoveInputController.get_move_input()
	else:
		# Non-player-controlled Hopper randomly hops left or right.
		move_input = (
			[MoveInputController.MoveInput.LEFT, MoveInputController.MoveInput.RIGHT].pick_random()
		)

	match move_input:
		MoveInputController.MoveInput.LEFT:
			hopper.sprite.flip_h = true
			move_direction = Vector2(-0.5, -1).normalized()
		MoveInputController.MoveInput.RIGHT:
			hopper.sprite.flip_h = false
			move_direction = Vector2(0.5, -1).normalized()
		-1:
			move_direction = Vector2.UP

	hopper.sprite_blob.flip_h = hopper.sprite.flip_h
	var hop_impulse_mult: float = max(_charge_time / FULL_CHARGE_TIME, BASE_CHARGE_MULT)
	hopper.apply_central_impulse(move_direction * hop_impulse_mult * MAX_HOP_IMPULSE_MAGNITUDE)


func _get_hop_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/hopper/sound_effects/hopper_hop.tres")


func _get_hop_charge_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/hopper/sound_effects/hopper_hop_charge.tres")


func _get_hop_fully_charged_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/hopper/sound_effects/hopper_hop_fully_charged.tres")
