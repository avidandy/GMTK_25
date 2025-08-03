extends Node2D

@export var level: FireballAbility
@export var pickup_sound = "res://assets/sounds/pickup.ogg"

func _on_body_entered(body):
	level.p_level += 1
	AudioController.play_sound(pickup_sound)
	queue_free()
