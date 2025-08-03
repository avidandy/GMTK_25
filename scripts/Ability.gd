extends Resource
class_name Ability


@export var name: String
@export var cooldown: float
@export var p_level: int = 1
@export var a_level: int = 1
@export var fs_level: int = 0
@export var damage: int = 10


func activate(owner : Node2D) -> void:
	pass




#SO, after a day of trying to understand this damn system I think i'm starting to get it. This script is the start. Essentially,
#it's an empty file - for all intensive purposes - that then gets overridden by a specific abilities stats etc.
