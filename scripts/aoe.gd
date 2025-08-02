extends Node2D

@onready var sprite: =$AnimatedSprite2D

func _ready() -> void:
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
	
