extends CalderaState


func update(_delta: float) -> void:
	if caldera.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Land")
