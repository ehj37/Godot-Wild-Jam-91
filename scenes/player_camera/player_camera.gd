extends Camera2D

const VIEWPORT_WIDTH: float = 320.0
const VIEWPORT_HEIGHT: float = 180.0

@export var tracking_subject: Node2D


func _physics_process(_delta: float) -> void:
	# Scuffed way of handling the blob being freed before the new tracking
	# subject gets set.
	if !is_instance_valid(tracking_subject):
		return

	var screen_coords: Vector2i = ScreenCoordsHelper.get_screen_coords(
		tracking_subject.global_position
	)
	global_position = ScreenCoordsHelper.get_screen_center_global_position(screen_coords)


func _ready() -> void:
	TransferManager.player_transferred.connect(
		func(new_player: Node2D) -> void: tracking_subject = new_player
	)
