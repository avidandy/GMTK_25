extends Node2D

@export var speed := 300.0
@export var direction := Vector2.RIGHT

func _process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta
