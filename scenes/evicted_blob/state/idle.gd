extends EvictedBlobState


func update(_delta: float) -> void:
	if evicted_blob.hop_timer.is_stopped():
		state_machine.transition_to("Hop")


func enter(_data: Dictionary = {}) -> void:
	evicted_blob.animation_player.play("idle")
