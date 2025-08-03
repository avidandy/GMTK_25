extends Node2D

@export var damage_amount: int = 20 # Damage this projectile deals

@onready var sprite: =$AnimationPlayer/Sprite2D

func _ready() -> void:
	sprite.scale = Vector2(0, 0)
	call_deferred("aoespell")

func aoespell():
	$AnimationPlayer.play("firestorm")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
