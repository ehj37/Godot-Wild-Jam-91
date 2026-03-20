extends BlobState

const DAMAGE_COOLDOWN_DURATION: float = 0.6
const SPAWN_IMPULSE_MAGNITUDE: float = 800.0

var _hp: int = 2
var _damage_cooldown: bool = false


# If not on cooldown, further damage the statue on any key press/mouse click
func handle_input(event: InputEvent) -> void:
	if _damage_cooldown || MainMenu.visible == true:
		return

	if not event is InputEventKey and not event is InputEventMouseButton:
		return

	if _hp > 0:
		_hp -= 1
		blob.sprite_statue.region_rect.position.x += 32
		SoundEffectManager.play_effect_at(_get_damage_sound_effect(), blob.global_position)
		_spawn_damage_particles()

		_damage_cooldown = true
		get_tree().create_timer(DAMAGE_COOLDOWN_DURATION).timeout.connect(
			func() -> void: _damage_cooldown = false
		)
	else:
		state_machine.transition_to("Airborne", {"animation": "jump_up"})


func enter(_data: Dictionary = {}) -> void:
	blob.sprite.visible = false
	blob.sprite_statue.visible = true
	blob.freeze = true


func exit() -> void:
	blob.freeze = false
	# Give the appearance that the blob is spawning from the center of the statue
	blob.position.y -= 16.0

	var lizard_statue_fragments: GPUParticles2D = _get_lizard_statue_fragments()
	lizard_statue_fragments.global_position = blob.global_position
	lizard_statue_fragments.emitting = true
	LevelManager.current_level.add_child(lizard_statue_fragments)
	lizard_statue_fragments.finished.connect(lizard_statue_fragments.queue_free)

	_spawn_damage_particles()

	blob.sprite_statue.visible = false
	blob.sprite.visible = true
	blob.animation_player.play("jump_up")
	SoundEffectManager.play_effect_at(_get_emerge_sound_effect(), blob.global_position)
	blob.apply_central_impulse(Vector2.UP * SPAWN_IMPULSE_MAGNITUDE)


func _get_damage_particles() -> GPUParticles2D:
	var packed_scene: PackedScene = load("res://scenes/blob/lizard_statue_damage_particles.tscn")
	return packed_scene.instantiate()


func _spawn_damage_particles() -> void:
	var damage_particles: GPUParticles2D = _get_damage_particles()
	damage_particles.global_position = blob.global_position + Vector2(0, -10)
	damage_particles.emitting = true
	LevelManager.current_level.add_child(damage_particles)
	damage_particles.finished.connect(damage_particles.queue_free)


func _get_lizard_statue_fragments() -> GPUParticles2D:
	var packed_scene: PackedScene = load(
		"res://scenes/blob/lizard_statue_fragments/lizard_statue_fragments.tscn"
	)
	return packed_scene.instantiate()


func _get_damage_sound_effect() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/statue_damage.tres")


func _get_emerge_sound_effect() -> SoundEffectConfig:
	return load("res://scenes/blob/sound_effects/blob_emerge.tres")
