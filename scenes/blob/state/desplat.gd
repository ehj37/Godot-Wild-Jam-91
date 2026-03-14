extends BlobState

@onready var sound_effect_config_desplat: SoundEffectConfig = preload(
	"res://scenes/blob/sound_effects/blob_desplat.tres"
)


func update(_delta: float) -> void:
	if !blob.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	blob.animation_player.play("desplat_right")
	SoundEffectManager.play_effect_at(sound_effect_config_desplat, blob.global_position)
