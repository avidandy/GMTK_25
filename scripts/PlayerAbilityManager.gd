extends Node

@export var abilities: Array[Ability] = [] #all abilities go here

var cooldowns: Dictionary = {}

func _process(delta: float) -> void:
	for current_ability: Ability in abilities:
		if not cooldowns.has(current_ability):
			cooldowns[current_ability] = 0.0
			
		cooldowns[current_ability] -= delta
	
		if cooldowns[current_ability] <= 0.0:
			current_ability.activate(get_parent())
			cooldowns[current_ability] = current_ability.cooldown
		
