class_name Hopper

extends RigidBody2D

const BLOB_EJECTION_IMPULSE_MAGNITUDE: float = 500.0

var player_controlled: bool = false

@onready var blob_packed_scene: PackedScene = preload("res://scenes/blob/blob.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var transfer_area: TransferArea = $TransferArea
@onready var ground_detector: Area2D = $GroundDetector
@onready var hop_cooldown_timer: Timer = $HopCooldownTimer
@onready var _state_machine: StateMachine = $StateMachine


func spawn_blob() -> void:
	player_controlled = false

	var blob: Blob = blob_packed_scene.instantiate()
	blob.global_position = global_position + Vector2(0, -12)
	blob.initial_state_name = "Airborne"
	LevelManager.add_child(blob)
	blob.apply_central_impulse(Vector2.UP * BLOB_EJECTION_IMPULSE_MAGNITUDE)


func _on_transfer_area_transfer_requested() -> void:
	_state_machine.transition_to("Blob")


func _on_transfer_area_transfer_away_requested() -> void:
	player_controlled = false
