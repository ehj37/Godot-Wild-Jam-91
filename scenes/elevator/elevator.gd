@tool

extends Node2D

const MOVE_SPEED: float = 0.5
const WAIT_TIME: float = 2.0

@export var max_height: float:
	set(new_value):
		($Path2D as Path2D).curve.set_point_position(1, Vector2(0, -new_value))
		max_height = new_value

var _ascending: bool = true
var _waiting: bool = false

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D


func _physics_process(_delta: float) -> void:
	if _ascending:
		path_follow.progress += MOVE_SPEED
	else:
		path_follow.progress -= MOVE_SPEED

	if _waiting:
		return

	if path_follow.progress_ratio == 0 || path_follow.progress_ratio == 1:
		_waiting = true
		if !Engine.is_editor_hint():
			SoundEffectManager.play_effect_at(_get_click_sound_effect(), global_position)
		get_tree().create_timer(WAIT_TIME).timeout.connect(
			func() -> void: _waiting = false ; _ascending = !_ascending
		)


func _get_click_sound_effect() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/moving_platform_position_lock.tres")
