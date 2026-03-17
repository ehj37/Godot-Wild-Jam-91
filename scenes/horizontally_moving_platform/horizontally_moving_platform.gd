@tool

extends Node2D

const MOVE_SPEED: float = 0.5
const WAIT_TIME: float = 2.0

@export var max_distance: float:
	set(new_value):
		($Path2D as Path2D).curve.set_point_position(1, Vector2(new_value, 0))
		max_distance = new_value

var _moving_right: bool = true
var _waiting: bool = false

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D


func _physics_process(_delta: float) -> void:
	if _moving_right:
		path_follow.progress += MOVE_SPEED
	else:
		path_follow.progress -= MOVE_SPEED

	if _waiting:
		return

	if path_follow.progress_ratio == 0 || path_follow.progress_ratio == 1:
		_waiting = true
		get_tree().create_timer(WAIT_TIME).timeout.connect(
			func() -> void: _waiting = false ; _moving_right = !_moving_right
		)
