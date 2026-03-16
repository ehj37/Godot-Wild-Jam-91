class_name Hollow

extends RigidBody2D

var player_controlled: bool = false

@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
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
