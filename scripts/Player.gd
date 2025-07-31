extends CharacterBody2D

@export var speed = 400
func _ready():
	add_to_group("player") # Add player to a group for easy lookup by enemies/spawner

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
