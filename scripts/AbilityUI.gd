class_name AbilityUI
extends TextureRect

enum AbilityType {
	FIRE,
	ICE,
	LIGHTNING,
	HOLY,
	NONE
}

@export var ability_atlas: AtlasTexture
@export var ability_regions: Dictionary = {
		AbilityType.FIRE: Rect2(),
		AbilityType.ICE: Rect2(),
		AbilityType.LIGHTNING: Rect2(),
		AbilityType.NONE: null
}

var current_ability_type: AbilityType = AbilityType.NONE

func set_ability_type(new_ability_type: AbilityType) -> void:
	if ability_regions.has(new_ability_type):
		current_ability_type = new_ability_type
		
		self.texture = ability_atlas
		
		ability_atlas.region = ability_regions[current_ability_type]
	else:
		push_warning("Invalid ability type: " + str(new_ability_type))
		ability_atlas.region = Rect2()
