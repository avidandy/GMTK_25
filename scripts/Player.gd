# scripts/Player.gd
extends CharacterBody2D

@export var speed = 400
@export var max_health: int = 100 # Add max health variable

var current_health: int = max_health: # Current health variable
	set(value):
		current_health = clampi(value, 0, max_health) # Clamp health between 0 and max_health
		health_changed.emit(current_health, max_health) # Emit signal when health changes
		if current_health <= 0:
			die() # Call die function if health is zero or less

# Signal to notify UI (and other interested nodes) about health changes
signal health_changed(current_health_val, max_health_val)

func _ready():
	add_to_group("player") # Add player to a group for easy lookup by enemies/spawner
	health_changed.emit(current_health, max_health) # Emit initial health state for UI

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

func take_damage(amount: int):
	current_health -= amount
	# You can add visual feedback here, e.g., modulate sprite color briefly
	print("Player took ", amount, " damage. Current health: ", current_health) # For debugging

func die():
	print("Player died! Game Over.")
	# Handle game over logic here (e.g., show game over screen, restart level)
	queue_free() # Remove player node
