extends Ability
class_name FirestormAbility

@export var firestorm_scene: PackedScene
@export var fireball_sound = "res://assets/sounds/fireball.wav"

func activate(owner: Node2D):
	if fs_level > 0:
		var firestorm1 = firestorm_scene.instantiate()
	#	AudioController.play_sound(fireball_sound)
		firestorm1.global_position = owner.global_position
		#firestorm1.direction = Vector2.UP
		owner.get_parent().add_child(firestorm1)
