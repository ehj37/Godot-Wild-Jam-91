extends BlobState

const DAMAGE_COOLDOWN_DURATION: float = 0.8
const SPAWN_IMPULSE_MAGNITUDE: float = 800.0

var _damaged: bool = false
var _damage_cooldown: bool = false


# If not on cooldown, further damage the statue on any key press/mouse click
func handle_input(event: InputEvent) -> void:
	if _damage_cooldown:
		return

	if not event is InputEventKey and not event is InputEventMouseButton:
		return

	if !_damaged:
		push_warning("TODO: Spawn some particles for statue damage.")
		blob.sprite_statue.region_rect.position.x += 32
		_damaged = true
		_damage_cooldown = true
		get_tree().create_timer(DAMAGE_COOLDOWN_DURATION).timeout.connect(
			func() -> void: _damage_cooldown = false
		)
	else:
		push_warning("TODO: Spawn some particles for statue destroy.")
		state_machine.transition_to("Airborne")


func enter(_data: Dictionary = {}) -> void:
	blob.sprite.visible = false
	blob.sprite_statue.visible = true
	blob.freeze = true


func exit() -> void:
	blob.freeze = false
	# Give the appearance that the blob is spawning from the center of the statue
	blob.position.y -= 16.0
	blob.sprite_statue.visible = false
	blob.sprite.visible = true
	blob.animation_player.play("jump_up")
	blob.apply_central_impulse(Vector2.UP * SPAWN_IMPULSE_MAGNITUDE)
