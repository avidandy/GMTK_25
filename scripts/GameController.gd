extends Node

var damage_amount = 1
var level

func increase_damage():
	if damage_amount > 3:
		return
	else:
		damage_amount += 1
