class_name StateMachine

extends Node

signal state_transitioned(state_name: String)

@export var initial_state_name: String
@export var initial_state_data: Dictionary

var current_state: State
var _states: Array[State] = []
var _initial_state: State


func transition_to(new_state_name: String, data: Dictionary = {}) -> void:
	var new_state_i: int = _states.find_custom(
		func(s: State) -> bool: return s.name == new_state_name
	)
	if new_state_i == -1:
		push_warning("Could not transition to state " + new_state_name + " for " + str(owner))
		return

	current_state.exit()
	var new_state: State = _states[new_state_i]
	current_state = new_state
	state_transitioned.emit(new_state.name)
	new_state.enter(data)


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _process(delta: float) -> void:
	current_state.update(delta)


func _ready() -> void:
	await owner.ready

	for child: State in get_children():
		_states.append(child)
		child.state_machine = self
		if child.name == initial_state_name:
			_initial_state = child

	if _initial_state == null:
		current_state = _states[0]
		push_warning("Initial state not found for " + str(owner) + " defaulting to first state.")
	else:
		current_state = _initial_state

	current_state.enter(initial_state_data)
