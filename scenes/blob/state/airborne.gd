extends BlobState

const TIME_FOR_SPLAT: float = 0.5

var _airborne_time: float = 0.0


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


func enter(_data: Dictionary = {}) -> void:
	_airborne_time = 0.0
