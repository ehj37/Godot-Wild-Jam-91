class_name Blob

extends RigidBody2D

@warning_ignore("unused_signal")
signal statue_broken

var initial_state_name: String
var initial_state_data: Dictionary

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_statue: Sprite2D = $SpriteStatue
@onready var sprite: Sprite2D = $Sprite2D
@onready var jump_cooldown_timer: Timer = $JumpCooldownTimer
@onready var _state_machine: StateMachine = $StateMachine
@onready var _ground_detector: Area2D = $GroundDetector
@onready var _state_machine_label: Label = $StateMachineLabel
@onready var _transfer_area: TransferArea = $TransferArea


func _ready() -> void:
	TransferManager.transfer(self, _transfer_area)

	if initial_state_name != "":
		_state_machine.initial_state_name = initial_state_name
		_state_machine.initial_state_data = initial_state_data


func is_grounded() -> bool:
	return _ground_detector.has_overlapping_bodies()


func _on_state_machine_state_transitioned(state_name: String) -> void:
	_state_machine_label.text = state_name


func _on_transfer_area_transfer_away_requested() -> void:
	queue_free()
