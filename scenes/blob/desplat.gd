extends BlobState


func update(_delta: float) -> void:
	if !blob.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	blob.animation_player.play("desplat_right")
