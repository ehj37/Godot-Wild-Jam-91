class_name Blob

extends RigidBody2D

enum MoveInput { LEFT, RIGHT }

var _pressed_move_inputs: Array[MoveInput]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var jump_cooldown_timer: Timer = $JumpCooldownTimer
@onready var _ground_detector: Area2D = $GroundDetector
@onready var _state_machine_label: Label = $StateMachineLabel


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


func is_grounded() -> bool:
	return _ground_detector.has_overlapping_bodies()


func _on_state_machine_state_transitioned(state_name: String) -> void:
	_state_machine_label.text = state_name
