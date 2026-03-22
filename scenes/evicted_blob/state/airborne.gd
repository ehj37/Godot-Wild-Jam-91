extends EvictedBlobState

const TIME_FOR_SPLAT: float = 0.25
const FALL_ANIMATION_SPEED_THRESHOLD: float = 140.0

var _airborne_time: float = 0.0
var _fall_animation_played: bool = false


func update(delta: float) -> void:
	_airborne_time += delta

	if !_fall_animation_played && evicted_blob.linear_velocity.y > FALL_ANIMATION_SPEED_THRESHOLD:
		_fall_animation_played = true
		evicted_blob.animation_player.play("down")

	if evicted_blob.ground_detector.has_overlapping_bodies():
		if _airborne_time >= TIME_FOR_SPLAT:
			state_machine.transition_to("Splat")
		else:
			state_machine.transition_to("Idle")


func enter(data: Dictionary = {}) -> void:
	var animation: String = data.get("animation", "up")
	evicted_blob.animation_player.play(animation)
	_airborne_time = 0.0
