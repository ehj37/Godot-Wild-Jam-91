extends BlobState

@onready var sound_effect_config_splat: SoundEffectConfig = preload(
	"res://scenes/blob/sound_effects/blob_splat.tres"
)


func update(_delta: float) -> void:
	if !blob.animation_player.is_playing():
		var move_input: MoveInputController.MoveInput = MoveInputController.get_move_input()
		if move_input != -1:
			state_machine.transition_to("Desplat")


func enter(_data: Dictionary = {}) -> void:
	blob.animation_player.play("splat")
	SoundEffectManager.play_effect_at(sound_effect_config_splat, blob.global_position)
