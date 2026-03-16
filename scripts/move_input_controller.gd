extends Node

enum MoveInput { LEFT, RIGHT }

var initial_state_name: String
var _pressed_move_inputs: Array[MoveInput]


# Returns -1 if no move inputs are pressed
func get_move_input() -> MoveInput:
	if _pressed_move_inputs.size() == 0:
		@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
		return -1

	return _pressed_move_inputs.back()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		if !_pressed_move_inputs.has(MoveInput.LEFT):
			_pressed_move_inputs.append(MoveInput.LEFT)
	else:
		_pressed_move_inputs.erase(MoveInput.LEFT)

	if Input.is_action_pressed("move_right"):
		if !_pressed_move_inputs.has(MoveInput.RIGHT):
			_pressed_move_inputs.append(MoveInput.RIGHT)
	else:
		_pressed_move_inputs.erase(MoveInput.RIGHT)
