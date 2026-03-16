extends HopperState


func update(_delta: float) -> void:
	if !hopper.ground_detector.has_overlapping_bodies():
		state_machine.transition_to("Fall")
		return

	if !hopper.animation_player.is_playing():
		hopper.player_controlled = false
		hopper.spawn_blob()

		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	hopper.animation_player.play("deblob")
	TransferModeManager.disable_transfer_mode()


func exit() -> void:
	TransferModeManager.enable_transfer_mode()
