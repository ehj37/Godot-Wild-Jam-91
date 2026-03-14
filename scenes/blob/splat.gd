extends BlobState


func update(_delta: float) -> void:
	if !blob.animation_player.is_playing():
		var move_input: Blob.MoveInput = blob.get_move_input()
		if move_input != -1:
			state_machine.transition_to("Desplat")


func enter(_data: Dictionary = {}) -> void:
	blob.animation_player.play("splat_right")
