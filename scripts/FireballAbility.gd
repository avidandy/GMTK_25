extends Ability
class_name FireballAbility

@export var projectile_scene: PackedScene

func activate(owner: Node2D):
	var projectile1 = projectile_scene.instantiate()
	projectile1.global_position = owner.global_position
	projectile1.direction = Vector2.UP
	owner.get_parent().add_child(projectile1)

	var projectile2 = projectile_scene.instantiate()
	projectile2.global_position = owner.global_position
	projectile2.direction = Vector2.RIGHT
	owner.get_parent().add_child(projectile2)
	
	var projectile3 = projectile_scene.instantiate()
	projectile3.global_position = owner.global_position
	projectile3.direction = Vector2.DOWN
	owner.get_parent().add_child(projectile3)
	
	var projectile4 = projectile_scene.instantiate()
	projectile4.global_position = owner.global_position
	projectile4.direction = Vector2.LEFT
	owner.get_parent().add_child(projectile4)

#This is a specific instance of an ability that then overrides the empty one in ability.
#This file is put on to a 'resource' which then allows you to set the stats which are available due to being extended at the start
# of this script.
