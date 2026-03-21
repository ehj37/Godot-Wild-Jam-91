class_name FadeInLabel

extends Label

signal finished

@export var fade_in_time: float = 0.5

var _fade_in_called: bool = false


# GDFormat does not like variadic functions
func fade_in_one_arg(_arg: Node) -> void:
	fade_in()


func fade_in() -> void:
	if _fade_in_called:
		return

	var fade_in_tween: Tween = get_tree().create_tween()
	fade_in_tween.tween_property(self, "modulate:a", 1.0, fade_in_time)
	_fade_in_called = true

	await fade_in_tween.finished

	finished.emit()


func _ready() -> void:
	modulate.a = 0.0
