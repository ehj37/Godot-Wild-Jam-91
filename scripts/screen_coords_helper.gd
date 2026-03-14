class_name ScreenCoordsHelper

extends Node

const VIEWPORT_WIDTH: float = 320.0
const VIEWPORT_HEIGHT: float = 180.0


static func get_screen_coords(global_position: Vector2) -> Vector2i:
	var x_coord: int = floor(global_position.x / VIEWPORT_WIDTH)
	var y_coord: int = floor(global_position.y / VIEWPORT_HEIGHT)
	return Vector2(x_coord, y_coord)


static func get_screen_center_global_position(screen_coords: Vector2i) -> Vector2:
	var global_position_x: float = VIEWPORT_WIDTH * screen_coords.x + VIEWPORT_WIDTH / 2.0
	var global_position_y: float = VIEWPORT_HEIGHT * screen_coords.y + VIEWPORT_HEIGHT / 2.0
	return Vector2(global_position_x, global_position_y)
