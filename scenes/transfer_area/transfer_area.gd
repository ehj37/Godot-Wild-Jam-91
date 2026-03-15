@tool

class_name TransferArea

extends Area2D

signal focused_area_changed(old_focused_area: TransferArea, new_focused_area: TransferArea)

const OUTLINE_COLOR: Color = Color.RED
const FILL_COLOR: Color = Color(Color.RED, 0.5)

@export var radius: int:
	set(new_value):
		radius = new_value
		var collision_shape: CollisionShape2D = $CollisionShape2D
		var circle_shape: CircleShape2D = collision_shape.shape
		circle_shape.radius = radius

var _transfer_areas: Array[TransferArea] = []
var _focused_area: TransferArea

@onready var focused_indicator: AnimatedSprite2D = $FocusedIndicator


func get_focused_area() -> TransferArea:
	return _focused_area


func cycle_focused_area() -> void:
	if _focused_area == null || _transfer_areas.size() == 1:
		return

	var focused_area_i: int = _transfer_areas.find(_focused_area)
	var old_focused_area: TransferArea = _focused_area
	var new_focused_area_i: int = (focused_area_i + 1) % _transfer_areas.size()
	var new_focused_area: TransferArea = _transfer_areas[new_focused_area_i]
	_focused_area = new_focused_area

	focused_area_changed.emit(old_focused_area, new_focused_area)


func show_focused_indicator() -> void:
	focused_indicator.visible = true


func hide_focused_indicator() -> void:
	focused_indicator.visible = false


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, FILL_COLOR, true)
	draw_circle(Vector2.ZERO, radius, OUTLINE_COLOR, false)


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	visible = false
	TransferModeManager.transfer_mode_entered.connect(func() -> void: visible = true)
	TransferModeManager.transfer_mode_exited.connect(func() -> void: visible = false)


func _on_area_entered(area: TransferArea) -> void:
	_transfer_areas.append(area)
	if _focused_area == null:
		_focused_area = area
		focused_area_changed.emit(null, area)


func _on_area_exited(area: TransferArea) -> void:
	if area == _focused_area:
		if _transfer_areas.size() > 1:
			cycle_focused_area()
		else:
			_focused_area = null
			focused_area_changed.emit(area, null)

	_transfer_areas.erase(area)
