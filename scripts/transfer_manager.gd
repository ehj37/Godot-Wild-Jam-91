extends Node

signal player_transferred(player: Node2D)

var player: Node2D
var player_transfer_area: TransferArea
var _in_transfer_mode: bool = false


func transfer(new_player: Node2D, new_player_transfer_area: TransferArea) -> void:
	var old_transfer_area: TransferArea = player_transfer_area
	if old_transfer_area != null:
		old_transfer_area.focused_area_changed.disconnect(_on_focused_area_changed)
		var old_focused_area: TransferArea = old_transfer_area.get_focused_area()
		if old_focused_area != null:
			old_focused_area.hide_focused_indicator()

	new_player_transfer_area.focused_area_changed.connect(_on_focused_area_changed)
	var new_focused_area: TransferArea = new_player_transfer_area.get_focused_area()
	if new_focused_area != null:
		new_focused_area.show_focused_indicator()

	player_transfer_area = new_player_transfer_area
	player = new_player

	player_transferred.emit(new_player)


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
			player_transfer_area.on_transfer_away()
			focused_area.on_transfer()
			# Trusting that the entities that disable transfer mode will re-enable it
			TransferModeManager.disable_transfer_mode()


func _ready() -> void:
	TransferModeManager.transfer_mode_entered.connect(func() -> void: _in_transfer_mode = true)
	TransferModeManager.transfer_mode_exited.connect(func() -> void: _in_transfer_mode = false)
