extends EffigyState


func enter(_data: Dictionary = {}) -> void:
	effigy.animation_player.play("idle")
