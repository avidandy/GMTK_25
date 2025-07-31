extends CharacterBody2D

@export var speed = 300
@onready var player = get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
