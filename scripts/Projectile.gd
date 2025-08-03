# scripts/Projectile.gd
extends Node2D

@export var speed := 500.0 # From your Projectile.gd
@export var direction := Vector2.RIGHT # From your Projectile.gd
@export var damage_amount: int = 1 # Damage this projectile deals

func _process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta
	position += direction * delta
	rotation = direction.angle()

# New function to handle collision with another body
func _on_Hitbox_body_entered(body: Node2D):
	# Check if the body that entered is an enemy
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage_amount)
		print("Projectile hit enemy! Dealt ", damage_amount, " damage.") # For debugging
		$AnimatedSprite2D.visible = false
		await $AudioStreamPlayer.finished
		queue_free() # Destroy the projectile after hitting an enemy
	# Optional: You might want to also destroy on hitting walls, etc.
