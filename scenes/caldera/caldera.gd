class_name Caldera

extends RigidBody2D

var player_controlled: bool = false:
	set(new_value):
		player_controlled = new_value
		set_collision_layer_value(7, player_controlled)

@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_blob: Sprite2D = $SpriteBlob
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var transfer_area: TransferArea = $TransferArea
@onready var ground_detector: Area2D = $GroundDetector
@onready var ledge_detector_right: Area2D = $LedgeDetectorRight
@onready var ledge_detector_left: Area2D = $LedgeDetectorLeft
@onready var obstacle_detector_right: Area2D = $ObstacleDetectorRight
@onready var obstacle_detector_left: Area2D = $ObstacleDetectorLeft
@onready var step_cooldown_timer: Timer = $StepCooldownTimer
@onready var _state_machine: StateMachine = $StateMachine


func _on_transfer_area_transfer_away_requested() -> void:
	player_controlled = false
	sprite_blob.visible = false


func _on_transfer_area_transfer_requested() -> void:
	_state_machine.transition_to("Blob")
