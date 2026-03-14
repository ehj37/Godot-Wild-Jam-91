extends Camera2D

const VIEWPORT_WIDTH: float = 320.0
const VIEWPORT_HEIGHT: float = 180.0

@export var tracking_subject: Node2D


func _physics_process(_delta: float) -> void:
	var screen_coords: Vector2i = ScreenCoordsHelper.get_screen_coords(
		tracking_subject.global_position
	)
	global_position = ScreenCoordsHelper.get_screen_center_global_position(screen_coords)
