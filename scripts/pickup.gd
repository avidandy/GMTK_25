extends Area2D

@export var level: FireballAbility

func _on_body_entered(body):
	level.p_level += 1
	print(level.p_level)
