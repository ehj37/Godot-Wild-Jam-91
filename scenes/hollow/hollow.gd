class_name Hollow

extends RigidBody2D

var player_controlled: bool = false:
	set(new_value):
		player_controlled = new_value
		set_collision_layer_value(7, player_controlled)

@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $SpriteHollow
@onready var sprite_blob: Sprite2D = $SpriteBlob
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var transfer_area: TransferArea = $TransferArea
@onready var step_cooldown_timer: Timer = $StepCooldownTimer
@onready var ground_detector: Area2D = $GroundDetector
@onready var ledge_detector: Area2D = $GroundDetector
@onready var obstacle_detector: Area2D = $ObstacleDetector
@onready var deblob_cavity: Marker2D = $DeblobCavity


func _on_transfer_area_transfer_requested() -> void:
	state_machine.transition_to("Blob")


func _on_transfer_area_transfer_away_requested() -> void:
	player_controlled = false
	sprite_blob.visible = false
