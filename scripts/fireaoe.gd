extends Node2D

@export var damage_amount: int = 1 # Damage this projectile deals

@onready var sprite: =$AnimationPlayer/Sprite2D

func _ready() -> void:
	sprite.scale = Vector2(0, 0)
	call_deferred("aoespell")

func _process(delta):
	sprite.rotation += 2.0 * delta
	#owner.get_parent().add_child(self)

func aoespell():
	$AnimationPlayer.play("firestorm")
