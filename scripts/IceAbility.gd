extends Ability
class_name IceAbility

@export var aoe_scene: PackedScene
@onready var player = get_node("Player")

func activate(owner: Node2D):
	var aoe = aoe_scene.instantiate()
	aoe.global_position = owner.global_position
	owner.get_parent().add_child(aoe)

#This is a specific instance of an ability that then overrides the empty one in ability.
#This file is put on to a 'resource' which then allows you to set the stats which are available due to being extended at the start
# of this script.
