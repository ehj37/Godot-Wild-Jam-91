class_name Effigy

extends StaticBody2D

var player_controlled: bool = false:
	set(new_value):
		player_controlled = new_value
		set_collision_layer_value(7, player_controlled)

@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_blob: Sprite2D = $SpriteBlob
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var transfer_area: TransferArea = $TransferArea
@onready var _state_machine: StateMachine = $StateMachine


func _on_transfer_area_transfer_away_requested() -> void:
	sprite_blob.visible = false
	player_controlled = false


func _on_transfer_area_transfer_requested() -> void:
	_state_machine.transition_to("Blob")
