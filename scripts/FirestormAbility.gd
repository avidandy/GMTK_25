extends Ability
class_name FirestormAbility

@export var firestorm_scene: PackedScene
@export var fireball_sound = "res://assets/sounds/fireball.wav"

func activate(owner: Node2D):
	
	if fs_level > 0:
		var firestorm1 = firestorm_scene.instantiate()
		firestorm1.global_position = owner.global_position
		firestorm1.position = Vector2.ZERO
		owner.add_child(firestorm1)
