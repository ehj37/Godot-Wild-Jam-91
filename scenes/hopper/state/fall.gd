extends HopperState

const FALL_DURATION_FOR_DEATH: float = 0.75

var _fall_duration: float = 0.0


func update(delta: float) -> void:
	_fall_duration += delta

	if hopper.ground_detector.has_overlapping_bodies():
		if _fall_duration >= FALL_DURATION_FOR_DEATH:
			state_machine.transition_to("Death")
		else:
			state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	_fall_duration = 0.0
