extends BlobState

const TIME_FOR_SPLAT: float = 0.5
const FALL_ANIMATION_SPEED_THRESHOLD: float = 100.0

var _airborne_time: float = 0.0
var _fall_animation_played: bool = false


func update(delta: float) -> void:
	_airborne_time += delta

	if blob.is_grounded():
		if _airborne_time >= TIME_FOR_SPLAT:
			state_machine.transition_to("Splat")
			return

		var move_input: Blob.MoveInput = blob.get_move_input()
		if move_input == -1:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")

		return

	if blob.linear_velocity.y > FALL_ANIMATION_SPEED_THRESHOLD && !_fall_animation_played:
		blob.animation_player.stop()
		blob.animation_player.play("fall")
		_fall_animation_played = true


func enter(_data: Dictionary = {}) -> void:
	_fall_animation_played = false
	_airborne_time = 0.0
