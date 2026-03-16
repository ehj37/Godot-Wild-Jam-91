@tool

class_name TransferArea

extends Area2D

signal transfer_areas_changed
signal transfer_requested
signal transfer_away_requested

@export var radius: int:
	set(new_value):
		radius = new_value
		var collision_shape: CollisionShape2D = $CollisionShape2D
		var circle_shape: CircleShape2D = collision_shape.shape
		circle_shape.radius = radius

var connected_transfer_areas: Array[TransferArea] = []
var focused_area: TransferArea

@onready var focused_indicator: AnimatedSprite2D = $FocusedIndicator
@onready var unfocused_indicator: Sprite2D = $UnfocusedIndicator


func on_transfer() -> void:
	transfer_requested.emit()


func on_transfer_away() -> void:
	transfer_away_requested.emit()


func get_unfocused_areas() -> Array[TransferArea]:
	return connected_transfer_areas.filter(
		func(ta: TransferArea) -> bool: return ta != focused_area
	)


func cycle_focused_area() -> void:
	if focused_area == null || connected_transfer_areas.size() == 1:
		return

	var focused_area_i: int = connected_transfer_areas.find(focused_area)
	var new_focused_area_i: int = (focused_area_i + 1) % connected_transfer_areas.size()
	var new_focused_area: TransferArea = connected_transfer_areas[new_focused_area_i]
	focused_area = new_focused_area

	transfer_areas_changed.emit()


func show_focused_indicator() -> void:
	focused_indicator.visible = true
	unfocused_indicator.visible = false


func show_unfocused_indicator() -> void:
	focused_indicator.visible = false
	unfocused_indicator.visible = true


func hide_indicators() -> void:
	focused_indicator.visible = false
	unfocused_indicator.visible = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	visible = false
	TransferModeManager.transfer_mode_entered.connect(func() -> void: visible = true)
	TransferModeManager.transfer_mode_exited.connect(func() -> void: visible = false)


func _on_area_entered(area: TransferArea) -> void:
	connected_transfer_areas.append(area)
	if focused_area == null:
		focused_area = area

	transfer_areas_changed.emit()


func _on_area_exited(area: TransferArea) -> void:
	if area == focused_area:
		if connected_transfer_areas.size() > 1:
			cycle_focused_area()
		else:
			focused_area = null

	connected_transfer_areas.erase(area)
	transfer_areas_changed.emit()
