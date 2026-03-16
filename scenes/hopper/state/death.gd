extends HopperState

const BLOB_DEATH_EJECTION_IMPULSE_MAGNITUDE: float = 500.0


func update(_delta: float) -> void:
	if !hopper.animation_player.is_playing():
		hopper.transfer_area.queue_free()
		hopper.process_mode = Node.PROCESS_MODE_DISABLED


func enter(_data: Dictionary = {}) -> void:
	hopper.animation_player.play("death")
	hopper.spawn_blob()
