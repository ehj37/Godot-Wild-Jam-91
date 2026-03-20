extends CanvasLayer

signal transfer_mode_entered
signal transfer_mode_exited

const TRANSFER_MODE_TIME_SCALE: float = 0.3

var _in_transfer_mode: bool = false
var _transfer_mode_disabled: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var instructions_panel: Panel = $InstructionsPanel


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
	animation_player.play("show", -1, -1.0, true)
	instructions_panel.visible = false
	SoundEffectManager.play_effect(_get_transfer_mode_exit_sound_effect_config())
	_in_transfer_mode = false
	transfer_mode_exited.emit()


func _enter_transfer_mode() -> void:
	animation_player.play("show", -1, 1.0)
	instructions_panel.visible = true
	SoundEffectManager.play_effect(_get_transfer_mode_enter_sound_effect_config())
	_in_transfer_mode = true
	transfer_mode_entered.emit()


func _get_transfer_mode_enter_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/transfer_mode_manager/sound_effects/transfer_mode_enter.tres")


func _get_transfer_mode_exit_sound_effect_config() -> SoundEffectConfig:
	return load("res://scenes/transfer_mode_manager/sound_effects/transfer_mode_exit.tres")
