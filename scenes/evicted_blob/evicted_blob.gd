class_name EvictedBlob

extends RigidBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ground_detector: Area2D = $GroundDetector
@onready var hop_timer: Timer = $HopTimer


func _get_splat_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_splat.tres")


func _get_blob_jump_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_jump.tres")
