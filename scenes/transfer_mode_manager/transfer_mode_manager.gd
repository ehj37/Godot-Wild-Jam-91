extends CanvasLayer

signal transfer_mode_entered
signal transfer_mode_exited

const TRANSFER_MODE_TIME_SCALE: float = 0.3

var _in_transfer_mode: bool = false
var _transfer_mode_disabled: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func enable_transfer_mode() -> void:
	_transfer_mode_disabled = false


func disable_transfer_mode() -> void:
	_transfer_mode_disabled = true
	if _in_transfer_mode:
		_exit_transfer_mode()


func _process(_delta: float) -> void:
	if _transfer_mode_disabled:
		return

	if Input.is_action_just_pressed("toggle_transfer_mode"):
		if _in_transfer_mode:
			_exit_transfer_mode()
		else:
			_enter_transfer_mode()


func _exit_transfer_mode() -> void:
	animation_player.play("hide")
	Engine.time_scale = 1.0
	AudioServer.playback_speed_scale = 1.0
	_in_transfer_mode = false
	transfer_mode_exited.emit()


func _enter_transfer_mode() -> void:
	animation_player.play("show")
	Engine.time_scale = TRANSFER_MODE_TIME_SCALE
	AudioServer.playback_speed_scale = TRANSFER_MODE_TIME_SCALE
	_in_transfer_mode = true
	transfer_mode_entered.emit()
