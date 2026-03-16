extends Node

signal player_transferred(player: Node2D)

var player: Node2D
var player_transfer_area: TransferArea
var _tracked_areas: Array[TransferArea]
var _in_transfer_mode: bool = false


func transfer(new_player: Node2D, new_player_transfer_area: TransferArea) -> void:
	var old_transfer_area: TransferArea = player_transfer_area
	if old_transfer_area != null:
		old_transfer_area.transfer_areas_changed.disconnect(_on_transfer_areas_changed)

	new_player_transfer_area.transfer_areas_changed.connect(_on_transfer_areas_changed)

	player_transfer_area = new_player_transfer_area
	player = new_player

	_on_transfer_areas_changed()

	player_transferred.emit(new_player)


func _on_transfer_areas_changed() -> void:
	var connected_areas: Array[TransferArea]
	var focused_area: TransferArea

	if player_transfer_area:
		connected_areas = player_transfer_area.connected_transfer_areas
		focused_area = player_transfer_area.focused_area

	var untracked_areas: Array[TransferArea] = connected_areas.filter(
		func(ta: TransferArea) -> bool: return not _tracked_areas.has(ta)
	)
	var areas_to_stop_tracking: Array[TransferArea] = _tracked_areas.filter(
		func(ta: TransferArea) -> bool: return not connected_areas.has(ta)
	)
	var tracked_areas_to_reasses: Array[TransferArea] = _tracked_areas.filter(
		func(ta: TransferArea) -> bool: return not untracked_areas.has(ta)
	)

	for area: TransferArea in untracked_areas + tracked_areas_to_reasses:
		if area == focused_area:
			area.show_focused_indicator()
		else:
			area.show_unfocused_indicator()

	for area_to_stop_tracking: TransferArea in areas_to_stop_tracking:
		area_to_stop_tracking.hide_indicators()

	_tracked_areas = connected_areas.duplicate()


func _process(_delta: float) -> void:
	if !_in_transfer_mode:
		return

	if Input.is_action_just_pressed("cycle_focused_transfer_area"):
		player_transfer_area.cycle_focused_area()

	if Input.is_action_just_pressed("transfer"):
		var focused_area: TransferArea = player_transfer_area.focused_area
		_on_transfer_areas_changed()
		if focused_area != null:
			player_transfer_area.on_transfer_away()
			focused_area.on_transfer()
			# Trusting that the entities that disable transfer mode will re-enable it
			TransferModeManager.disable_transfer_mode()


func _ready() -> void:
	TransferModeManager.transfer_mode_entered.connect(func() -> void: _in_transfer_mode = true)
	TransferModeManager.transfer_mode_exited.connect(func() -> void: _in_transfer_mode = false)
