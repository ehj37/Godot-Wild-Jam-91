@tool

extends Node2D

const MOVE_SPEED: float = 25.0
const WAIT_TIME: float = 2.0

@export var max_distance: float:
	set(new_value):
		($Path2D as Path2D).curve.set_point_position(1, Vector2(new_value, 0))
		max_distance = new_value

var _moving_right: bool = true
var _waiting: bool = false

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D


func _physics_process(delta: float) -> void:
	if _moving_right:
		path_follow.progress += MOVE_SPEED * delta
	else:
		path_follow.progress -= MOVE_SPEED * delta

	if _waiting:
		return

	if path_follow.progress_ratio == 0 || path_follow.progress_ratio == 1:
		_waiting = true
		if !Engine.is_editor_hint():
			SoundEffectManager.play_effect_at(_get_click_sound_effect(), global_position)
		get_tree().create_timer(WAIT_TIME).timeout.connect(
			func() -> void: _waiting = false ; _moving_right = !_moving_right
		)


func _get_click_sound_effect() -> SoundEffectConfig:
	return load("res://audio/shared_sound_effects/moving_platform_position_lock.tres")
