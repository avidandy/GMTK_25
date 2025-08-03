extends Node2D

@export var damage_amount: int = 1 # Damage this projectile deals

@onready var sprite: =$AnimatedSprite2D

var enimies: Array[CharacterBody2D] = []

func _ready() -> void:
	sprite.scale = Vector2(0, 0)
	call_deferred("aoespell")

func _process(delta):
	sprite.rotation += 2.0 * delta
	#owner.get_parent().add_child(self)

func aoespell():
	var target_scale = Vector2(5, 5)
	var duration = 2
	
	var tween = create_tween()
	tween.tween_property(sprite,"scale",target_scale, duration).set_trans(tween.TRANS_SINE).set_ease(tween.EASE_OUT)
	
	await  tween.finished
	await get_tree().create_timer(1.0).timeout
	
	var shrink_tween = create_tween()
	shrink_tween.tween_property(sprite,"scale",Vector2(0,0), duration).set_trans(tween.TRANS_SINE).set_ease(tween.EASE_OUT)
	

# New function to handle collision with another body
func _on_Hitbox_body_entered(body: Node2D):
	# Check if the body that entered is an enemy
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		enimies.append(body)
		#print("AOE hit enemy! Dealt ", damage_amount, " damage.") # For debugging
	# Optional: You might want to also destroy on hitting walls, etc.

# New function to handle collision with another body
func _on_Hitbox_body_exited(body: Node2D):
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			enimies.remove_at(enimies.find(body))


func _on_timer_timeout() -> void:
	for enemy in enimies:
		# THIS SHIT IS SO FUCKED, RANDOM ENTITIES ARE JUST ADDED EVEN IF THEY ARE NO WHERE NEAR THE COLLIDER.
		# BECAUSE GODOT IS SO SHIT WE HAVE TO DO STUPID CHECKS LIKE THE BELOW
		if not enemy == null:
			enemy.take_damage(damage_amount)
