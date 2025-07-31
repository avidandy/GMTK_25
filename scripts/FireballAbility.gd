extends Ability
class_name FireballAbility

@export var projectile_scene: PackedScene

func activate(owner: Node2D):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = owner.global_position
	projectile.direction = Vector2.RIGHT
	owner.get_parent().add_child(projectile)


#This is a specific instance of an ability that then overrides the empty one in ability.
#This file is put on to a 'resource' which then allows you to set the stats which are available due to being extended at the start
# of this script.
