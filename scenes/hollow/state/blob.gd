extends HollowState


func update(_delta: float) -> void:
	if not hollow.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	hollow.animation_player.play("blob")


func exit() -> void:
	TransferManager.transfer(hollow, hollow.transfer_area)
	TransferModeManager.enable_transfer_mode()
	hollow.player_controlled = true
