extends Ability
class_name FireballAbility

@export var projectile_scene: PackedScene
@export var fireball_sound = "res://assets/sounds/fireball.wav"

func activate(owner: Node2D):
	if p_level > 0:
		GameController.level = p_level
		var projectile1 = projectile_scene.instantiate()
		AudioController.play_sound(fireball_sound, -5)
		projectile1.global_position = owner.global_position
		projectile1.direction = Vector2.UP
		owner.get_parent().add_child(projectile1)
	if p_level > 1:
		GameController.level = p_level
		var projectile2 = projectile_scene.instantiate()
		projectile2.global_position = owner.global_position
		projectile2.direction = Vector2.RIGHT
		owner.get_parent().add_child(projectile2)
	if p_level > 2:
		GameController.level = p_level
		var projectile3 = projectile_scene.instantiate()
		projectile3.global_position = owner.global_position
		projectile3.direction = Vector2.DOWN
		owner.get_parent().add_child(projectile3)
	if p_level > 3:
		GameController.level = 4
		var projectile4 = projectile_scene.instantiate()
		projectile4.global_position = owner.global_position
		projectile4.direction = Vector2.LEFT
		owner.get_parent().add_child(projectile4)
	if p_level > 4:
		GameController.level = p_level
		var projectile5 = projectile_scene.instantiate()
		projectile5.global_position = owner.global_position
		projectile5.direction = Vector2(-1, 1)
		owner.get_parent().add_child(projectile5)
	if p_level > 5:
		GameController.level = p_level
		var projectile6 = projectile_scene.instantiate()
		projectile6.global_position = owner.global_position
		projectile6.direction = Vector2(1, -1)
		owner.get_parent().add_child(projectile6)
	if p_level > 6:
		GameController.level = p_level
		var projectile7 = projectile_scene.instantiate()
		projectile7.global_position = owner.global_position
		projectile7.direction = Vector2(-1, -1)
		owner.get_parent().add_child(projectile7)
	if p_level > 7:
		GameController.level = p_level
		var projectile8 = projectile_scene.instantiate()
		projectile8.global_position = owner.global_position
		projectile8.direction = Vector2(1, 1)
		owner.get_parent().add_child(projectile8)
	if p_level > 8:
		GameController.level = p_level
		GameController.increase_damage()
		

#This is a specific instance of an ability that then overrides the empty one in ability.
#This file is put on to a 'resource' which then allows you to set the stats which are available due to being extended at the start
# of this script.
