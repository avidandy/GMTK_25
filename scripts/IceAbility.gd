extends Ability
class_name IceAbility

@export var aoe_scene: PackedScene

func activate(owner: Node2D):
	if a_level > 0:
		GameController.size = Vector2(5, 5)
		var aoe = aoe_scene.instantiate()
		aoe.global_position = owner.global_position
		owner.add_child(aoe)
		aoe.position = Vector2.ZERO
	if a_level > 1:
		GameController.size = Vector2(6, 6)
		var aoe = aoe_scene.instantiate()
		aoe.global_position = owner.global_position
		owner.add_child(aoe)
		aoe.position = Vector2.ZERO
	if a_level > 2:
		GameController.size = Vector2(7, 7)
		var aoe = aoe_scene.instantiate()
		aoe.global_position = owner.global_position
		owner.add_child(aoe)
		aoe.position = Vector2.ZERO
	if a_level > 3:
		GameController.size = Vector2(8, 8)
		var aoe = aoe_scene.instantiate()
		aoe.global_position = owner.global_position
		owner.add_child(aoe)
		aoe.position = Vector2.ZERO
	if a_level > 3:
		GameController.size = Vector2(10, 10)
		var aoe = aoe_scene.instantiate()
		aoe.global_position = owner.global_position
		owner.add_child(aoe)
		aoe.position = Vector2.ZERO

#This is a specific instance of an ability that then overrides the empty one in ability.
#This file is put on to a 'resource' which then allows you to set the stats which are available due to being extended at the start
# of this script.
