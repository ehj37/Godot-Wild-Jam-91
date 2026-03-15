extends Node

var player_transfer_area: TransferArea
var _in_transfer_mode: bool = false


func set_player_transfer_area(new_player_transfer_area: TransferArea) -> void:
	if player_transfer_area != null:
		player_transfer_area.focused_area_changed.disconnect(_on_focused_area_changed)

	player_transfer_area = new_player_transfer_area
	player_transfer_area.focused_area_changed.connect(_on_focused_area_changed)


func _on_focused_area_changed(
	old_focused_area: TransferArea, new_focused_area: TransferArea
) -> void:
	if old_focused_area != null:
		old_focused_area.hide_focused_indicator()

	if new_focused_area != null:
		new_focused_area.show_focused_indicator()


func _process(_delta: float) -> void:
	if !_in_transfer_mode:
		return

	if Input.is_action_just_pressed("cycle_focused_transfer_area"):
		player_transfer_area.cycle_focused_area()

	if Input.is_action_just_pressed("transfer"):
		var focused_area: TransferArea = player_transfer_area.get_focused_area()
		if focused_area != null:
			push_warning("TODO: Transfer logic")


func _ready() -> void:
	TransferModeManager.transfer_mode_entered.connect(func() -> void: _in_transfer_mode = true)
	TransferModeManager.transfer_mode_exited.connect(func() -> void: _in_transfer_mode = false)
