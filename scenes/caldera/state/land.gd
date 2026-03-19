extends CalderaState


func update(_delta: float) -> void:
	if !caldera.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	caldera.animation_player.play("land")
